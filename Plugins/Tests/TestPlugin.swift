import Plugins

protocol TestPluginInterface {
    
    func add(lhs: Int, rhs: Int) -> Int
}

final class TestPluginObject: TestPluginInterface, PluginLifecycle {
    
    init() {
    }

    // MARK: TestPluginInterface

    func add(lhs: Int, rhs: Int) -> Int {
        return lhs + rhs
    }

    // MARK: Plugin

    private(set) var state: PluginState = .stopped

    func start() /*async*/ throws {
        state = .started
    }

    func stop() /*async*/ throws {
        state = .stopped
    }
}
