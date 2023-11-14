/// The central registration and lookup point for plugins.
public final class PluginRegistry {
    
    private var factories: [String: () -> Any] = [:]
    private var handles: [String: AnyObject] = [:]
    
    /// Register a plugin.
    ///
    /// - Parameters:
    ///   - factory: The plugin object factory.
    ///   - pluginInterfaceType: The plugin interface type.
    public func register<PluginObject, PluginInterface>(_ pluginInterfaceType: PluginInterface.Type,
                                                        factory: @escaping () -> PluginObject) throws
    where PluginObject: PluginLifecycle {
        let identifier = String(describing: pluginInterfaceType)
        guard factories[identifier] == nil else {
            throw PluginError.pluginAlreadyRegistered
        }
        print("PluginRegistry: registering factory for \(identifier)")
        factories[identifier] = factory
    }
    
    /// Look up a plugin.
    ///
    /// - Parameter pluginInterface: The plugin interface type.
    /// - Returns: A ``PluginHandle`` if successful.
    /// - Throws: PluginError.notRegistered if the given plugin interface type has not been registered.
    public func lookup<PluginInterface>(_ pluginInterface: PluginInterface.Type) throws -> PluginHandle<PluginInterface> {
        let identifier = String(describing: pluginInterface)
        print("PluginRegistry: looking up handle for \(identifier)")
        if let handle = handles[identifier] {
            return handle as! PluginHandle<PluginInterface>
        }
        guard let factory = factories[identifier] else {
            throw PluginError.pluginNotRegistered
        }
        guard let pluginObject = factory() as? PluginInterface else {
            throw PluginError.pluginObjectDoesNotImplementPluginInterface
        }
        guard let pluginObjectLifecycle = pluginObject as? PluginLifecycle else {
            throw PluginError.pluginObjectDoesNotImplementPluginLifecycle
        }
        let handle = PluginHandle(pluginObject: pluginObjectLifecycle,
                                  pluginInterfaceType: PluginInterface.self,
                                  registry: self)
        handles[identifier] = handle
        return handle
    }
}
