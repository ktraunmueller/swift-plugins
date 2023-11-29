import Plugins

protocol CalculatorPluginInterface: Actor {
    
    // dependencies
    var adderPlugin: AdderPluginInterface? { get }
    
    func add(lhs: Int, rhs: Int) async -> Int
}

actor CalculatorPluginObject: CalculatorPluginInterface, PluginLifecycle {
    
    init() {
        print("CalculatorPlugin > CalculatorPluginObject created 🎉")
    }
    
    deinit {
        print("CalculatorPlugin > CalculatorPluginObject destroyed 🗑️")
    }

    // MARK: - CalculatorPluginInterface

    private(set) var adderPlugin: AdderPluginInterface?
    
    func add(lhs: Int, rhs: Int) async -> Int {
        print("CalculatorPluginObject: add(\(lhs), \(rhs))")
        return await adderPlugin!.add(lhs: lhs, rhs: rhs)
    }

    // MARK: - PluginLifecycle

    private(set) var state: PluginState = .stopped
    
    func acquireDependencies(from registry: PluginRegistry) async throws {
        let adderPluginHandle = try registry.lookup(AdderPluginInterface.self)
        adderPlugin = try await adderPluginHandle.acquire()
    }
    
    func releaseDependencies(in registry: PluginRegistry) async throws {
        let adderPluginHandle = try registry.lookup(AdderPluginInterface.self)
        try await adderPluginHandle.release()
        adderPlugin = nil
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
