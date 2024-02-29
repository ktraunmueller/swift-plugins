import Plugins

import UIKit

protocol UIPluginInterface: AnyObject {
        
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
    
    // MARK: - UIPluginInterface
    
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
    
    // MARK: - PluginLifecycle
    
    private(set) var state: Plugins.PluginState = .stopped
    
    func acquireDependencies(from: PluginRegistry) throws {
    }
    
    func releaseDependencies(in: PluginRegistry) throws {
    }
    
    func start() throws {
        state = .started
    }
    
    func stop() throws {
        state = .stopped
    }
}
