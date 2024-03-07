/// The central registration and lookup point for plugins.
///
/// Note: This class is designed to be used on the main thread only.
public final class PluginRegistry {
    
    private var factories: [String: () -> Any] = [:]
    private var pluginHandles: [String: AnyObject] = [:]
    
    public init() {
    }
    
    /// Register a plugin.
    ///
    /// - Parameters:
    ///   - factory: The plugin object factory.
    ///   - pluginInterfaceType: The plugin interface type.
    public func register<PluginObject, PluginInterface>(_ pluginInterfaceType: PluginInterface.Type,
                                                        factory: @escaping () -> PluginObject) throws
    where PluginObject: PluginLifecycle {
        let identifier = makeIdentifier(describing: pluginInterfaceType)
        guard factories[identifier] == nil else {
            throw PluginError.pluginAlreadyRegistered
        }
        print("🗄️ PluginRegistry > registering \(identifier)")
        factories[identifier] = factory
    }
    
    /// Look up a plugin.
    ///
    /// - Parameter pluginInterface: The plugin interface type.
    /// - Returns: A ``PluginHandle`` if successful.
    /// - Throws: PluginError.notRegistered if the given plugin interface type has not been registered.
    public func lookup<PluginInterface>(_ pluginInterfaceType: PluginInterface.Type) throws -> PluginHandle<PluginInterface> {
        let identifier = makeIdentifier(describing: pluginInterfaceType)
        if let pluginHandle = pluginHandles[identifier] {
            return pluginHandle as! PluginHandle<PluginInterface>
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
        let pluginHandle = PluginHandle(pluginObject: pluginObjectLifecycle,
                                        pluginInterfaceType: PluginInterface.self,
                                        registry: self)
        pluginHandles[identifier] = pluginHandle
        return pluginHandle
    }
    
    private func makeIdentifier<PluginInterface>(describing pluginInterfaceType: PluginInterface.Type) -> String {
        return String(describing: pluginInterfaceType)
    }    
}
