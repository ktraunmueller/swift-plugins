import Plugins

protocol AdderInterface: AnyObject {
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
    
    func markAsStarting() {
        state = .starting
    }
    
    func start() async throws {
        state = .started
    }

    func markAsStopping() {
        state = .stopping
    }
    
    func stop() async throws {
        state = .stopped
    }
    
    private(set) var usageCount = 0
    
    func incrementUsageCount() {
        usageCount += 1
    }
    
    func decrementUsageCount() {
        usageCount -= 1
    }
}
