import Plugins

enum GlobalScope {
    
    static let pluginRegistry = PluginRegistry()
    
    // move elsewhere?
    static func registerPlugins() {
        do {
            try GlobalScope.pluginRegistry.register(UIPluginInterface.self) {
                return UIPlugin()
            }
            try GlobalScope.pluginRegistry.register(GraphingPluginInterface.self,
                                                    dependencies: [UIPluginInterface.self]) {
                return GraphingPlugin()
            }
            try GlobalScope.pluginRegistry.register(GeometryPluginInterface.self,
                                                    dependencies: [UIPluginInterface.self]) {
                return GeometryPlugin()
            }
        } catch let error {
            print(error)
        }
    }
}
