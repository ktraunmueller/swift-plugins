import Plugins

import UIKit

protocol UIPluginInterface: AnyObject {
    
//    func present(dialog: UIViewController)
}

final class UIPluginObject: UIPluginInterface, PluginLifecycle {
    
    init() {
        print("UIPluginObject created 🎉")
    }
    
    deinit {
        print("UIPluginObject destroyed 🗑️")
    }
    
    // MARK: - UIPluginInterface
        
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
