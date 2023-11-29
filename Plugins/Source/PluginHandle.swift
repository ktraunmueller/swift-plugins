/// A lightweight handle to a plugin.
///
/// The plugin handle transparently handles the plugin lifecycle,
/// and hides the concrete plugin object type from clients.
public actor PluginHandle<PluginInterface> {
    
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
        print("🔌 PluginHandle > acquiring \(String(describing: PluginInterface.self))")
        try await pluginObject.startIfNotRunning(registry: registry)
        usageCount += 1
        print("🔌 PluginHandle > \(String(describing: pluginObject)) usage count now \(usageCount)")
        return pluginObject as! PluginInterface
    }
    
    /// Releases a reference to the plugin interface.
    ///
    /// If this brings the plugin's usage count to zero, the plugin
    /// will be stopped.
    public func release() async throws {
        print("🔌 PluginHandle > releasing \(String(describing: PluginInterface.self))")
        assert(usageCount > 0)
        usageCount -= 1
        print("🔌 PluginHandle > \(String(describing: pluginObject)) usage count now \(usageCount)")
        if usageCount == 0 {
            try await pluginObject.stopIfRunning(registry: registry)
        }
    }
}

extension PluginLifecycle {
    
    fileprivate func startIfNotRunning(registry: PluginRegistry?) async throws {
        if state == .stopped {
            markAsStarting()
            do {
                print("🔌 PluginHandle > acquiring dependencies for \(String(describing: self.self))...")
                if let registry = registry {
                    try await acquireDependencies(from: registry)
                }
                print("🔌 PluginHandle > starting \(String(describing: self.self))...")
                try await start()
                assert(state == .started)
                print("🔌 PluginHandle > \(String(describing: self.self)) started 🟢")
            }
            catch let error {
                throw error // simply rethrow for now
            }
        }
    }
    
    fileprivate func stopIfRunning(registry: PluginRegistry?) async throws {
        if state == .started {
            markAsStopping()
            do {
                print("🔌 PluginHandle > stopping \(String(describing: self.self))...")
                try await stop()
                print("🔌 PluginHandle > \(String(describing: self.self)) stopped 🛑")
                assert(state == .stopped)
                print("🔌 PluginHandle > releasing dependencies for \(String(describing: self.self))...")
                if let registry = registry {
                    try await releaseDependencies(in: registry)
                }
            }
            catch let error {
                throw error
            }
        }
    }
}
