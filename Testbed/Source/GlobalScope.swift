import Plugins

enum GlobalScope {
    
    static let pluginRegistry = PluginRegistry()
    
    // move elsewhere?
    static func registerPlugins() {
        do {
            try pluginRegistry.register(UIPluginInterface.self) {
                return UIPlugin()
            }
            try pluginRegistry.register(GraphingPluginInterface.self) {
                return GraphingPlugin()
            }
            try pluginRegistry.register(GeometryPluginInterface.self) {
                return GeometryPlugin()
            }
        } catch let error {
            print(error)
        }
    }
}
