import UIKit

@MainActor
final class ViewController1: UIViewController {

    deinit {
        print("--- ViewController1 destroyed ---")
    }
    
    // MARK: - UIViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        print("+++ ViewController1 created +++")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController1: viewDidLoad")
        
        view.backgroundColor = .magenta.withAlphaComponent(0.2)
    }
}

