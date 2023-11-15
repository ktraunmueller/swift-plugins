import UIKit

import Plugins

enum GlobalScope {
    
    static let pluginRegistry = PluginRegistry()
    
    // move elsewhere?
    static func registerPlugins(window: UIWindow?) {
        do {
            try pluginRegistry.register(UIPluginInterface.self) {
                return UIPluginObject(window: window)
            }
            try pluginRegistry.register(TabUIPluginInterface.self) {
                return TabUIPluginObject()
            }
            try pluginRegistry.register(AppSwitcherPluginInterface.self) {
                return AppSwitcherPluginObject()
            }
            try pluginRegistry.register(GraphingPluginInterface.self) {
                return GraphingPluginObject()
            }
            try pluginRegistry.register(GeometryPluginInterface.self) {
                return GeometryPluginObject()
            }
        } catch let error {
            print(error)
        }
    }
}
