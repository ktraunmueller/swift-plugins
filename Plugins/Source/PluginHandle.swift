/// A lightweight handle to a plugin.
///
/// The plugin handle transparently handles the plugin lifecycle,
/// and hides the concrete plugin object type from clients.
public final class PluginHandle<PluginInterface> {
    
    private let pluginObject: PluginLifecycle
    private weak var registry: PluginRegistry?
    private(set) var isValid = true
    
    init(pluginObject: PluginLifecycle, pluginInterfaceType: PluginInterface.Type, registry: PluginRegistry) {
        self.pluginObject = pluginObject
        self.registry = registry
    }
    
    /// Acquires a reference to the plugin interface.
    ///
    /// This will start the plugin if it is currently stopped.
    public func acquire() async throws -> PluginInterface {
        guard isValid else {
            throw PluginError.invalidHandle
        }
        if pluginObject.state == .stopped {
            do {
                try await pluginObject.start()
                assert(pluginObject.state == .started)
                pluginObject.incrementUsageCount()
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
    /// will be stopped (and the plugin object deallocated), and the plugin registry will discard this
    /// plugin handle (which renders it invalid).
    public func release() async throws {
        guard isValid else {
            throw PluginError.invalidHandle
        }
        if pluginObject.state == .started {
            pluginObject.decrementUsageCount()
            if pluginObject.usageCount == 0 {
                do {
                    try await pluginObject.stop()
                    assert(pluginObject.state == .stopped)
                    registry?.discard(self)
                    isValid = false
                }
                catch let error {
                    throw error
                }
            }
        }
    }
    
    // MARK: Test Support
        
    var usageCount: Int {
        return pluginObject.usageCount
    }
}
