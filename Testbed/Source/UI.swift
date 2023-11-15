import Plugins

import UIKit

enum UI {
    
    @MainActor
    static func makeAppSwitcherViewController() async -> UIViewController? {
        do {
            let appSwitcherPluginHandle = try GlobalScope.pluginRegistry.lookup(AppSwitcherPluginInterface.self)
            let appSwitcherPlugin = try await appSwitcherPluginHandle.acquire()
            let viewController = appSwitcherPlugin.appSwitcherViewController
            return viewController
        } catch let error {
            print(error)
        }
        return nil
    }
    
//    @MainActor
//    static func makeTabBarController() async -> UITabBarController {
//        var viewControllers: [UIViewController] = []
//        do {
//            let graphingPluginHandle = try GlobalScope.pluginRegistry.lookup(GraphingPluginInterface.self)
//            let graphingPlugin = try await graphingPluginHandle.acquire()
//            if let graphingCalculatorViewController = graphingPlugin.mainViewController {
//                graphingCalculatorViewController.tabBarItem = UITabBarItem(title: "Graphing",
//                                                                           image: UIImage(systemName: "pencil.tip"),
//                                                                           tag: 0)
//                viewControllers.append(UINavigationController(rootViewController: graphingCalculatorViewController))
//            }
//            
//            let geometryPluginHandle = try GlobalScope.pluginRegistry.lookup(GeometryPluginInterface.self)
//            let geometryPlugin = try await geometryPluginHandle.acquire()
//            if let geometryCalculatorViewController = geometryPlugin.mainViewController {
//                geometryCalculatorViewController.tabBarItem = UITabBarItem(title: "Geometry",
//                                                                           image: UIImage(systemName: "tray"),
//                                                                           tag: 0)
//                viewControllers.append(UINavigationController(rootViewController: geometryCalculatorViewController))
//            }
//        } catch let error {
//            print(error)
//        }
//        
//        let tabBarController = UITabBarController()
//        tabBarController.view.backgroundColor = .white
//        tabBarController.viewControllers = viewControllers
//        return tabBarController
//    }
}
