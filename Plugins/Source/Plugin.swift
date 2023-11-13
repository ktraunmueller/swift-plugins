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

public enum PluginError: Error {
    case internalError
    // TODO get rid (we're exposing internals here)
    case pluginObjectDoesNotImplementPluginInterface
    // TODO get rid (we're exposing internals here)
    case pluginObjectDoesNotImplementPluginLifecycle
    case notRegistered
    case alreadyRegistered
    case couldNotBeStarted
}

/// A ``PluginHandle`` is a lightweight handle to a plugin.
///
/// The plugin handle transparently handles the plugin lifecycle.
//public protocol PluginHandle {
//
//    associatedtype PluginInterface
//
//    func get() /*async*/ throws -> PluginInterface
//}

public final class DefaultPluginHandle<PluginInterface>/*: PluginHandle*/ {
    
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
