import Plugins

import UIKit

protocol AppSwitcherPluginInterface: AnyObject {
    // dependencies
    var uiPlugin: UIPluginInterface? { get }
    var geometryPlugin: GeometryPluginInterface? { get }
    var graphingPlugin: GraphingPluginInterface? { get }
    
    var appSwitcherViewController: UIViewController? { get }
}

final class AppSwitcherPluginObject: AppSwitcherPluginInterface, PluginLifecycle {
    
    init() {
        print("AppSwitcherPluginObject created 🎉")
    }
    
    deinit {
        print("AppSwitcherPluginObject destroyed 🗑️")
    }
    
    // MARK: - AppSwitcherPluginInterface
        
    private(set) var uiPlugin: UIPluginInterface?
    private(set) var geometryPlugin: GeometryPluginInterface?
    private(set) var graphingPlugin: GraphingPluginInterface?
    
    private(set) var appSwitcherViewController: UIViewController?
    
    // MARK: - PluginLifecycle
    
    private(set) var state: Plugins.PluginState = .stopped
    
    func acquireDependencies(from registry: PluginRegistry) async throws {
        let uiPluginHandle = try registry.lookup(UIPluginInterface.self)
        uiPlugin = try await uiPluginHandle.acquire()
        
        let geometryPluginHandle = try registry.lookup(GeometryPluginInterface.self)
        geometryPlugin = try await geometryPluginHandle.acquire()
        
        let graphingPluginHandle = try registry.lookup(GraphingPluginInterface.self)
        graphingPlugin = try await graphingPluginHandle.acquire()
    }
    
    func releaseDependencies(in registry: PluginRegistry) async throws {
        let uiPluginHandle = try registry.lookup(UIPluginInterface.self)
        try await uiPluginHandle.release()
        uiPlugin = nil
        
        let geometryPluginHandle = try registry.lookup(GeometryPluginInterface.self)
        try await geometryPluginHandle.release()
        geometryPlugin = nil
        
        let graphingPluginHandle = try registry.lookup(GraphingPluginInterface.self)
        try await graphingPluginHandle.release()
        graphingPlugin = nil
    }
    
    func markAsStarting() {
        state = .starting
    }
    
    func start() async throws {
        appSwitcherViewController = await MainActor.run {
            AppSwitcherViewController(nibName: nil, bundle: nil)
        }
        state = .started
    }
    
    func markAsStopping() {
        state = .stopping
    }
    
    func stop() async throws {
        state = .stopped
    }
}
