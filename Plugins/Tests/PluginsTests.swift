import XCTest
@testable import Plugins

final class PluginsTests: XCTestCase {
    
    func testRegistrationAndLookup() async throws {
        let registry = PluginRegistry()
        try registry.register(factory: {
            return AdderObject()
        }, for: AdderInterface.self)
        do {
            let pluginHandle = try registry.lookup(AdderInterface.self)
            let pluginInterface = try await pluginHandle.acquire()
            XCTAssertEqual(pluginInterface.add(lhs: 1, rhs: 1), 2)
        } catch let error {
            print(error)
        }
    }
    
    func testShutdown() async throws {
        let registry = PluginRegistry()
        try registry.register(factory: {
            return AdderObject()
        }, for: AdderInterface.self)
        do {
            let pluginHandle = try registry.lookup(AdderInterface.self)
            let pluginInterface = try await pluginHandle.acquire()
            XCTAssertEqual(pluginHandle.usageCount, 1)
            try await pluginHandle.release()
            XCTAssertFalse(registry.hasHandle(for: AdderInterface.self))
        } catch let error {
            print(error)
        }
    }
}
