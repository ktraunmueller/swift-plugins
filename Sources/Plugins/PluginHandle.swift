/// A lightweight handle to a plugin.
///
/// The plugin handle transparently handles the plugin lifecycle.
/// Also, it hides the concrete plugin object type from clients.
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
    public func acquire() throws -> PluginInterface {
        print("🔌 PluginHandle > acquiring \(String(describing: PluginInterface.self))")
        if pluginObject.state == .stopped {
            do {
                print("🔌 PluginHandle > acquiring dependencies for \(String(describing: PluginInterface.self))...")
                if let registry = registry {
                    try pluginObject.acquireDependencies(from: registry)
                }
                print("🔌 PluginHandle > starting \(String(describing: pluginObject))...")
                try pluginObject.start()
                assert(pluginObject.state == .started)
                print("🔌 PluginHandle > \(String(describing: pluginObject)) started 🟢")
            }
            catch let error {
                throw error // simply rethrow for now
            }
        }
        usageCount += 1
        print("🔌 PluginHandle > \(String(describing: pluginObject)) usage count now \(usageCount)")
        return pluginObject as! PluginInterface
    }
    
    /// Releases a reference to the plugin interface.
    ///
    /// If this brings the plugin's usage count to zero, the plugin will be stopped.
    public func release() throws {
        print("🔌 PluginHandle > releasing \(String(describing: PluginInterface.self))")
        assert(usageCount > 0)
        usageCount -= 1
        print("🔌 PluginHandle > \(String(describing: pluginObject)) usage count now \(usageCount)")
        if pluginObject.state == .started {
            if usageCount == 0 {
                do {
                    print("🔌 PluginHandle > stopping \(String(describing: pluginObject))...")
                    try pluginObject.stop()
                    print("🔌 PluginHandle > \(String(describing: pluginObject)) stopped 🛑")
                    assert(pluginObject.state == .stopped)
                    print("🔌 PluginHandle > releasing dependencies for \(String(describing: PluginInterface.self))...")
                    if let registry = registry {
                        try pluginObject.releaseDependencies(in: registry)
                    }
                }
                catch let error {
                    throw error
                }
            }
        }
    }
}
