/// The central registration and lookup facility for plugins.
public final class PluginRegistry {
    
    private var factories: [String: () -> Any] = [:]
    private var handles: [String: Any] = [:]
    
    public func register<PluginObject, PluginInterface>(factory: @escaping () -> PluginObject,
                                                        for pluginInterfaceType: PluginInterface.Type) throws
    where PluginObject: PluginLifecycle {
        let identifier = String(describing: pluginInterfaceType)
        guard factories[identifier] == nil else {
            throw PluginError.alreadyRegistered
        }
        print("PluginRegistry: registering factory for \(identifier)")
        factories[identifier] = factory
    }
    
    public func lookup<PluginInterface>(_ pluginInterface: PluginInterface.Type) throws -> PluginHandle<PluginInterface> {
        let identifier = String(describing: pluginInterface)
        print("PluginRegistry: looking up handle for \(identifier)")
        if let handle = handles[identifier] {
            return handle as! PluginHandle<PluginInterface>
        }
        guard let factory = factories[identifier] else {
            throw PluginError.notRegistered
        }
        guard let pluginObject = factory() as? PluginInterface else {
            throw PluginError.pluginObjectDoesNotImplementPluginInterface
        }
        guard let pluginObjectLifecycle = pluginObject as? PluginLifecycle else {
            throw PluginError.pluginObjectDoesNotImplementPluginLifecycle
        }
        let handle = PluginHandle(pluginObject: pluginObjectLifecycle, pluginInterfaceType: PluginInterface.self)
        handles[identifier] = handle
        return handle
    }
}
