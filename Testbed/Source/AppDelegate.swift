import Plugins

import UIKit

@main
final class AppDelegate: NSObject, UIApplicationDelegate {

    lazy var window: UIWindow? = UIWindow()
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GlobalScope.registerPlugins(window: window)
        
        window?.rootViewController = UI.makeRootViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

