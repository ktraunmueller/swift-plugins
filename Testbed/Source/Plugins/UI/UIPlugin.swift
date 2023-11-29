import Plugins

import UIKit

protocol UIPluginInterface: AnyObject, NotificationActivatedPlugin {
        
    func registerNotifications()
    
    func presentOnRoot(_ viewController: UIViewController)
    func dismissFromRoot()
    
    func lockIntoSingleAppMode(completion: ((_ success: Bool) -> Void)?)
    func unlockFromSingleAppMode(completion: ((_ success: Bool) -> Void)?)
}

final class UIPluginObject: UIPluginInterface, PluginLifecycle {
    
    private weak var window: UIWindow?
    private var endGuidedAccessSessionRetryCount = 0
    private let endGuidedAccessSessionMaxRetries = 5
    
    init(window: UIWindow?) {
        self.window = window
        print("UIPlugin > UIPluginObject created 🎉")
    }
    
    deinit {
        print("UIPlugin > UIPluginObject destroyed 🗑️")
    }
    
    // MARK: Notifications
    
    @objc
    private func applicationDidFinishLaunching() {
    }
    
    @objc
    private func applicationDidBecomeActive() {
    }
    
    @objc
    private func applicationWillResignActive() {
    }
    
    @objc
    private func guidedAccessStatusDidChange() {
        //UIAccessibility.isGuidedAccessEnabled
    }
    
    // MARK: - UIPluginInterface
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidFinishLaunching),
                                               name: UIApplication.didFinishLaunchingNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.applicationWillResignActive),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(guidedAccessStatusDidChange),
                                               name: UIAccessibility.guidedAccessStatusDidChangeNotification,
                                               object: nil)
    }
    
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
    
    func dismissFromRoot() {
        print("UIPlugin > dismissFromRoot()")
        guard let rootViewController = window?.rootViewController else {
            return
        }
        rootViewController.dismiss(animated: true)
    }
    
    func lockIntoSingleAppMode(completion: ((Bool) -> Void)?) {
        endGuidedAccessSessionRetryCount = 0
        UIAccessibility.requestGuidedAccessSession(enabled: true) { success in
            completion?(success)
        }
    }
    
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
    
    static let notifications: Set<NSNotification.Name> = [
        UIApplication.didFinishLaunchingNotification,
        UIApplication.willResignActiveNotification,
        UIApplication.didBecomeActiveNotification,
        UIAccessibility.guidedAccessStatusDidChangeNotification
    ]
    
    func handle(_ notification: Notification) {
        print("UIPlugin > handling \(notification.name.rawValue) 📭")
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
