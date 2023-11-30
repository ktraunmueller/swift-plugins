import UIKit

import Plugins

enum GlobalScope {
    
    static private(set) var pluginRegistry = PluginRegistry()
    
    // move elsewhere?
    static func registerPlugins(window: UIWindow?) {
        do {
            var plugins: PluginRegistry.Plugins = [:]
            try PluginRegistry.append(to: &plugins, UIPluginInterface.self) {
                return UIPluginObject(window: window)
            }
            try PluginRegistry.append(to: &plugins, TabUIPluginInterface.self) {
                return TabUIPluginObject()
            }
            try PluginRegistry.append(to: &plugins, AppSwitcherPluginInterface.self) {
                return AppSwitcherPluginObject()
            }
            try PluginRegistry.append(to: &plugins, ExamPluginInterface.self) {
                return ExamPluginObject()
            }
            try PluginRegistry.append(to: &plugins, GraphingPluginInterface.self) {
                return GraphingPluginObject()
            }
            try PluginRegistry.append(to: &plugins, GeometryPluginInterface.self) {
                return GeometryPluginObject()
            }
            pluginRegistry = PluginRegistry(plugins)
        } catch let error {
            print(error)
        }
    }
}
