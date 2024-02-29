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

/// Plugin objects are required to conform to ``PluginLifecycle``.
/// 
/// The plugin lifecycle will be handled transparently by ``PluginHandle``s.
public protocol PluginLifecycle: AnyObject {
    
    var state: PluginState { get }

    /// Acquire all depdendencies.
    func acquireDependencies(from: PluginRegistry) throws
    /// Release all dependencies.
    func releaseDependencies(in: PluginRegistry) throws
    
    /// Tries to start the plugin. Sets the state to `.started` if successful, throws otherwise.
    func start() throws
    /// Tries to stop the plugin. Sets the state to `.stopped` if successful, throws otherwise.
    func stop() throws    
}
