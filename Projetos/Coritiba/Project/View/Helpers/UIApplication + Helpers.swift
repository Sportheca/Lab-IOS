//
//  UIApplication + Helpers.swift
//  
//
//  Created by Roberto Oliveira on 19/10/2017.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

enum DeviceType {
    case iPhone
    case iPad
}

// Extension to obtain info about app and device
extension UIApplication {
    
    func currentDevice() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    func deviceModel() -> String {
        return UIDevice.current.systemVersion
    }
    
    func appVersion() -> String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)  ?? ""
    }
    
    func currentDeviceType() -> DeviceType {
        return (UIDevice.current.userInterfaceIdiom == .pad) ? DeviceType.iPad : DeviceType.iPhone
    }
    
    func safeAreaInsets() -> UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}



enum VibrationMode {
    case Weak
    case Strong
    case MultipleWeak
}
import AudioToolbox
extension UIApplication {
    static func vibrate(_ mode: VibrationMode) {
        switch mode {
        case .Weak:
            AudioServicesPlaySystemSound(1519) // Actuate "Peek" feedback (weak boom)
        case .Strong:
            AudioServicesPlaySystemSound(1520) // Actuate "Pop" feedback (strong boom)
        case .MultipleWeak:
            AudioServicesPlaySystemSound(1521) // Actuate "Nope" feedback (series of three weak booms)
        }
    }
}




// Extension to get the most top viewController
extension UIApplication {
    class func topViewController() -> UIViewController? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window?.visibleViewController()
    }
    
    func openApp(appUrl:String, webUrl:String) {
        guard let appUrl = URL(string: appUrl), let webUrl = URL(string: webUrl) else {return}
        if UIApplication.shared.canOpenURL(appUrl) {
            UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
        }
    }
    
    func shareItem(url:URL) {
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        guard let topVc = UIApplication.topViewController() else {return}
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            if let currentPopoverpresentioncontroller = activity.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = topVc.navigationController?.navigationBar ?? topVc.view
                currentPopoverpresentioncontroller.sourceRect = topVc.navigationController?.navigationBar.bounds ?? CGRect(x: 0, y: 0, width: topVc.view.bounds.width, height: 50)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
            }
        }
        
        DispatchQueue.main.async {
            topVc.present(activity, animated: true, completion: nil)
        }
    }
    
    
    func shareString(string:String) {
        let activity = UIActivityViewController(activityItems: [string], applicationActivities: nil)
        guard let topVc = UIApplication.topViewController() else {return}
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            if let currentPopoverpresentioncontroller = activity.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = topVc.navigationController?.navigationBar ?? topVc.view
                currentPopoverpresentioncontroller.sourceRect = topVc.navigationController?.navigationBar.bounds ?? CGRect(x: 0, y: 0, width: topVc.view.bounds.width, height: 50)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
            }
        }
        
        DispatchQueue.main.async {
            topVc.present(activity, animated: true, completion: nil)
        }
    }
    
    func shareImage(_ image:UIImage) {
        DispatchQueue.main.async {
            guard let vc = UIApplication.topViewController() else {return}
            // set up activity view controller
            let imageToShare:[Any] = [image]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = vc.view // so that iPads won't crash
            
            // present the view controller
            vc.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func setAppIconBadgeNumber(value:Int) {
        UIApplication.shared.applicationIconBadgeNumber = value
    }
    
}

extension UIWindow {
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController  = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        if vc.isKind(of: UINavigationController.self) {
            guard let navigationController = vc as? UINavigationController else {return vc}
            guard let visible = navigationController.visibleViewController else {return navigationController}
            return UIWindow.getVisibleViewControllerFrom( vc: visible)
        } else if vc.isKind(of: UITabBarController.self) {
            guard let tabBarController = vc as? UITabBarController else {return vc}
            guard let selected = tabBarController.selectedViewController else {return tabBarController}
            return UIWindow.getVisibleViewControllerFrom(vc: selected)
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
            } else {
                return vc;
            }
        }
    }
}


