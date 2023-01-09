//
//  ServerManager.swift
//
//
//  Created by Roberto Oliveira on 19/10/2017.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

enum LoadingStatus {
    case NotRequested
    case Loading
    case Completed
}

struct BasicInfo {
    var id:Int
    var title:String
}

// MARK: - ServerManager
class ServerManager {
    
    // MARK: - Shared
    static var shared:ServerManager = ServerManager()
    
    
    // MARK: - User
    var user:User?
    var userImage:UIImage?
    var currentSessionId:Int = 0
    var lastTermsVersion:Float = 1.0
    
    
    // MARK: - Header Methods
    func header(trackEvent:Int? = nil, trackValue:Any? = nil) -> String {
        let userID:String = self.user?.id ?? ""
        var track = ""
        if let event = trackEvent {
            if let value = trackValue {
                track = "\(event)/\(value)"
            } else {
                track = "\(event)"
            }
        }
        let token = self.user?.token ?? ""
        let session = self.currentSessionId
        let header = "\(userID):\(track):\(token):\(session)"
        return header
    }
    
    
    
    
    func setTrack(trackEvent:Int?, trackValue:Any?) {
        APIManager.shared.post(sufix: "saveTracking", header: self.header(trackEvent: trackEvent, trackValue: trackValue), postInfo: [:]) { (dictObj:[String : Any]?, serverError:ServerError?) in
            // --
        }
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - API JSON Filter
    // All API JSON returns passes here to check if anything need to be done before continue
    func checkServerInvalidations(info:[String:Any]?) {
        guard let dict = info else {return}
        let status = dict["Status"] as? Int
        // check Invalid Token
        if status == 406 {
            DispatchQueue.main.async {
                if global_logout_presented == false {
                    global_logout_presented = true
                    UIApplication.topViewController()?.titleAlert(title: "Sessão expirada", message: "Por favor, faça login novamente", handler: { (_) in
                        UIApplication.shared.forceLogout()
                        global_logout_presented = false
                    })
                }
            }
            return
        }
        var delay:TimeInterval = 0.0
        // Check Request Rating
        if Int.intValue(from: dict["requestRating"]) == 1 {
            delay += 0.5
            DispatchQueue.main.asyncAfter(deadline: .now()+delay) {
                RatingViewController.present()
            }
        }
        // check new badges
        if let newBadges = dict["newBadges"] as? [[String:Any]] {
            var items:[NewBadge] = []
            for item in newBadges {
                guard let id = Int.intValue(from: item["id"]), let title = String.stringValue(from: item["nome"]) else {continue}
                let subtitle = String.stringValue(from: item["descricao"])
                let imageUrlString = String.stringValue(from: item["img"])
                items.append(NewBadge(id: id, title: title, subtitle: subtitle, imageUrlString: imageUrlString))
            }
            if !items.isEmpty {
                delay += 0.5
                DispatchQueue.main.asyncAfter(deadline: .now()+delay) {
                    let vc = NewBadgesViewController()
                    vc.dataSource = items
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overFullScreen
                    UIApplication.topViewController()?.present(vc, animated: false, completion: nil)
                }
            }
        }
        
        return
    }

    var isHomePresented:Bool = false

    
    
    // MARK: - User APNS
    func updateUserAPNS() { // Called always when app becomes active
        guard let user = self.user else {return}
        if let userApns = UserDefaultsManager.shared.userApns() {
            var info:[String:Any] = ["idUser":user.id, "apns":userApns, "os":1]
            
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { (settings) in
                if settings.authorizationStatus == .notDetermined {
                    info["allow"] = 0
                } else if settings.authorizationStatus == .denied {
                    info["allow"] = 2
                } else if settings.authorizationStatus == .authorized {
                    info["allow"] = 1
                }
                
                APIManager.shared.post(sufix: "setUserApns", header: self.header(), postInfo: info, completion: { (dictObj:[String : Any]?, serverError:ServerError?) in
                    // --
                })
            })
        }
    }
    
    
    
    // MARK: - Download Methods
    func downloadImage(urlSufix:String, completion: @escaping (_ image:UIImage?)->Void) {
        if DebugManager.shared.isImageDownloadForcedFail {
            completion(nil)
            return
        }
        if urlSufix.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            completion(nil)
            return
        }
        APIManager.shared.downloadImage(sufix: urlSufix) { (object:UIImage?) in
            completion(object)
        }
    }
    
    
    
    
    
    
    func getAds(position:AdsPosition, schemeID:Int, completion: @escaping (_ imageUrl:String?)->Void) {
//        APIManager.shared.get(sufix: "getAds?pos=\(position.rawValue)&scheme=\(schemeID)", header: self.header(), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
//            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
//                completion(nil) // Failed
//                return
//            }
//        }
        completion(nil)
    }
    
    
    func checkIfUserIsRegistered(completion: @escaping (_ confirmed:Bool)->Void) {
        if !self.isUserRegistered() {
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    let vc = CompleteSignupViewController()
                    vc.modalTransitionStyle = .coverVertical
                    vc.modalPresentationStyle = .fullScreen
                    UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                }
            }
            completion(false)
            return
        } else {
            completion(true)
            return
        }
    }
    
    func isUserRegistered() -> Bool {
        let userEmail = self.user?.email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return userEmail != ""
    }
    

}


