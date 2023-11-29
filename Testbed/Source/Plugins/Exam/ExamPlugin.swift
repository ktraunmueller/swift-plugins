import Combine
import UIKit

import Plugins

protocol ExamPluginInterface: Actor {
    // dependencies
    var uiPlugin: UIPluginInterface? { get }
    
    var isExamActive: Bool { get }
    var isExamActiveDidChange: any Publisher<Bool, Never> { get }
    
    func beginUserInitiatedExam()
    func endUserInitiatedExam()
}

actor ExamPluginObject: ExamPluginInterface, PluginLifecycle {

    init() {
        print("ExamPlugin > ExamPluginObject created 🎉")
    }
    
    deinit {
        print("ExamPlugin > ExamPluginObject destroyed 🗑️")
    }
    
    // MARK: - ExamPluginPluginInterface
        
    private(set) var uiPlugin: UIPluginInterface?
    
    private(set) var isExamActive = false
    let isExamActiveDidChange: any Publisher<Bool, Never> = PassthroughSubject<Bool, Never>()
    
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
