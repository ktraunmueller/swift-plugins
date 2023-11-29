import Foundation

public protocol NotificationActivatedPlugin: AnyObject {

    static var notifications: Set<NSNotification.Name> { get }
    
    func handle(_ notification: Notification)
}
