import UIKit

final class GeometryCalculatorViewController: UIViewController {

    private weak var plugin: GeometryPluginObject?
    
    init(plugin: GeometryPluginObject) {
        self.plugin = plugin
        super.init(nibName: nil, bundle: nil)
        
        print("GeometryPlugin > GeometryCalculatorViewController created 🎉")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("GeometryPlugin > GeometryCalculatorViewController destroyed 🗑️")
    }
    
    @objc private func closeScreen() {
        Task {
            await plugin?.closeApp()
        }
    }
    
    // MARK: - UIViewController
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GeometryPlugin > GeometryCalculatorViewController.viewDidLoad")
        
        view.backgroundColor = UIColor(red: 1.0, green: (0xcd / 255.0), blue: (0xd2 / 255.0), alpha: 1)
        title = "Geometry"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.square"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(closeScreen))
    }
}
