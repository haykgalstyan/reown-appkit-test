import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    private static let EVENTS_CHANNEL = "com.exampledapp/events"
    private var eventsChannel: FlutterEventChannel?
    private let linkStreamHandler = LinkStreamHandler()
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller = window.rootViewController as! FlutterViewController
        eventsChannel = FlutterEventChannel(name: AppDelegate.EVENTS_CHANNEL, binaryMessenger: controller.binaryMessenger)
        eventsChannel?.setStreamHandler(linkStreamHandler)
        
        if let userActivityDictionary = launchOptions?[.userActivityDictionary] as? [String: Any],
           let userActivity = userActivityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity,
           userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            
            handleIncomingUniversalLink(userActivity: userActivity)
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return linkStreamHandler.handleLink(url.absoluteString)
    }
    
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            handleIncomingUniversalLink(userActivity: userActivity)
            return true
        }
        
        return false
    }
    
    private func handleIncomingUniversalLink(userActivity: NSUserActivity) {
        if let url = userActivity.webpageURL {
            print("App launched with Universal Link: \(url.absoluteString)")
            let _ = linkStreamHandler.handleLink(url.absoluteString)
        }
    }
}

class LinkStreamHandler: NSObject, FlutterStreamHandler {
    var eventSink: FlutterEventSink?
    var queuedLinks = [String]()
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        queuedLinks.forEach({ events($0) })
        queuedLinks.removeAll()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    func handleLink(_ link: String) -> Bool {
        guard let eventSink = eventSink else {
            queuedLinks.append(link)
            return false
        }
        eventSink(link)
        return true
    }
}
