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
public protocol PluginLifecycle {
    
    var state: PluginState { get }
    func start() async throws
    func stop() async throws
    
    var usageCount: Int { get }
    func incrementUsageCount()
    func decrementUsageCount()
    
}
