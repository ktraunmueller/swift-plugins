public enum PluginRegistryError: Error {
    case notRegistered
    case alreadyRegistered
    case couldNotBeStarted
}

public final class PluginRegistry {
    
    private var factories: [String: () -> Any] = [:]
    private var handles: [String: Any] = [:]
    private var pluginObjects: [String: Any] = [:]
    
    public func register<PluginObject: PluginLifecycle, PluginInterface>(pluginObjectType: PluginObject.Type,
                                                                         for pluginInterfaceType: PluginInterface.Type,
                                                                         factory: @escaping () -> PluginObject) throws {
        let identifier = String(describing: pluginInterfaceType)
        guard factories[identifier] == nil else {
            throw PluginRegistryError.alreadyRegistered
        }
        factories[identifier] = factory
    }
    
    public func lookup<PluginInterface>(_ pluginInterface: PluginInterface.Type) throws -> PluginHandle<PluginInterface> {
        let identifier = String(describing: pluginInterface)
        guard factories[identifier] != nil else {
            throw PluginRegistryError.notRegistered
        }
        if handles[identifier] == nil {
            handles[identifier] = PluginHandle(registry: self, pluginObjectType: PluginInterface.self)
        }
        return handles[identifier] as! PluginHandle<PluginInterface>
    }
    
    func getPluginObject<PluginInterface>(_ pluginInterface: PluginInterface.Type) throws -> PluginLifecycle? {
        let identifier = String(describing: pluginInterface)
        if pluginObjects[identifier] == nil {
            guard let factory = factories[identifier] else {
                throw PluginRegistryError.notRegistered
            }
            pluginObjects[identifier] = factory()
        }
        return pluginObjects[identifier] as? PluginLifecycle
    }
}
