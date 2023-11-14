import Plugins

import UIKit

protocol GraphingPluginInterface: AnyObject {
    
    var mainViewController: UIViewController? { get }
}

final class GraphingPlugin: GraphingPluginInterface, PluginLifecycle {
    
    init() {
        print("+++ GraphingPlugin +++")
    }
    
    deinit {
        print("--- GraphingPlugin ---")
    }
    
    // MARK: - GraphingPluginInterface
        
    private(set) var mainViewController: UIViewController?
    
    // MARK: - PluginLifecycle
    
    private(set) var state: Plugins.PluginState = .stopped
    
    func markAsStarting() {
        state = .starting
    }
    
    func start() async throws {
        mainViewController = await MainActor.run {
            GraphingCalculatorViewController(nibName: nil, bundle: nil)
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
