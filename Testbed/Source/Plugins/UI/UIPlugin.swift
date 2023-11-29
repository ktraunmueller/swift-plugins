import Plugins

import UIKit

/// Note: All protocol requirements should be declared `@MainActor`, since
/// they are all about interacting with the UI.
protocol UIPluginInterface: Actor, NotificationActivatedPlugin {
        
    @MainActor
    func presentOnRoot(_ viewController: UIViewController)
    @MainActor
    func dismissFromRoot()
    
    @MainActor
    func lockIntoSingleAppMode(completion: ((_ success: Bool) -> Void)?) async
    @MainActor
    func unlockFromSingleAppMode(completion: ((_ success: Bool) -> Void)?) async
}

actor UIPluginObject: UIPluginInterface, PluginLifecycle {
    
    @MainActor
    private weak var window: UIWindow?
    @MainActor
    private var endGuidedAccessSessionRetryCount = 0
    @MainActor
    private let endGuidedAccessSessionMaxRetries = 5
    
    init(window: UIWindow?) {
        self.window = window
        print("UIPlugin > UIPluginObject created 🎉")
    }
    
    deinit {
        print("UIPlugin > UIPluginObject destroyed 🗑️")
    }
    
    // MARK: - UIPluginInterface
    
    @MainActor
    func presentOnRoot(_ viewController: UIViewController) {
        print("UIPlugin > presentOnRoot()")
        guard let rootViewController = window?.rootViewController else {
            return
        }
        rootViewController.dismiss(animated: true, completion: {
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            rootViewController.present(viewController, animated: true)
        })
    }
    
    @MainActor
    func dismissFromRoot() {
        print("UIPlugin > dismissFromRoot()")
        guard let rootViewController = window?.rootViewController else {
            return
        }
        rootViewController.dismiss(animated: true)
    }
    
    @MainActor
    func lockIntoSingleAppMode(completion: ((Bool) -> Void)?) {
        endGuidedAccessSessionRetryCount = 0
        UIAccessibility.requestGuidedAccessSession(enabled: true) { success in
            completion?(success)
        }
    }
    
    @MainActor
    func unlockFromSingleAppMode(completion: ((Bool) -> Void)?) {
        UIAccessibility.requestGuidedAccessSession(enabled: true) { success in
            if success {
                completion?(true)
            } else {
                if self.endGuidedAccessSessionRetryCount < self.endGuidedAccessSessionMaxRetries {
                    self.endGuidedAccessSessionRetryCount += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.unlockFromSingleAppMode(completion: completion)
                    })
                } else {
                    completion?(false)
                }
            }
        }
    }
    
    // MARK: - NotificationActivatedPlugin
    
    @MainActor
    static let notifications: Set<NSNotification.Name> = [
        UIApplication.didFinishLaunchingNotification,
        UIApplication.willResignActiveNotification,
        UIApplication.didBecomeActiveNotification,
        UIAccessibility.guidedAccessStatusDidChangeNotification
    ]
    
    func handle(_ notification: Notification.Name) {
        print("UIPlugin > handling \(notification.rawValue) 📭")
    }
    
    // MARK: - PluginLifecycle
    
    private(set) var state: Plugins.PluginState = .stopped
    
    func acquireDependencies(from: PluginRegistry) async throws {
    }
    
    func releaseDependencies(in: PluginRegistry) async throws {
    }
    
    func markAsStarting() {
        state = .starting
    }
    
    func start() async throws {
        state = .started
    }
    
    func markAsStopping() {
        state = .stopping
    }
    
    func stop() async throws {
        state = .stopped
    }
}
