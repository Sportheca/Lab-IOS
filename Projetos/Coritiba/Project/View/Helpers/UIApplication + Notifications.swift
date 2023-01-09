//
//  UIApplication + Notifications.swift
//
//
//  Created by Roberto Oliveira on 26/01/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

enum NotificationName:String {
    case ForceLogout = "forceLogout"
    case DidRegisterForNotifications = "DidRegisterForNotifications"
}

var global_logout_presented = false
extension UIApplication {
    
    func forceLogout() {
        LocalSessionManager.shared.saveSessionEnd(mode: .AccountChange)
        // This application sends a notification to splash screen to force logout when necessary
        // - If app is in background and new terms are not accepted by user, logout this user
        ServerManager.shared.user = nil
        ServerManager.shared.userImage = nil
        UserDefaultsManager.shared.setLastUserId(id: nil)
        
        NotificationCenter.default.post(name: Notification.Name(NotificationName.ForceLogout.rawValue), object: nil)
    }
    
    func deleteDownloadsDirectoryContents() {
        // Delete all downloaded Files
        do {
            let fileManager = FileManager.default
            let documentFolderURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let downloadsURL = documentFolderURL.appendingPathComponent(ProjectManager.downloadsPath)
            let filePaths = try fileManager.contentsOfDirectory(atPath: downloadsURL.path)
            for filePath in filePaths {
                let absolutePath = downloadsURL.appendingPathComponent(filePath)
                try fileManager.removeItem(atPath: absolutePath.path)
            }
        } catch {
            // Something failed while deleting files
        }
    }
    
}
