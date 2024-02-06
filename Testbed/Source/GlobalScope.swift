import UIKit

import Plugins

enum GlobalScope {
    
    static private(set) var pluginRegistry = PluginRegistry(registrations: [:])
    
    // move elsewhere?
    static func registerPlugins(window: UIWindow?) {
        do {
            var registrations = PluginRegistry.Registrations()
            try PluginRegistry.register(UIPluginInterface.self, with: &registrations) {
                return UIPluginObject(window: window)
            }
            try PluginRegistry.register(TabUIPluginInterface.self, with: &registrations) {
                return TabUIPluginObject()
            }
            try PluginRegistry.register(AppSwitcherPluginInterface.self, with: &registrations) {
                return AppSwitcherPluginObject()
            }
            try PluginRegistry.register(ExamPluginInterface.self, with: &registrations) {
                return ExamPluginObject()
            }
            try PluginRegistry.register(GraphingPluginInterface.self, with: &registrations) {
                return GraphingPluginObject()
            }
            try PluginRegistry.register(GeometryPluginInterface.self, with: &registrations) {
                return GeometryPluginObject()
            }
            pluginRegistry = PluginRegistry(registrations: registrations)
        } catch let error {
            print(error)
        }
    }
}
