import Plugins

protocol AdderPluginInterface: Actor {
    func add(lhs: Int, rhs: Int) async -> Int
}

actor AdderPluginObject: AdderPluginInterface, PluginLifecycle {
    
    init() {
        print("AdderPlugin > AdderPluginObject created 🎉")
    }
    
    deinit {
        print("AdderPlugin > AdderPluginObject destroyed 🗑️")
    }

    // MARK: - AdderPluginInterface

    func add(lhs: Int, rhs: Int) async -> Int {
        print("AdderPlugin > AdderPluginObject add(\(lhs), \(rhs))")
        return lhs + rhs
    }

    // MARK: - PluginLifecycle

    private(set) var state: PluginState = .stopped
    
    func acquireDependencies(from: PluginRegistry) throws {
    }
    
    func releaseDependencies(in: PluginRegistry) throws {
    }
    
    func start() throws {
        state = .started
    }

    func stop() throws {
        state = .stopped
    }
}
