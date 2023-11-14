import Plugins

import UIKit

protocol GraphingCalculatorPluginInterface: AnyObject {
    
    var mainViewController: UIViewController { get }
}

final class GraphingCalculatorPlugin: GraphingCalculatorPluginInterface, PluginLifecycle {
    
    // MARK: - GraphingCalculatorPluginInterface
        
    private(set) lazy var mainViewController: UIViewController = GraphingCalculatorViewController(nibName: nil, bundle: nil)
    
    // MARK: - PluginLifecycle
    
    private(set) var state: Plugins.PluginState = .stopped
    
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
