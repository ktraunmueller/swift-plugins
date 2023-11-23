import Plugins

import UIKit

protocol UIPluginInterface: AnyObject {
        
    func presentOnRoot(_ viewController: UIViewController)
    func dismissFromRoot()
}

final class UIPluginObject: UIPluginInterface, PluginLifecycle {
    
    private weak var window: UIWindow?
    
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
