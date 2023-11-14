import UIKit

@MainActor
final class GraphingCalculatorViewController: UIViewController {

    deinit {
        print("--- GraphingCalculatorViewController ---")
    }
    
    // MARK: - UIViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        print("+++ GraphingCalculatorViewController +++")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GraphingCalculatorViewController: viewDidLoad")
        
        view.backgroundColor = .cyan.withAlphaComponent(0.2)
    }
}
