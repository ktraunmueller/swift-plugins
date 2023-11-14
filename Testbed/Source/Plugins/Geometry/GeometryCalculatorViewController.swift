import UIKit

@MainActor
final class GeometryCalculatorViewController: UIViewController {

    deinit {
        print("--- GeometryCalculatorViewController destroyed ---")
    }
    
    // MARK: - UIViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        print("+++ GeometryCalculatorViewController created +++")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GeometryCalculatorViewController: viewDidLoad")
        
        view.backgroundColor = .orange.withAlphaComponent(0.2)
        title = "Geometry"
    }
}
