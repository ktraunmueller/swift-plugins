import Plugins

import UIKit

protocol AppSwitcherPluginInterface: Actor {
    // dependencies
    var uiPlugin: UIPluginInterface? { get }
    // weak dependencies?
//    var geometryPlugin: GeometryPluginInterface? { get }
//    var graphingPlugin: GraphingPluginInterface? { get }
    
    @MainActor
    var appSwitcherViewController: UIViewController? { get }
    
    func switchToGeometry() async
    func switchToGraphing() async
    func closeCurrentApp() async
}

actor AppSwitcherPluginObject: AppSwitcherPluginInterface, PluginLifecycle {
    
    // These are not considered dependencies in the narrow sense: (regular) dependencies
    // are started when a plugin starts, and we don't want these plugins to start when
    // the app switcher plugin starts - only when we actually need one or the other.
    // TODO introduce concept of weak dependencies for this?
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
    
    private func acquireGeometryPlugin() async {
        guard geometryPlugin == nil, let geometryPluginHandle else {
            return
        }
        do {
            geometryPlugin = try await geometryPluginHandle.acquire()
        } catch let error {
            print(error)
        }
    }
    
    private func releaseGeometryPlugin() async {
        guard geometryPlugin != nil, let geometryPluginHandle else {
            return
        }
        do {
            try await geometryPluginHandle.release()
            geometryPlugin = nil
        } catch let error {
            print(error)
        }
    }
    
    // MARK: Graphing
    
    private func acquireGraphingPlugin() async {
        guard graphingPlugin == nil, let graphingPluginHandle else {
            return
        }
        do {
            graphingPlugin = try await graphingPluginHandle.acquire()
        } catch let error {
            print(error)
        }
    }
    
    private func releaseGraphingPlugin() async {
        guard graphingPlugin != nil, let graphingPluginHandle else {
            return
        }
        do {
            try await graphingPluginHandle.release()
            graphingPlugin = nil
        } catch let error {
            print(error)
        }
    }

    // MARK: - AppSwitcherPluginInterface
    
    private(set) var uiPlugin: UIPluginInterface?
    
    @MainActor
    private(set) var appSwitcherViewController: UIViewController?
    
    func switchToGeometry() async {
        print("AppSwitcherPlugin > switchToGeometry()")
        await releaseGraphingPlugin()
        await acquireGeometryPlugin()
        if let geometryMainViewController = await geometryPlugin?.mainViewController {
            await uiPlugin?.presentOnRoot(UINavigationController(rootViewController: geometryMainViewController))
        }
    }
    
    func switchToGraphing() async {
        print("AppSwitcherPlugin > switchToGraphing()")
        await releaseGeometryPlugin()
        await acquireGraphingPlugin()
        if let graphingMainViewController = await graphingPlugin?.mainViewController {
            await uiPlugin?.presentOnRoot(UINavigationController(rootViewController: graphingMainViewController))
        }
    }
    
    func closeCurrentApp() async {
        print("AppSwitcherPlugin > closeCurrentApp()")
        await releaseGeometryPlugin()
        await releaseGraphingPlugin()
        await uiPlugin?.dismissFromRoot()
    }
    
    // MARK: - PluginLifecycle
    
    private(set) var state: Plugins.PluginState = .stopped
    
    func acquireDependencies(from registry: PluginRegistry) async throws {
        let uiPluginHandle = try registry.lookup(UIPluginInterface.self)
        uiPlugin = try await uiPluginHandle.acquire()
        
        geometryPluginHandle = try registry.lookup(GeometryPluginInterface.self)
        graphingPluginHandle = try registry.lookup(GraphingPluginInterface.self)
    }
    
    func releaseDependencies(in registry: PluginRegistry) async throws {
        let uiPluginHandle = try registry.lookup(UIPluginInterface.self)
        try await uiPluginHandle.release()
        uiPlugin = nil
        
        await releaseGeometryPlugin()
        await releaseGraphingPlugin()
    }
    
    func markAsStarting() {
        state = .starting
    }
    
    func start() async throws {
        await MainActor.run {
            appSwitcherViewController = AppSwitcherViewController(plugin: self)
        }
        state = .started
    }
    
    func markAsStopping() {
        state = .stopping
    }
    
    func stop() async throws {
        state = .stopped
    }
}
