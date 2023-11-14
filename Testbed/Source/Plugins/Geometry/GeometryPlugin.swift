import Plugins

import UIKit

protocol GeometryPluginInterface: AnyObject {
    
    // dependencies
    var uiPlugin: UIPluginInterface? { get }
    
    var mainViewController: UIViewController? { get }
}

final class GeometryPlugin: GeometryPluginInterface, PluginLifecycle {

    init() {
        print("+++ GeometryPlugin +++")
    }
    
    deinit {
        print("--- GeometryPlugin ---")
    }
    
    // MARK: - GeometryPluginInterface
        
    private(set) var uiPlugin: UIPluginInterface?
    
    private(set) var mainViewController: UIViewController?
    
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
        mainViewController = await MainActor.run {
            UIViewController(nibName: nil, bundle: nil)
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
