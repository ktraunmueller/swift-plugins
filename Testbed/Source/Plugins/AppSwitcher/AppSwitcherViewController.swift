import UIKit

@MainActor
final class AppSwitcherViewController: UIViewController {

    private weak var plugin: AppSwitcherPluginObject?
    
    init(plugin: AppSwitcherPluginObject) {
        self.plugin = plugin
        super.init(nibName: nil, bundle: nil)
        
        print("AppSwitcherViewController created 🎉")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("AppSwitcherViewController destroyed 🗑️")
    }
    
    private func setupAppButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        let geometryButton = UIButton()
        geometryButton.setImage(UIImage(systemName: "triangle"), for: .normal)
        geometryButton.setTitleColor(.black, for: .normal)
        geometryButton.setTitle("Geometry", for: .normal)
        geometryButton.addTarget(self, action: #selector(geometryButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(geometryButton)
        
        let graphingButton = UIButton()
        graphingButton.setImage(UIImage(systemName: "chart.xyaxis.line"), for: .normal)
        graphingButton.setTitleColor(.black, for: .normal)
        graphingButton.setTitle("Graphing", for: .normal)
        graphingButton.addTarget(self, action: #selector(grahpingButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(graphingButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: Actions
    
    @objc private func geometryButtonTapped() {
        plugin?.switchToGeometry()
    }
    
    @objc private func grahpingButtonTapped() {
        plugin?.switchToGraphing()
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("AppSwitcherViewController: viewDidLoad")
        
        view.backgroundColor = .white
        title = "AppSwitcher"
        
        setupAppButtons()
    }
}
