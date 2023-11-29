import Plugins

import UIKit

protocol GeometryPluginInterface: Actor {
    // dependencies
    var appSwitcherPlugin: AppSwitcherPluginInterface? { get }
    
    var mainViewController: UIViewController? { get }
}

actor GeometryPluginObject: GeometryPluginInterface, PluginLifecycle {

    init() {
        print("GeometryPlugin > GeometryPluginObject created 🎉")
    }
    
    deinit {
        print("GeometryPlugin > GeometryPluginObject destroyed 🗑️")
    }
    
    func closeApp() {
        Task {
            await appSwitcherPlugin?.closeCurrentApp()
        }
    }
    
    // MARK: - GeometryPluginInterface
        
    private(set) var appSwitcherPlugin: AppSwitcherPluginInterface?
    
    private(set) var mainViewController: UIViewController?
    
    // MARK: - PluginLifecycle
    
    private(set) var state: Plugins.PluginState = .stopped
    
    func acquireDependencies(from registry: PluginRegistry) async throws {
        let appSwitcherPluginHandle = try registry.lookup(AppSwitcherPluginInterface.self)
        appSwitcherPlugin = try await appSwitcherPluginHandle.acquire()
    }
    
    func releaseDependencies(in registry: PluginRegistry) async throws {
        let appSwitcherPluginHandle = try registry.lookup(AppSwitcherPluginInterface.self)
        try await appSwitcherPluginHandle.release()
        appSwitcherPlugin = nil
    }
    
    func markAsStarting() {
        state = .starting
    }
    
    func start() async throws {
        mainViewController = await MainActor.run {
            GeometryCalculatorViewController(plugin: self)
        }
        state = .started
    }
    
    func markAsStopping() {
        state = .stopping
    }
    
    func stop() async throws {
        mainViewController = nil
        state = .stopped
    }
}
