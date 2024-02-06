/// The central registration and lookup point for plugins.
public actor PluginRegistry {
    
    public typealias Registrations = [String: () -> Any]
    
    public static func register<PluginObject, PluginInterface>(_ pluginInterfaceType: PluginInterface.Type,
                                                               with registrations: inout Registrations,
                                                               factory: @escaping () -> PluginObject) throws
    where PluginObject: PluginLifecycle {
        let identifier = makeIdentifier(describing: pluginInterfaceType)
        guard registrations[identifier] == nil else {
            throw PluginError.pluginAlreadyRegistered
        }
        print("🗄️ PluginRegistry > registering \(identifier)")
        registrations[identifier] = factory
    }
    
    private let registrations: Registrations
    private var pluginHandles: [String: AnyObject] = [:]
    
    public init(registrations: Registrations) {
        self.registrations = registrations
    }
    
    /// Look up a plugin.
    ///
    /// - Parameter pluginInterface: The plugin interface type.
    /// - Returns: A ``PluginHandle`` if successful.
    /// - Throws: PluginError.notRegistered if the given plugin interface type has not been registered.
    public func lookup<PluginInterface>(_ pluginInterfaceType: PluginInterface.Type) throws -> PluginHandle<PluginInterface> {
        let identifier = PluginRegistry.makeIdentifier(describing: pluginInterfaceType)
        return try lookup(pluginIdentifier: identifier)
    }
    
    private func lookup<PluginInterface>(pluginIdentifier identifier: String) throws -> PluginHandle<PluginInterface> {
        if let pluginHandle = pluginHandles[identifier] {
            return pluginHandle as! PluginHandle<PluginInterface>
        }
        guard let factory = registrations[identifier] else {
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
    
    nonisolated private static func makeIdentifier<PluginInterface>(describing pluginInterfaceType: PluginInterface.Type) -> String {
        return String(describing: pluginInterfaceType)
    }
}
