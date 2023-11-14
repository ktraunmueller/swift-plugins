import Plugins

import UIKit

protocol GraphingCalculatorPluginInterface: AnyObject {
    
    var mainViewController: UIViewController? { get }
}

final class GraphingCalculatorPlugin: GraphingCalculatorPluginInterface, PluginLifecycle {
    
    init() {
        print("+++ GraphingCalculatorPlugin +++")
    }
    
    deinit {
        print("--- GraphingCalculatorPlugin ---")
    }
    
    // MARK: - GraphingCalculatorPluginInterface
        
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
