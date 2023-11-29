import Foundation

public protocol NotificationActivatedPlugin: Actor {

    static var notifications: Set<NSNotification.Name> { get }
    
    func handle(_ notification: Notification) async
}
