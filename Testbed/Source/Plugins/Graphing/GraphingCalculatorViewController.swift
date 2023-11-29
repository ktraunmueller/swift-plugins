import UIKit

@MainActor
final class GraphingCalculatorViewController: UIViewController {

    private weak var plugin: GraphingPluginObject?
    
    init(plugin: GraphingPluginObject) {
        self.plugin = plugin
        super.init(nibName: nil, bundle: nil)
        
        print("GraphingPlugin > GraphingCalculatorViewController created 🎉")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("GraphingPlugin > GraphingCalculatorViewController destroyed 🗑️")
    }
    
    @objc private func closeScreen() {
        Task {
            await plugin?.closeApp()
        }
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GraphingPlugin > GraphingCalculatorViewController.viewDidLoad")
        
        view.backgroundColor = UIColor(red: (0xB2 / 255.0), green: (0xEB / 255.0), blue: (0xF2 / 255.0), alpha: 1)
        title = "Graphing"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.square"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(closeScreen))
    }
}
