//
//  UserDefaultsManager.swift
//
//
//  Created by Roberto Oliveira on 25/10/2017.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    // MARK: - Shared
    static var shared:UserDefaultsManager = UserDefaultsManager()
    
    // MARK: - Properties
    private let sessionEndKey = "sessionEndKey"
    private let lastUserIdKey = "lastUserIdKey"
    private let lastUserEmailKey = "lastUserEmailKey"
    private let userApnsKey = "userApnsKey"
    private let notificationRequestKey = "notificationRequestKey"
    private let serverCreatedUserIdKey = "serverCreatedUserIdKey"
    
    
    // MARK: - Sessions
    func setSessionEnd(info:[String:Any]?) {
        Foundation.UserDefaults.standard.set(info, forKey: self.sessionEndKey)
    }
    
    func lastSessionEnd() -> [String:Any]? {
        return Foundation.UserDefaults.standard.value(forKey: self.sessionEndKey) as? [String:Any]
    }
    
    
    
    // MARK: - User Id
    func lastUserId() -> String? {
        return Foundation.UserDefaults.standard.object(forKey: self.lastUserIdKey) as? String
    }
    
    func setLastUserId(id: String?) {
        Foundation.UserDefaults.standard.set(id, forKey: self.lastUserIdKey)
    }
    
    
    // MARK: - User Email
    func setLastUserEmail(_ email:String?) {
        Foundation.UserDefaults.standard.setValue(email, forKey: self.lastUserEmailKey)
    }
    
    func lastUserEmail() -> String? {
        return Foundation.UserDefaults.standard.string(forKey: self.lastUserEmailKey)
    }
    
    
    // MARK: - User APNS
    func setuserApns(_ apns:String?) {
        Foundation.UserDefaults.standard.setValue(apns, forKey: self.userApnsKey)
    }
    
    func userApns() -> String? {
        return Foundation.UserDefaults.standard.string(forKey: self.userApnsKey)
    }
    
    
    
}






