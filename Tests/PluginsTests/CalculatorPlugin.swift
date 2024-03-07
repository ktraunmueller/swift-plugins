import Plugins

protocol CalculatorPluginInterface: AnyObject {
    
    // dependencies
    var adderPlugin: AdderPluginInterface? { get }
    
    func add(lhs: Int, rhs: Int) -> Int
}

final class CalculatorPluginObject: CalculatorPluginInterface, PluginLifecycle {
    
    init() {
        print("CalculatorPlugin > CalculatorPluginObject created 🎉")
    }
    
    deinit {
        print("CalculatorPlugin > CalculatorPluginObject destroyed 🗑️")
    }

    // MARK: - CalculatorPluginInterface

    private(set) var adderPlugin: AdderPluginInterface?
    
    func add(lhs: Int, rhs: Int) -> Int {
        print("CalculatorPluginObject: add(\(lhs), \(rhs))")
        return adderPlugin!.add(lhs: lhs, rhs: rhs)
    }

    // MARK: - PluginLifecycle

    private(set) var state: PluginState = .stopped
    
    func acquireDependencies(from registry: PluginRegistry) throws {
        let adderPluginHandle = try registry.lookup(AdderPluginInterface.self)
        adderPlugin = try adderPluginHandle.acquire()
    }
    
    func releaseDependencies(in registry: PluginRegistry) throws {
        let adderPluginHandle = try registry.lookup(AdderPluginInterface.self)
        try adderPluginHandle.release()
        adderPlugin = nil
    }
        
    func start() throws {
        state = .started
    }

    func stop() throws {
        state = .stopped
    }
}
