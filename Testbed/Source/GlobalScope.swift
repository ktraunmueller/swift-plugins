import UIKit

import Plugins

enum GlobalScope {
    
    static let pluginRegistry = PluginRegistry()
    
    // move elsewhere?
    static func registerPlugins(window: UIWindow?) {
        Task {
            do {
                try await pluginRegistry.register(UIPluginInterface.self,
                                                  activatedBy: UIPluginObject.notifications) {
                    return UIPluginObject(window: window)
                }
                try await pluginRegistry.register(TabUIPluginInterface.self) {
                    return TabUIPluginObject()
                }
                try await pluginRegistry.register(AppSwitcherPluginInterface.self) {
                    return AppSwitcherPluginObject()
                }
                try await pluginRegistry.register(ExamPluginInterface.self) {
                    return ExamPluginObject()
                }
                try await pluginRegistry.register(GraphingPluginInterface.self) {
                    return GraphingPluginObject()
                }
                try await pluginRegistry.register(GeometryPluginInterface.self) {
                    return GeometryPluginObject()
                }
            } catch let error {
                print(error)
            }
        }
    }
}
