import XCTest
@testable import Plugins

final class PluginsTests: XCTestCase {
    
    func testRegistrationAndLookup() throws {
        let registry = PluginRegistry()
        try registry.register(factory: {
            return AdderObject()
        }, for: AdderInterface.self)
        do {
            let pluginHandle = try registry.lookup(AdderInterface.self)
            let pluginInterface = try pluginHandle.get()
            XCTAssertEqual(pluginInterface.add(lhs: 1, rhs: 1), 2)
        } catch PluginError.notRegistered {
            
        }
    }
}
