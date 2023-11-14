import UIKit

enum UI {
    
    @MainActor
    static func makeTabBarController() async -> UITabBarController {
        var viewControllers: [UIViewController] = []
        do {
            let graphingPluginHandle = try GlobalScope.pluginRegistry.lookup(GraphingPluginInterface.self)
            let graphingPlugin = try await graphingPluginHandle.acquire()
            if let graphingCalculatorViewController = graphingPlugin.mainViewController {
                graphingCalculatorViewController.tabBarItem = UITabBarItem(title: "Graphing",
                                                                           image: UIImage(systemName: "pencil.tip"),
                                                                           tag: 0)
                viewControllers.append(UINavigationController(rootViewController: graphingCalculatorViewController))
            }
            
            let geometryPluginHandle = try GlobalScope.pluginRegistry.lookup(GeometryPluginInterface.self)
            let geometryPlugin = try await geometryPluginHandle.acquire()
            if let geometryCalculatorViewController = geometryPlugin.mainViewController {
                geometryCalculatorViewController.tabBarItem = UITabBarItem(title: "Geometry",
                                                                           image: UIImage(systemName: "tray"),
                                                                           tag: 0)
                viewControllers.append(UINavigationController(rootViewController: geometryCalculatorViewController))
            }
        } catch let error {
            print(error)
        }
        
//        let viewController1 = ViewController1(nibName: nil, bundle: nil)
//        viewController1.tabBarItem = UITabBarItem(title: "View1",
//                                                  image: UIImage(systemName: "folder"),
//                                                  tag: 0)
//        viewControllers.append(viewController1)
        
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .white
        tabBarController.viewControllers = viewControllers
        return tabBarController
    }
}
