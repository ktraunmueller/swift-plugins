import Plugins

enum GlobalScope {
    
    static let pluginRegistry = PluginRegistry()
    
    // move elsewhere?
    static func registerPlugins() {
        do {
            try GlobalScope.pluginRegistry.register(UIPluginInterface.self) {
                return UIPlugin()
            }
            try GlobalScope.pluginRegistry.register(GraphingCalculatorPluginInterface.self) {
                return GraphingCalculatorPlugin()
            }
        } catch let error {
            print(error)
        }
    }
}
