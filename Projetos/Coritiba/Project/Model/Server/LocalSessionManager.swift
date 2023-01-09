//
//  LocalSessionManager.swift
//
//
//  Created by Roberto Oliveira on 18/08/21.
//  Copyright © 2021 Roberto Oliveira. All rights reserved.
//

import Foundation


/*
Setup Guide:
 
 1.0 - Copy this file to the project Server folder
 1.1 - Check if AppDelegate checkAppVersion function is updated to "switch" version
 
 2.0 - Remove "SessionEndMode" enum from MaintenanceViewController.swift
 2.1 - Remove setLastSessionEnd and setSessionEnd methods from "ServerManager + Version.swift"
 2.2 - Remove self.setLastSessionEnd() from getVersion Method
 2.3 - Remove ServerManager.shared.setSessionEnd(mode: .Background) from AppDelegate.swift
 2.4 - Remove ServerManager.shared.setSessionEnd(mode: .Kill) from AppDelegate.swift
 
 3.0 - Add "LocalSessionManager.shared.saveSessionEnd(mode: .Background)" to AppDelegate applicationDidEnterBackground method
 3.1 - Add "LocalSessionManager.shared.saveSessionEnd(mode: .Kill)" to AppDelegate applicationWillTerminate method
 3.2 - Add "LocalSessionManager.shared.sendSessionEndsToAPI()" to ServerManager completeGetVersion (status 200) case
 3.3 - Add "LocalSessionManager.shared.saveSessionEnd(mode: .AccountChange)" to "UIApplication + Notifications.swift" first line inside forceLogout function

*/

struct LocalSessionEndInfo {
    var sessionID:Int
    var endMode:Int
    var dateTime:String
    var header:String
    
    func infoString() -> String {
        let s = LocalSessionManager.infoSeparator
        return "\(self.sessionID)\(s)\(self.endMode)\(s)\(self.dateTime)\(s)\(self.header)"
    }
    
    static func fromString(_ string:String) -> LocalSessionEndInfo? {
        let infos = string.components(separatedBy: LocalSessionManager.infoSeparator) // [info, info, info, info]
        guard infos.count == 4 else {return nil}
        let sessionID:Int = Int.intValue(from: infos[0]) ?? 0
        let endMode:Int = Int.intValue(from: infos[1]) ?? 0
        let dateTime:String = infos[2]
        let header:String = infos[3]
        let object = LocalSessionEndInfo(sessionID: sessionID, endMode: endMode, dateTime: dateTime, header: header)
        return object
    }
    
}

class LocalSessionManager {
    
    // MARK: - Shared Access
    private init() {}
    static let shared:LocalSessionManager = LocalSessionManager()
    
    
    // Enum
    enum SessionEndMode:Int {
        case Kill = 1
        case Background = 2
        case AccountChange = 3
        
        func title() -> String {
            switch self {
                case .Kill: return "Kill"
                case .Background: return "Background"
                case .AccountChange: return "AccountChange"
            }
        }
    }
    
    
    
    // MARK: - Properties
    static let logKey:String = "\n#LocalSessionManager: "
    static let userDefault_Key:String = "LocalSessionManager_userDefault_Key"
    static let itemsSeparator:String = ";"
    static let infoSeparator:String = "$"
    
    
    
    
    
    // MARK: - Public Methods
    func saveSessionEnd(mode:LocalSessionManager.SessionEndMode) { // called from AppDelegate
        print(LocalSessionManager.logKey + "saveSessionEnd called: \(mode.title())")
        // Save to device the sessionid, endmode, datetime and header
        let sessionID:Int = ServerManager.shared.currentSessionId
        let dateTime:String = Date.nowDescription()
        let header:String = ServerManager.shared.header()
        let item = LocalSessionEndInfo(sessionID: sessionID, endMode: mode.rawValue, dateTime: dateTime, header: header)
        LocalSessionManager.shared.saveItem(item: item)
    }
    
    func sendSessionEndsToAPI() { // called from ServerManager getVersion
        print(LocalSessionManager.logKey + "sendSessionEndsToAPI called")
        let items = LocalSessionManager.shared.savedItems()
        for item in items {
            let info:[String:Any] = [
                "sId":item.sessionID,
                "endType":item.endMode,
                "end":item.dateTime
            ]
            print(LocalSessionManager.logKey + "setEndSession id: \(item.sessionID)")
            APIManager.shared.post(sufix: "setEndSession", header: item.header, postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
                guard let dict = dictObj, let status = Int.intValue(from: dict["Status"]) else {return}
                guard status == 200 else {return}
                guard let sessionID = Int.intValue(from: dict["sId"]) else {return}
                LocalSessionManager.shared.setItemAsSent(id: sessionID)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Private Methods
    private func saveItem(item:LocalSessionEndInfo) {
        print(LocalSessionManager.logKey + "saveItem id: \(item.sessionID)")
        // Save LocalSessionEndInfo to device
        var currentItems = LocalSessionManager.shared.savedItems() // [save items array]
        currentItems.append(item) // [saved items array + current item]
        LocalSessionManager.shared.saveItems(items: currentItems)
        LocalSessionManager.shared.sendSessionEndsToAPI()
    }
    
    
    private func saveItems(items:[LocalSessionEndInfo]) {
        print(LocalSessionManager.logKey + "saveItems: \(items)")
        // LocalSessionEndInfo = info$info$info$info
        // string = info$info$info$info;info$info$info$info;info$info$info$info
        
        // consider only the most updated items
        var dictItems:[Int:LocalSessionEndInfo] = [:]
        for item in items {
            dictItems[item.sessionID] = item
        }
        
        
        var string:String = ""
        for (_, item) in dictItems {
            if string != "" {
                // add items separator
                string += LocalSessionManager.itemsSeparator
            }
            string += item.infoString()
        }
        
        Foundation.UserDefaults.standard.setValue(string, forKey: LocalSessionManager.userDefault_Key)
    }
    
    
    private func savedItems() -> [LocalSessionEndInfo] {
        print(LocalSessionManager.logKey + "savedItems called")
        // Find string on local device memory and parse data to return objects
        var objects:[LocalSessionEndInfo] = []
        let string = Foundation.UserDefaults.standard.string(forKey: LocalSessionManager.userDefault_Key) ?? "" // "item;item;item"
        let items = string.components(separatedBy: LocalSessionManager.itemsSeparator) // [item, item, item]
        for item in items {
            // item = info$info$info$info
            guard let object = LocalSessionEndInfo.fromString(item) else {continue}
            objects.append(object)
        }
        print(LocalSessionManager.logKey + "savedItems: \(objects)")
        return objects
    }
    
    
    private func setItemAsSent(id:Int) {
        print(LocalSessionManager.logKey + "setItemAsSent id: \(id)")
        let currentItems:[LocalSessionEndInfo] = LocalSessionManager.shared.savedItems()
        var itemsToBeSaved:[LocalSessionEndInfo] = []
        for item in currentItems {
            if item.sessionID != id {
                itemsToBeSaved.append(item)
            }
        }
        LocalSessionManager.shared.saveItems(items: itemsToBeSaved)
    }
    
    
    
    
}



