import XCTest
@testable import Plugins

final class PluginsTests: XCTestCase {
    
    func testRegistration() throws {
        let registry = PluginRegistry()
        try registry.register(factory: {
            return TestPluginObject()
        }, for: TestPluginInterface.self)
        let handle = try registry.lookup(TestPluginInterface.self)
        let pluginInterface = try handle.get()
        XCTAssertEqual(pluginInterface.add(lhs: 1, rhs: 1), 2)
    }
}
