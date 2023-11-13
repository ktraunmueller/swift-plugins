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
