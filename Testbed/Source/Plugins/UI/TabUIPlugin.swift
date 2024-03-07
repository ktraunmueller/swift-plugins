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
    
    func acquireDependencies(from registry: PluginRegistry) throws {
        let uiPluginHandle = try registry.lookup(UIPluginInterface.self)
        uiPlugin = try uiPluginHandle.acquire()
    }
    
    func releaseDependencies(in registry: PluginRegistry) throws {
        let uiPluginHandle = try registry.lookup(UIPluginInterface.self)
        try uiPluginHandle.release()
        uiPlugin = nil
    }
    
    func start() throws {
        state = .started
    }
    
    func stop() throws {
        state = .stopped
    }
}
