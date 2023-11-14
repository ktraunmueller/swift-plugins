/// A lightweight handle to a plugin.
///
/// The plugin handle transparently handles the plugin lifecycle,
/// and hides the concrete plugin object type from clients.
public final class PluginHandle<PluginInterface> {
    
    private let pluginObject: PluginLifecycle
    private weak var registry: PluginRegistry?
    private(set) var usageCount = 0 // accessible only for testing
    
    init(pluginObject: PluginLifecycle, pluginInterfaceType: PluginInterface.Type, registry: PluginRegistry) {
        self.pluginObject = pluginObject
        self.registry = registry
    }
    
    /// Acquires a reference to the plugin interface.
    ///
    /// This will start the plugin if it is currently stopped.
    public func acquire() async throws -> PluginInterface {
        if pluginObject.state == .stopped {
            do {
                pluginObject.markAsStarting()
                try await pluginObject.start()
                assert(pluginObject.state == .started)
                usageCount += 1
            }
            catch let error {
                throw error
            }
        }
        return pluginObject as! PluginInterface
    }
    
    /// Releases a reference to the plugin interface.
    ///
    /// If this brings the plugin's usage count to zero, the plugin
    /// will be stopped.
    public func release() async throws {
        if pluginObject.state == .started {
            usageCount -= 1
            if usageCount == 0 {
                do {
                    pluginObject.markAsStopping()
                    try await pluginObject.stop()
                    assert(pluginObject.state == .stopped)
                }
                catch let error {
                    throw error
                }
            }
        }
    }
}
