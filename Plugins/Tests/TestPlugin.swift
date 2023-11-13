import Plugins

protocol AdderInterface {
    func add(lhs: Int, rhs: Int) -> Int
}

final class AdderObject: AdderInterface, PluginLifecycle {
    
    init() {
        print("+++ TestPluginObject +++")
    }
    
    deinit {
        print("--- TestPluginObject ---")
    }

    // MARK: AdderInterface

    func add(lhs: Int, rhs: Int) -> Int {
        print("*** TestPluginObject.add(\(lhs), \(rhs))")
        return lhs + rhs
    }

    // MARK: PluginLifecycle

    private(set) var state: PluginState = .stopped

    func start() /*async*/ throws {
        state = .starting
        state = .started
    }

    func stop() /*async*/ throws {
        state = .stopping
        state = .stopped
    }
}
