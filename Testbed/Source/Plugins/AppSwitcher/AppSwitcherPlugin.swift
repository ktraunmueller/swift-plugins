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
    
    private func acquire<PluginInterface>(_ pluginHandle: PluginHandle<PluginInterface>?,
                                          completion: @escaping (PluginInterface) -> Void) {
        guard let pluginHandle = pluginHandle else {
            return
        }
        Task {
            do {
                let plugin = try await pluginHandle.acquire()
                await MainActor.run {
                    completion(plugin)
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    private func release<PluginInterface>(_ pluginHandle: PluginHandle<PluginInterface>?) {
        guard let pluginHandle = pluginHandle else {
            return
        }
        Task {
            do {
                try await pluginHandle.release()
            } catch let error {
                print(error)
            }
        }
    }
    
    // MARK: Geometry
    
    private func acquireGeometryPlugin(completion: @escaping () -> Void) {
        guard geometryPlugin == nil else {
            return
        }
        acquire(geometryPluginHandle, completion: { [weak self] plugin in
            self?.geometryPlugin = plugin
            completion()
        })
    }
    
    private func releaseGeometryPlugin() {
        if geometryPlugin != nil {
            geometryPlugin = nil
            release(geometryPluginHandle)
        }
    }
    
    // MARK: Graphing
    
    private func acquireGraphingPlugin(completion: @escaping () -> Void) {
        guard graphingPlugin == nil else {
            return
        }
        acquire(graphingPluginHandle, completion: { [weak self] plugin in
            self?.graphingPlugin = plugin
            completion()
        })
    }
    
    private func releaseGraphingPlugin() {
        if graphingPlugin != nil {
            graphingPlugin = nil
            release(graphingPluginHandle)
        }
    }

    // MARK: - AppSwitcherPluginInterface
    
    private(set) var uiPlugin: UIPluginInterface?
    
    private(set) var appSwitcherViewController: UIViewController?
    
    func switchToGeometry() {
        print("AppSwitcherPlugin > switchToGeometry()")
        releaseGraphingPlugin()
        acquireGeometryPlugin() { [weak self] in
            if let geometryMainViewController = self?.geometryPlugin?.mainViewController {
                self?.uiPlugin?.presentOnRoot(UINavigationController(rootViewController: geometryMainViewController))
            }
        }
    }
    
    func switchToGraphing() {
        print("AppSwitcherPlugin > switchToGraphing()")
        releaseGeometryPlugin()
        acquireGraphingPlugin() { [weak self] in
            if let graphingMainViewController = self?.graphingPlugin?.mainViewController {
                self?.uiPlugin?.presentOnRoot(UINavigationController(rootViewController: graphingMainViewController))
            }
        }
    }
    
    func closeCurrentApp() {
        print("AppSwitcherPlugin > closeCurrentApp()")
        releaseGeometryPlugin()
        releaseGraphingPlugin()
        uiPlugin?.dismissFromRoot()
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
        
        releaseGeometryPlugin()
        releaseGraphingPlugin()
    }
    
    func markAsStarting() {
        state = .starting
    }
    
    func start() async throws {
        appSwitcherViewController = await MainActor.run {
            AppSwitcherViewController(plugin: self)
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
