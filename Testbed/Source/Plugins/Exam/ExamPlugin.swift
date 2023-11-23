import Combine
import UIKit

import Plugins

protocol ExamPluginInterface: AnyObject {
    // dependencies
    var uiPlugin: UIPluginInterface? { get }
    
    var isExamActive: Bool { get }
    var isExamActiveDidChange: any Publisher<Bool, Never> { get }
    
    func registerNotifications()
    
    func beginUserInitiatedExam()
    func endUserInitiatedExam()
}

final class ExamPluginObject: ExamPluginInterface, PluginLifecycle {

    init() {
        print("ExamPlugin > ExamPluginObject created 🎉")
    }
    
    deinit {
        print("ExamPlugin > ExamPluginObject destroyed 🗑️")
    }
    
    // MARK: Notifications
    
    @objc
    private func applicationDidFinishLaunching() {
    }
    
    @objc
    private func applicationDidBecomeActive() {
    }
    
    @objc
    private func applicationWillResignActive() {
    }
    
    @objc
    private func guidedAccessStatusDidChange() {
        //UIAccessibility.isGuidedAccessEnabled
    }
    
    // MARK: - ExamPluginPluginInterface
        
    private(set) var uiPlugin: UIPluginInterface?
    
    private(set) var isExamActive = false
    let isExamActiveDidChange: any Publisher<Bool, Never> = PassthroughSubject<Bool, Never>()
    
    func registerNotifications() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(applicationDidFinishLaunching),
//                                               name: UIApplication.didFinishLaunchingNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.applicationWillResignActive),
//                                               name: UIApplication.willResignActiveNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.applicationDidBecomeActive),
//                                               name: UIApplication.didBecomeActiveNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(guidedAccessStatusDidChange),
//                                               name: UIAccessibility.guidedAccessStatusDidChangeNotification,
//                                               object: nil)
    }
    
    func beginUserInitiatedExam() {
    }
    
    func endUserInitiatedExam() {
    }
    
    // MARK: - PluginLifecycle
    
    private(set) var state: Plugins.PluginState = .stopped
    
    func acquireDependencies(from registry: PluginRegistry) async throws {
        let uiPluginHandle = try registry.lookup(UIPluginInterface.self)
        uiPlugin = try await uiPluginHandle.acquire()
    }
    
    func releaseDependencies(in registry: PluginRegistry) async throws {
        let uiPluginHandle = try registry.lookup(UIPluginInterface.self)
        try await uiPluginHandle.release()
        uiPlugin = nil
    }
    
    func markAsStarting() {
        state = .starting
    }
    
    func start() async throws {
        state = .started
    }
    
    func markAsStopping() {
        state = .stopping
    }
    
    func stop() async throws {
        state = .stopped
    }
}
