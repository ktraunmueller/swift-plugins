import UIKit

final class ViewController1: UIViewController {

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController1: viewDidLoad")
        
        view.backgroundColor = .magenta.withAlphaComponent(0.2)
    }
}

