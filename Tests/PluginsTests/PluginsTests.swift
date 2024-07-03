import XCTest
@testable import Plugins

final class PluginsTests: XCTestCase {
    
    func testRegistrationAndLookup() throws {
        let registry = PluginRegistry()
        try registry.register(AdderPluginInterface.self) {
            return AdderPluginObject()
        }
        
        do {
            let pluginHandle = try registry.lookup(AdderPluginInterface.self)
            let pluginInterface = try pluginHandle.acquire()
            XCTAssertEqual(pluginInterface.add(lhs: 1, rhs: 1), 2)
        } catch let error {
            print(error)
        }
    }
    
    func testShutdownWhenUsageCountReachesZero() throws {
        let registry = PluginRegistry()
        try registry.register(AdderPluginInterface.self) {
            return AdderPluginObject()
        }
        
        do {
            let pluginHandle = try registry.lookup(AdderPluginInterface.self)
            let _ = try pluginHandle.acquire()
            XCTAssertEqual(pluginHandle.usageCount, 1)
            try pluginHandle.release()
            XCTAssertEqual(pluginHandle.usageCount, 0)
        } catch let error {
            print(error)
        }
    }
    
    func testStartDependencies() {
        // test safeguarding against circular dependencies?
    }
}
