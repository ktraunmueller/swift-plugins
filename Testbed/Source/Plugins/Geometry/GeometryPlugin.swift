import Plugins

import UIKit

protocol GeometryPluginInterface: AnyObject {
    
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
        
    private(set) var mainViewController: UIViewController?
    
    // MARK: - PluginLifecycle
    
    private(set) var state: Plugins.PluginState = .stopped
    
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
