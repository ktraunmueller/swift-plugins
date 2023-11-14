import Plugins

import UIKit

@main
final class AppDelegate: NSObject, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow()
    
    private func makeTabBarController() async -> UITabBarController {
        var viewControllers: [UIViewController] = []
        do {
            let graphingCalculatorPluginHandle = try GlobalScope.pluginRegistry.lookup(GraphingCalculatorPluginInterface.self)
            let graphingCalculatorPlugin = try await graphingCalculatorPluginHandle.acquire()
            let graphingCalculatorViewController = graphingCalculatorPlugin.mainViewController
            graphingCalculatorViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)
            viewControllers.append(graphingCalculatorViewController)
        } catch let error {
            print(error)
        }
        
        let viewController1 = ViewController1(nibName: nil, bundle: nil)
        viewController1.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        viewControllers.append(viewController1)
        
        let tabBarController = UITabBarController()
        tabBarController.view.backgroundColor = .white
        tabBarController.viewControllers = viewControllers
        return tabBarController
    }
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerPlugins()
        
        Task {
            window?.rootViewController = await makeTabBarController()
            window?.makeKeyAndVisible()
        }
        
        return true
    }
}

