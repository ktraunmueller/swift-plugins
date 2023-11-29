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
    
    func acquireDependencies(from: PluginRegistry) async throws {
    }
    
    func releaseDependencies(in: PluginRegistry) async throws {
    }
    
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
