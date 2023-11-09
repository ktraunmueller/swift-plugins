/// The states a plugin can be in.
public enum PluginState {
    /// The plugin is stopped (the default state).
    case stopped
    /// The plugin is starting.
    case starting
    /// The plugin is started.
    case started
    /// The plugin is stopping.
    case stopping
}

/// The ``PluginLifecycle`` protocol formalizes the plugin lifecycle.
public protocol PluginLifecycle {
    
    var state: PluginState { get }
        
    func start() /*async*/ throws
    func stop() /*async*/ throws
}

/// A ``PluginHandle`` is a lightweight handle to a plugin.
///
/// The plugin handle transparently handles plugin object instantiation and the plugin lifecycle.
public final class PluginHandle<PluginInterface> {
    
    private weak var registry: PluginRegistry?
    
    init(registry: PluginRegistry, pluginObjectType: PluginInterface.Type) {
        self.registry = registry
    }

    /// Returns the plugin interface.
    ///
    /// Starts the plugin if it is currently stopped.
    public func get() /*async*/ -> PluginInterface? {
        guard let registry = registry else {
            return nil
        }
        guard let pluginObject = try? registry.getPluginObject(PluginInterface.self) else {
            return nil
        }
        if pluginObject.state == .stopped {
            do {
                try pluginObject.start()
                assert(pluginObject.state == .started)
            }
            catch let error {
                // rethrow?
                return nil
            }
        }
        return pluginObject as? PluginInterface
    }
}
