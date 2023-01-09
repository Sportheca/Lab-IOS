//
//  ServerManager + Login.swift
//
//
//  Created by Roberto Oliveira on 08/01/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

enum LoginStatus {
    case Success
    case Failed
}

extension ServerManager {
    
    func signIn(email:String, password:String, trackEvent:Int?, completion: @escaping (_ status:LoginStatus, _ message:String?)->Void) {
        let device = UIApplication.shared.currentDevice()
        let iosVersion = UIApplication.shared.deviceModel()
        let appVersion =  UIApplication.shared.appVersion()
        let info:[String:Any] = ["os":1, "dev":device, "osv":iosVersion, "apv":appVersion as Any, "email":email, "senha":password]
        APIManager.shared.post(sufix: "signin", header: self.header(trackEvent: trackEvent, trackValue: nil), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = Int.intValue(from: dict["Status"]) else {
                completion(.Failed, nil)
                return
            }
            switch status {
            case 200:
                guard let obj = dict["Object"] as? [String:Any] else {
                    completion(.Failed, nil)
                    return
                }
                self.currentSessionId = Int.intValue(from: obj["sId"]) ?? 0
                guard let id = String.stringValue(from: obj["id"]) else {
                    completion(.Failed, nil)
                    return
                }
                let userName = String.stringValue(from: obj["nome"])
                let userEmail = String.stringValue(from: obj["email"])
                let coins = Int.intValue(from: obj["moedas"])
                let token = String.stringValue(from: obj["token"])
                let termsVersion = Float.floatValue(from: obj["rv"])
                let badges = Int.intValue(from: obj["badges"])
                let imageUrl = String.stringValue(from: obj["img"])
                let cpf = String.stringValue(from: obj["cpf"])
                let phone = String.stringValue(from: obj["celular"])
                let bornAt = Date.dateFrom(string: String.stringValue(from: obj["dn"]) ?? "", format: "yyyy-MM-dd")
                let dtCreated = Date.dateFrom(string: String.stringValue(from: obj["dtCreated"]) ?? "", format: "yyyy-MM-dd")
                let isMember = Int.intValue(from: obj["socioTorcedor"]) == 1
                let membershipToken = String.stringValue(from: obj["tokenST"])
                
                // Gender
                var gender:Gender?
                if let genderKey = String.stringValue(from: obj["sexo"]) {
                    if genderKey.uppercased() == "M" {
                        gender = .Male
                    } else if genderKey.uppercased() == "F" {
                        gender = .Female
                    } else if genderKey.uppercased() == "O" {
                        gender = .Other
                    }
                }
                
                DispatchQueue.global(qos: .default).async {
                    // Create User
                    let user = User(id: id)
                    user.signupAt = dtCreated
                    
                    user.imageUrl = imageUrl
                    user.name = userName
                    user.email = userEmail
                    user.phone = phone
                    user.born = bornAt
                    user.cpf = cpf
                    user.gender = gender
                    
                    user.coins = coins
                    user.badges = badges
                    
                    user.token = token
                    user.termsVersion = termsVersion ?? 0.0
                    
                    user.membershipMode = isMember ? .Active : .None
                    user.membershipToken = membershipToken ?? ""
                    
                    user.save()
                    ServerManager.shared.user = user
                    UserDefaultsManager.shared.setLastUserId(id: id)
                    UserDefaultsManager.shared.setLastUserEmail(email)
                    
                    DispatchQueue.main.async {
                        completion(.Success, nil)
                    }
                }
                return
            case 404:
                let message = dict["msg"] as? String
                completion(.Failed, message)
                return
            default:
                completion(.Failed, dict["msg"] as? String)
                return
            }
        }
    }
    
    
    
    
    func recoverPassword(email: String, completion: @escaping (_ success:Bool?, _ message:String?)->Void) {
        let info:[String:Any] = ["email":email]
        APIManager.shared.post(sufix: "recuperaSenha", header: self.header(trackEvent: EventTrack.Signin.recoverPassword, trackValue: nil), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = dict["Status"] as? Int else {
                completion(nil, nil)
                return
            }
            switch status {
            case 200:
                completion(true, dict["msg"] as? String)
                return
            default:
                completion(false, dict["msg"] as? String)
                return
            }
        }
    }
    
    func signUp(name:String, email:String, password:String, trackEvent:Int?, completion: @escaping (_ success:Bool?, _ message:String?)->Void) {
        let newUserID = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        var info:[String:Any] = ["id":newUserID]
        if name != "" {
            info["nome"] = name
        }
        if email != "" {
            info["email"] = email
        }
        if password != "" {
            info["senha"] = password
        }
        APIManager.shared.post(sufix: "signup", header: self.header(trackEvent: trackEvent, trackValue: nil), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = dict["Status"] as? Int else {
                completion(nil, nil)
                return
            }
            switch status {
            case 200:
                // deu certo, faz signin
//                ServerManager.shared.signIn(email: email, password: password, trackEvent: nil, shouldTryAgain: true, completion: { (loginStatus:LoginStatus, message:String?) in
//                    completion(loginStatus == LoginStatus.Success, nil)
//                })
                DispatchQueue.global(qos: .default).async {
                    // Create User
                    let user = User(id: newUserID)
                    user.signupAt = Date.now()
                    user.name = name
                    user.email = email
                    if let object = dict["Object"] as? [String:Any] {
                        user.token = String.stringValue(from: object["token"])
                    }
                    user.save()
                    ServerManager.shared.user = user
                    UserDefaultsManager.shared.setLastUserId(id: newUserID)
                    UserDefaultsManager.shared.setLastUserEmail(email)
                    
                    DispatchQueue.main.async {
                        completion(true, nil)
                    }
                }
                return
            case 403:
                // já tem um user com esse id
                self.signUp(name: name, email: email, password: password, trackEvent: nil, completion: completion)
                return
                
            default:
                // deu erro
                completion(false, dict["msg"] as? String)
                return
            }
            
        }
    }
    
    
}
