//
//  ServerManager + EditProfile.swift
//
//
//  Created by Roberto Oliveira on 23/08/18.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import Foundation

extension ServerManager {
    func updateUser(name:String, email:String, phone:String?, cpf:String?, gender:Gender?, birth:Date?, newPassword:String?, trackEvent:Int?, completion: @escaping (_ success:Bool?, _ message:String?)->Void) {
        var info:[String:Any] = ["nome":name, "socioTorcedor":0]
        
        if email != self.user?.email {
            info["email"] = email
        }
        
        if let phoneInfo = phone {
            info["celular"] = phoneInfo
        }
        
        if gender == .Male {
            info["sexo"] = "M"
        } else if gender == .Female {
            info["sexo"] = "F"
        } else if gender == .Other {
            info["sexo"] = "O"
        }
        
        if let cpfInfo = cpf {
            info["cpf"] = cpfInfo
        }
        
        
        if let date = birth {
            let dateString = date.stringWith(format: "yyyy-MM-dd HH:mm:ss")
            info["dn"] = dateString
        }
        
        if let password = newPassword {
            if password != "" {
                info["senha"] = password
            }
        }
        // API Method
        APIManager.shared.post(sufix: "atualizaUser", header: self.header(trackEvent: trackEvent, trackValue: nil), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = Int.intValue(from: dict["Status"]) else {
                completion(false, nil)
                return
            }
            let message = String.stringValue(from: dict["msg"])
            guard status == 200 else {
                completion(false, message)
                return
            }
            if let obj = self.user {
                obj.name = name
                obj.email = email
                obj.phone = phone
                obj.gender = gender
                obj.born = birth
                obj.cpf = cpf
                obj.save()
            }
            completion(true, message)
        }
    }
    
    
    func updateUserPassword(oldPassword:String, newPassword:String, trackEvent:Int?, completion: @escaping (_ success:Bool?, _ message:String?)->Void) {
        let info:[String:Any] = ["senha":newPassword, "old":oldPassword]
        
        // API Method
        APIManager.shared.post(sufix: "atualizaUser", header: self.header(trackEvent: trackEvent, trackValue: nil), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = Int.intValue(from: dict["Status"]) else {
                completion(false, nil)
                return
            }
            let message = String.stringValue(from: dict["msg"])
            guard status == 200 else {
                completion(false, message)
                return
            }
            completion(true, message)
        }
    }
    
    func setDeleteAccountRequest(password:String, trackEvent:Int?, completion: @escaping ( _ success:Bool?,  _ message:String?)->Void) {
            let info:[String:Any] = ["password":password]
            // API Method
            APIManager.shared.post(sufix: "setDeleteAccount", header: self.header(trackEvent: trackEvent, trackValue: nil), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
                guard let dict = dictObj, let status = Int.intValue(from: dict["Status"]) else {
                    completion(false, nil)
                    return
                }
                let message = String.stringValue(from: dict["msg"])
                let success = (status == 200)
                completion(success, message)
            }
        }
}
