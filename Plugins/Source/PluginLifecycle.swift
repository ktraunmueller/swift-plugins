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
public protocol PluginLifecycle: Actor {
    
    var state: PluginState { get }

    /// Acquire all depdendencies.
    func acquireDependencies(from: PluginRegistry) async throws
    /// Release all dependencies.
    func releaseDependencies(in: PluginRegistry) async throws
    
    /// Sets state to `.starting`.
    func markAsStarting()
    /// Tries to start the plugin. Sets the state to `.started` if successful, throws otherwise.
    func start() async throws
    /// Sets state to `.stopping`.
    func markAsStopping()
    /// Tries to stop the plugin. Sets the state to `.stopped` if successful, throws otherwise.
    func stop() async throws    
}
