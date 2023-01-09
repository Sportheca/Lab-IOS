//
//  AppDelegate.swift
//  
//
//  Created by Roberto Oliveira on 28/08/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabController:HomeTabBarController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        // Root View Controller
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = SplashViewController()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlSchemes:[String] = ProjectManager.externalURLSchemes
        for urlScheme in urlSchemes {
            if url.absoluteString.hasPrefix("\(urlScheme)://") {
                guard let components = URLComponents(string: url.absoluteString) else { return true }
                let t = Int.intValue(from: components.queryItems?.first(where: {$0.name == "t"})?.value) ?? 0
                let v = Int.intValue(from: components.queryItems?.first(where: {$0.name == "v"})?.value) ?? 0
                self.pushNotificationInfo = ["idPush":0, "t":t, "v": v, "trackId":0]
                self.pushNotificationDelegate?.handlePushNotificationInfo()
                return true
            }
        }
        return false
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        global_shouldCheckVersionWhenBecomesActive = true
        LocalSessionManager.shared.saveSessionEnd(mode: .Background)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Remove Notification Badge Count
        UIApplication.shared.setAppIconBadgeNumber(value: 0)
        ServerManager.shared.updateUserAPNS()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applicationDidBecomeActive"), object: nil)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if global_shouldCheckVersionWhenBecomesActive == true {
            self.checkAppVersion(trackEvent: nil, trackValue: nil)
            global_shouldCheckVersionWhenBecomesActive = false
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UIApplication.shared.deleteDownloadsDirectoryContents()
        LocalSessionManager.shared.saveSessionEnd(mode: .Kill)
    }
    
    
    
    
    
    private func checkAppVersion(trackEvent: Int?, trackValue: Int?) {
        ServerManager.shared.getVersion(trackEvent: trackEvent, trackValue: trackValue) { (versionStatus:VersionStatus?, message:String?) in
            let status = versionStatus ?? .Failed
            switch status {
            case .UpdateRequired, .UpdateAvailable, .Locked:
                // maintenance screen
                DispatchQueue.main.async {
                    UIApplication.topViewController()?.presentMaintenanceViewController(status: versionStatus ?? .Locked, message: message)
                }
                return
            case .Updated:
                // do nothing
                return
            case .Failed:
                self.checkAppVersion(trackEvent: nil, trackValue: nil)
                // try again
                return
            }
        }
    }
    
    
    
    // MARK: - Push Notifications
    var pushNotificationInfo:[String:Any]?
    var pushNotificationDelegate:PushNotificationDelegate?
    
    
    // Handle Pushs
    private func handleRemoteNotification(info:[AnyHashable:Any]) {
        print("handleRemoteNotification: ", info)
        guard let apsInfo = info["aps"] as? [String:Any] else {return}
        guard let pushTypeId = apsInfo["t"] as? Int else {return}
        let pushType = PushNotificationType(rawValue: pushTypeId)
        // Handle Push info
        if UIApplication.shared.applicationState == .active {
            // If app is active, check if it is a VersionControl type push to force a getVersion
            guard let type = pushType else {return}
            switch type {
            case PushNotificationType.VersionControl:
                let pushID = Int.intValue(from: apsInfo["idPush"]) ?? 0
                ServerManager.shared.setLogPushOpen(pushID, trackId: nil)
                self.checkAppVersion(trackEvent: EventTrack.NoScreen.performSilentGetVersion, trackValue: pushID)
                break
                
            case PushNotificationType.ForceCrash:
                fatalError("forced-crash-from-push")
                break
                
            case PushNotificationType.ForceLogout:
                DispatchQueue.main.async {
                    UIApplication.shared.forceLogout()
                }
                break
                
            case PushNotificationType.NewBadges:
                DispatchQueue.main.async {
                    let vc = NewBadgesViewController()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    UIApplication.topViewController()?.present(vc, animated: false, completion: nil)
                }
                break
                
            default: break
            }
            
        } else {
            // If app was not active, handle deeplink information
            self.pushNotificationInfo = apsInfo
            // do not track push opening right now because some classes might not be create if the app was closed. So track will be made by pushNotificationDelegate
            // It is using raw value because some classes might not be ready yet
            self.pushNotificationInfo?["trackId"] = EventTrack.NoScreen.openExternalPushNotification
            self.pushNotificationDelegate?.handlePushNotificationInfo()
        }
    }
    
    
    
    
    // Receive Pushs
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        self.handleRemoteNotification(info: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        self.handleRemoteNotification(info: userInfo)
    }
    
    
    
    // Register for Pushs
    func registerForPushNotifications(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            NotificationCenter.default.post(name: Notification.Name("DidRegisterForNotifications"), object: nil)
        }
        application.registerForRemoteNotifications()
    }
    
    
    
    // APNS received
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        UserDefaultsManager.shared.setuserApns(tokenString)
        ServerManager.shared.updateUserAPNS()
    }
    
    
    // APNS failed
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        UserDefaultsManager.shared.setuserApns("")
        ServerManager.shared.updateUserAPNS()
    }
    
    
    
    
}

