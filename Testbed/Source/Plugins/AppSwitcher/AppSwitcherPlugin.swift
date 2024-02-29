import Plugins

import UIKit

protocol AppSwitcherPluginInterface: AnyObject {
    // dependencies
    var uiPlugin: UIPluginInterface? { get }
    
    var appSwitcherViewController: UIViewController? { get }
    
    func switchToGeometry()
    func switchToGraphing()
    func closeCurrentApp()
}

final class AppSwitcherPluginObject: AppSwitcherPluginInterface, PluginLifecycle {
    
    // These are not considered dependencies in the narrow sense: dependencies are
    // started when a plugin starts, and we don't want these plugins to start when
    // the app switcher plugin starts - only when we actually need one or the other.
    private var geometryPluginHandle: PluginHandle<GeometryPluginInterface>?
    private var geometryPlugin: GeometryPluginInterface?
    private var graphingPluginHandle: PluginHandle<GraphingPluginInterface>?
    private var graphingPlugin: GraphingPluginInterface?
    
    init() {
        print("AppSwitcherPlugin > AppSwitcherPluginObject created 🎉")
    }
    
    deinit {
        print("AppSwitcherPlugin > AppSwitcherPluginObject destroyed 🗑️")
    }
    
    // MARK: Geometry
    
    private func acquireGeometryPlugin() throws {
        guard geometryPlugin == nil else {
            return
        }
        geometryPlugin = try geometryPluginHandle?.acquire()
    }
    
    private func releaseGeometryPlugin() throws {
        if geometryPlugin != nil {
            geometryPlugin = nil
            try geometryPluginHandle?.release()
        }
    }
    
    // MARK: Graphing
    
    private func acquireGraphingPlugin() throws {
        guard graphingPlugin == nil else {
            return
        }
        graphingPlugin = try graphingPluginHandle?.acquire()
    }
    
    private func releaseGraphingPlugin() throws {
        if graphingPlugin != nil {
            graphingPlugin = nil
            try graphingPluginHandle?.release()
        }
    }
    
    // MARK: - AppSwitcherPluginInterface
    
    private(set) var uiPlugin: UIPluginInterface?
    
    private(set) var appSwitcherViewController: UIViewController?
    
    func switchToGeometry() {
        print("AppSwitcherPlugin > switchToGeometry()")
        do {
            try releaseGraphingPlugin()
            try acquireGeometryPlugin()
            if let geometryMainViewController = geometryPlugin?.mainViewController {
                uiPlugin?.presentOnRoot(UINavigationController(rootViewController: geometryMainViewController))
            }
        } catch let error {
            print(error)
        }
    }
    
    func switchToGraphing() {
        print("AppSwitcherPlugin > switchToGraphing()")
        do {
            try releaseGeometryPlugin()
            try acquireGraphingPlugin()
            if let graphingMainViewController = graphingPlugin?.mainViewController {
                uiPlugin?.presentOnRoot(UINavigationController(rootViewController: graphingMainViewController))
            }
        } catch let error {
            print(error)
        }
    }
    
    func closeCurrentApp() {
        print("AppSwitcherPlugin > closeCurrentApp()")
        try? releaseGeometryPlugin()
        try? releaseGraphingPlugin()
        uiPlugin?.dismissFromRoot()
    }
    
    // MARK: - PluginLifecycle
    
    private(set) var state: Plugins.PluginState = .stopped
    
    func acquireDependencies(from registry: PluginRegistry) throws {
        assert(uiPlugin == nil)
        let uiPluginHandle = try registry.lookup(UIPluginInterface.self)
        uiPlugin = try uiPluginHandle.acquire()
        
        geometryPluginHandle = try registry.lookup(GeometryPluginInterface.self)
        graphingPluginHandle = try registry.lookup(GraphingPluginInterface.self)
    }
    
    func releaseDependencies(in registry: PluginRegistry) throws {
        assert(uiPlugin != nil)
        let uiPluginHandle = try registry.lookup(UIPluginInterface.self)
        try uiPluginHandle.release()
        uiPlugin = nil
        
        try releaseGeometryPlugin()
        try releaseGraphingPlugin()
    }
    
    func start() throws {
        appSwitcherViewController = AppSwitcherViewController(plugin: self)
        state = .started
    }
    
    func stop() throws {
        appSwitcherViewController = nil
        state = .stopped
    }
}
