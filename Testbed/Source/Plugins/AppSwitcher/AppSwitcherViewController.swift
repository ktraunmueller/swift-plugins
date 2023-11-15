import UIKit

@MainActor
final class AppSwitcherViewController: UIViewController {

    deinit {
        print("AppSwitcherViewController destroyed 🗑️")
    }
    
    // MARK: - UIViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        print("AppSwitcherViewController created 🎉")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("AppSwitcherViewController: viewDidLoad")
        
        view.backgroundColor = UIColor(red: 1.0, green: (0xcd / 255.0), blue: (0xd2 / 255.0), alpha: 1)
        title = "AppSwitcher"
    }
}
