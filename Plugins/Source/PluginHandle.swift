/// A ``PluginHandle`` is a lightweight handle to a plugin.
///
/// The plugin handle transparently handles the plugin lifecycle.
public final class PluginHandle<PluginInterface> {
    
    private let pluginObject: PluginLifecycle
    private var state: PluginState = .stopped
    
    init(pluginObject: PluginLifecycle, pluginInterfaceType: PluginInterface.Type) {
        self.pluginObject = pluginObject
    }
    
    /// Returns the plugin interface.
    ///
    /// Starts the plugin if it is currently stopped.
    public func get() /*async*/ throws -> PluginInterface {
        if pluginObject.state == .stopped {
            do {
                try pluginObject.start()
                assert(pluginObject.state == .started)
            }
            catch let error {
                throw error
            }
        }
        return pluginObject as! PluginInterface
    }
}
