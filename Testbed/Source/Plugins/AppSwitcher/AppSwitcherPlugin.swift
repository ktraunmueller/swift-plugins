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
    
    private var geometryPluginHandle: PluginHandle<GeometryPluginInterface>?
    private var graphingPluginHandle: PluginHandle<GraphingPluginInterface>?

    init() {
        print("AppSwitcherPluginObject created 🎉")
    }
    
    deinit {
        print("AppSwitcherPluginObject destroyed 🗑️")
    }
    
    // MARK: Geometry
    
    private func acquireGeometryPlugin(completion: @escaping () -> Void) {
        guard geometryPlugin == nil else {
            return
        }
        Task {
            do {
                geometryPlugin = try await geometryPluginHandle?.acquire()
                await MainActor.run {
                    completion()
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    private func releaseGeometryPlugin() {
        guard geometryPlugin != nil else {
            return
        }
        geometryPlugin = nil
        Task {
            do {
                try await geometryPluginHandle?.release()
            } catch let error {
                print(error)
            }
        }
    }
    
    // MARK: Graphing
    
    private func acquireGraphingPlugin(completion: @escaping () -> Void) {
        guard graphingPlugin == nil else {
            return
        }
        Task {
            do {
                graphingPlugin = try await graphingPluginHandle?.acquire()
                await MainActor.run {
                    completion()
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    private func releaseGraphingPlugin() {
        guard graphingPlugin != nil else {
            return
        }
        graphingPlugin = nil
        Task {
            do {
                try await graphingPluginHandle?.release()
            } catch let error {
                print(error)
            }
        }
    }

    // MARK: - AppSwitcherPluginInterface
    
    private(set) var uiPlugin: UIPluginInterface?
    private(set) var geometryPlugin: GeometryPluginInterface?
    private(set) var graphingPlugin: GraphingPluginInterface?
    
    private(set) var appSwitcherViewController: UIViewController?
    
    func switchToGeometry() {
        releaseGraphingPlugin()
        acquireGeometryPlugin() { [weak self] in
            guard let self = self else {
                return
            }
            if let geometryMainViewController = self.geometryPlugin?.mainViewController {
                self.uiPlugin?.presentOnRoot(UINavigationController(rootViewController: geometryMainViewController))
            }
        }
    }
    
    func switchToGraphing() {
        releaseGeometryPlugin()
        acquireGraphingPlugin() { [weak self] in
            guard let self = self else {
                return
            }
            if let graphingMainViewController = self.graphingPlugin?.mainViewController {
                self.uiPlugin?.presentOnRoot(UINavigationController(rootViewController: graphingMainViewController))
            }
        }
    }
    
    func closeCurrentApp() {
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
