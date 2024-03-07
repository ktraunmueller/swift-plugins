import Plugins

import UIKit

protocol GraphingPluginInterface: AnyObject {
    // dependencies
    var appSwitcherPlugin: AppSwitcherPluginInterface? { get }
    
    var mainViewController: UIViewController? { get }
}

final class GraphingPluginObject: GraphingPluginInterface, PluginLifecycle {
    
    init() {
        print("GraphingPlugin > GraphingPluginObject created 🎉")
    }
    
    deinit {
        print("GraphingPlugin > GraphingPluginObject destroyed 🗑️")
    }
    
    func closeApp() {
        appSwitcherPlugin?.closeCurrentApp()
    }
    
    // MARK: - GraphingPluginInterface
        
    private(set) var appSwitcherPlugin: AppSwitcherPluginInterface?
    
    private(set) var mainViewController: UIViewController?
    
    // MARK: - PluginLifecycle
    
    private(set) var state: Plugins.PluginState = .stopped
    
    func acquireDependencies(from registry: PluginRegistry) throws {
        let appSwitcherPluginHandle = try registry.lookup(AppSwitcherPluginInterface.self)
        appSwitcherPlugin = try appSwitcherPluginHandle.acquire()
    }
    
    func releaseDependencies(in registry: PluginRegistry) throws {
        let appSwitcherPluginHandle = try registry.lookup(AppSwitcherPluginInterface.self)
        try appSwitcherPluginHandle.release()
        appSwitcherPlugin = nil
    }
    
    func start() throws {
        mainViewController = GraphingCalculatorViewController(plugin: self)
        state = .started
    }
    
    func stop() throws {
        mainViewController = nil
        state = .stopped
    }
}
