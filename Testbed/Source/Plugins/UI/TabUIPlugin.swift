import Plugins

import UIKit

protocol TabUIPluginInterface: AnyObject {
    // dependencies
    var uiPlugin: UIPluginInterface? { get }
    
    var tabBarController: UITabBarController? { get }
}

final class TabUIPluginObject: TabUIPluginInterface, PluginLifecycle {
    
    init() {
        print("TabUIPlugin > TabUIPluginObject created 🎉")
    }
    
    deinit {
        print("TabUIPlugin > TabUIPluginObject destroyed 🗑️")
    }
    
    // MARK: - TabUIPluginInterface
        
    private(set) var uiPlugin: UIPluginInterface?
    
    private(set) var tabBarController: UITabBarController?
    
    // MARK: - PluginLifecycle
    
    private(set) var state: Plugins.PluginState = .stopped
    
    func acquireDependencies(from registry: PluginRegistry) async throws {
        let uiPluginHandle = try registry.lookup(UIPluginInterface.self)
        uiPlugin = try await uiPluginHandle.acquire()
    }
    
    func releaseDependencies(in registry: PluginRegistry) async throws {
        let uiPluginHandle = try registry.lookup(UIPluginInterface.self)
        try await uiPluginHandle.release()
        uiPlugin = nil
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
