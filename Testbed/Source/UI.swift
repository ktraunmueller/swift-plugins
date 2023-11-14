import UIKit

enum UI {
    
    @MainActor
    static func makeTabBarController() async -> UITabBarController {
        var viewControllers: [UIViewController] = []
        do {
            let graphingCalculatorPluginHandle = try GlobalScope.pluginRegistry.lookup(GraphingCalculatorPluginInterface.self)
            let graphingCalculatorPlugin = try await graphingCalculatorPluginHandle.acquire()
            if let graphingCalculatorViewController = graphingCalculatorPlugin.mainViewController {
                graphingCalculatorViewController.tabBarItem = UITabBarItem(title: "Graphing",
                                                                           image: UIImage(systemName: "pencil.tip"),
                                                                           tag: 0)
                viewControllers.append(graphingCalculatorViewController)
            }
        } catch let error {
            print(error)
        }
        
        let viewController1 = ViewController1(nibName: nil, bundle: nil)
        viewController1.tabBarItem = UITabBarItem(title: "View1",
                                                  image: UIImage(systemName: "folder"),
                                                  tag: 0)
        viewControllers.append(viewController1)
        
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .white
        tabBarController.viewControllers = viewControllers
        return tabBarController
    }
}
