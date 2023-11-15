import Plugins

import UIKit

enum UI {
    
    @MainActor
    static func makeAppSwitcherViewController() async -> UIViewController? {
        do {
            let appSwitcherPluginHandle = try GlobalScope.pluginRegistry.lookup(AppSwitcherPluginInterface.self)
            let appSwitcherPlugin = try await appSwitcherPluginHandle.acquire()
            let viewController = appSwitcherPlugin.appSwitcherViewController
            // note: the appSwitcherPluginHandle is never release()'ed
            return viewController
        } catch let error {
            print(error)
        }
        return nil
    }
}
