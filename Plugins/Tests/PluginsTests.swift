import XCTest
@testable import Plugins

final class PluginsTests: XCTestCase {
    
    func testRegistrationAndLookup() async throws {
        var registrations = PluginRegistry.Registrations()
        try PluginRegistry.register(AdderPluginInterface.self, with: &registrations) {
            return AdderPluginObject()
        }
        let registry = PluginRegistry(registrations: registrations)
        
        do {
            let pluginHandle = try await registry.lookup(AdderPluginInterface.self)
            let pluginInterface = try await pluginHandle.acquire()
            let result = await pluginInterface.add(lhs: 1, rhs: 1)
            XCTAssertEqual(result, 2)
        } catch let error {
            print(error)
        }
    }
    
    func testShutdownWhenUsageCountReachesZero() async throws {
        var registrations = PluginRegistry.Registrations()
        try PluginRegistry.register(AdderPluginInterface.self, with: &registrations) {
            return AdderPluginObject()
        }
        let registry = PluginRegistry(registrations: registrations)
        
        do {
            let pluginHandle = try await registry.lookup(AdderPluginInterface.self)
            let _ = try await pluginHandle.acquire()
            var usageCount = await pluginHandle.usageCount
            XCTAssertEqual(usageCount, 1)
            try await pluginHandle.release()
            usageCount = await pluginHandle.usageCount
            XCTAssertEqual(usageCount, 0)
        } catch let error {
            print(error)
        }
    }
    
    func testStartDependencies() {
        // test safeguarding against circular dependencies?
    }
}
