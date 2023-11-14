import UIKit

@MainActor
final class GraphingCalculatorViewController: UIViewController {

    deinit {
        print("--- GraphingCalculatorViewController destroyed ---")
    }
    
    @objc
    private func shutdownGeometryPlugin() {
        print("GraphingCalculatorViewController: shutdownGeometryPlugin")
        Task {
            do {
                let geometryPluginHandle = try GlobalScope.pluginRegistry.lookup(GeometryPluginInterface.self)
                try await geometryPluginHandle.release()
            } catch let error {
                print(error)
            }
        }
    }
    
    // MARK: - UIViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        print("+++ GraphingCalculatorViewController created +++")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GraphingCalculatorViewController: viewDidLoad")
        
        view.backgroundColor = .cyan.withAlphaComponent(0.2)
        title = "Graphing"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "stop.circle"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(shutdownGeometryPlugin))
    }
}
