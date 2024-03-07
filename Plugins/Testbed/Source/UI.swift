import Plugins

import UIKit

enum UI {
    
    @MainActor
    static func makeRootViewController() -> UIViewController? {
        do {
            let appSwitcherPluginHandle = try GlobalScope.pluginRegistry.lookup(AppSwitcherPluginInterface.self)
            let appSwitcherPlugin = try appSwitcherPluginHandle.acquire()
            let viewController = appSwitcherPlugin.appSwitcherViewController
            // note: the appSwitcherPlugin is never release()'d
            return viewController
        } catch let error {
            print(error)
        }
        return nil
    }
}
