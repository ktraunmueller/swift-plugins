/// The central registration and lookup point for plugins.
public actor PluginRegistry {
    
    private var factories: [String: () -> Any] = [:]
    private var pluginHandles: [String: AnyObject] = [:]
    private var notificationHandlers: [Notification.Name: [String: (Notification) -> Void]] = [:]
    
    public init() {
    }
    
    nonisolated private func makeIdentifier<PluginInterface>(describing pluginInterfaceType: PluginInterface.Type) -> String {
        return String(describing: pluginInterfaceType)
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
    
    public func register<PluginObject, PluginInterface>(_ pluginInterfaceType: PluginInterface.Type,
                                                        activatedBy notificationNames: Set<NSNotification.Name>,
                                                        factory: @escaping () -> PluginObject) throws
    where PluginObject: PluginLifecycle & NotificationActivatedPlugin {
        try register(pluginInterfaceType, factory: factory)
        
        let identifier = makeIdentifier(describing: pluginInterfaceType)
        print("🗄️ PluginRegistry > registering notifications for \(identifier) 📫")
        for notificationName in notificationNames {
            var handlers = notificationHandlers[notificationName] ?? [:]
            handlers[identifier] = { [weak self] notification in
                self?.activateAndNotifyNonIsolated(pluginInterfaceType, notification: notification)
            }
            notificationHandlers[notificationName] = handlers
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(handle(_:)),
                                                   name: notificationName,
                                                   object: nil)
        }
    }
    
    /// Look up a plugin.
    ///
    /// - Parameter pluginInterface: The plugin interface type.
    /// - Returns: A ``PluginHandle`` if successful.
    /// - Throws: PluginError.notRegistered if the given plugin interface type has not been registered.
    public func lookup<PluginInterface>(_ pluginInterfaceType: PluginInterface.Type) throws -> PluginHandle<PluginInterface> {
        let identifier = makeIdentifier(describing: pluginInterfaceType)
        return try lookup(pluginIdentifier: identifier)
    }
    
    private func lookup<PluginInterface>(pluginIdentifier identifier: String) throws -> PluginHandle<PluginInterface> {
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
    
    nonisolated private func activateAndNotifyNonIsolated<PluginInterface>(_ pluginInterfaceType: PluginInterface.Type, notification: Notification) {
        // TODO convert value of non-sendable type Notification to a value of a sendable type
        Task {
            await activateAndNotify(pluginInterfaceType, notification: notification)
        }
    }
    
    private func activateAndNotify<PluginInterface>(_ pluginInterfaceType: PluginInterface.Type, notification: Notification) async {
        print("🗄️ PluginRegistry > received \(notification.name.rawValue) 📬")
        let identifier = makeIdentifier(describing: pluginInterfaceType)
        do {
            let pluginHandle = try lookup(pluginInterfaceType)
            if try await pluginHandle.activatePlugin() {
                print("🗄️ PluginRegistry > notification-activated \(identifier)")
            }
            let pluginInterface = try await pluginHandle.acquire()
            if let notificationActivatedPlugin = pluginInterface as? NotificationActivatedPlugin {
                await notificationActivatedPlugin.handle(notification)
            }
            try await pluginHandle.release()
        } catch let error {
            print(error)
        }
    }
    
    private func notifyListeners(_ notification: Notification) {
        guard let handlers = notificationHandlers[notification.name] else {
            return
        }
        for handler in handlers.values {
            handler(notification)
        }
    }
    
    // MARK: Notifications
    
    @objc nonisolated private func handle(_ notification: Notification) {
        Task {
            await notifyListeners(notification)
        }
    }
}
