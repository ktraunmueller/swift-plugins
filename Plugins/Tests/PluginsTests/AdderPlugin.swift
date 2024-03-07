import Plugins

protocol AdderPluginInterface: AnyObject {
    func add(lhs: Int, rhs: Int) -> Int
}

final class AdderPluginObject: AdderPluginInterface, PluginLifecycle {
    
    init() {
        print("AdderPlugin > AdderPluginObject created 🎉")
    }
    
    deinit {
        print("AdderPlugin > AdderPluginObject destroyed 🗑️")
    }

    // MARK: - AdderPluginInterface

    func add(lhs: Int, rhs: Int) -> Int {
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
