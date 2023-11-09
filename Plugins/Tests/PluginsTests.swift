import XCTest
@testable import Plugins

final class PluginsTests: XCTestCase {
    
    func testRegistration() throws {
        let registry = PluginRegistry()
        try registry.register(pluginObjectType: TestPluginObject.self,
                              for: TestPluginInterface.self,
                              factory: {
            return TestPluginObject()
        })
        let handle = try registry.lookup(TestPluginInterface.self)
        let pluginInterface = handle.get()
        XCTAssertNotNil(pluginInterface)
        XCTAssertEqual(pluginInterface?.add(lhs: 1, rhs: 1), 2)
    }
}
