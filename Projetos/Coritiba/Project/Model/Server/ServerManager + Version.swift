//
//  ServerManager + Version.swift
//
//
//  Created by Roberto Oliveira on 03/11/2017.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

extension ServerManager {
    
    // MARK: - getVersion
    func getVersion(trackEvent:Int?, trackValue:Int?, completion: @escaping (_ status:VersionStatus?, _ message:String?)->Void) {
        // Create Data Dictionary
        let device = UIApplication.shared.currentDevice()
        let iosVersion = UIDevice.current.systemVersion
        let appVersion =  (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
        var info:[String:Any] = ["dev":device, "os":1, "osv":iosVersion, "v":appVersion]
        if let userId = self.user?.id {
            info["idUser"] = userId
        }
        // API Method
        APIManager.shared.post(sufix: "getVersion", header: self.header(trackEvent: trackEvent, trackValue: trackValue), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = dict["Status"] as? Int else {
                let msg:String = "Ooops, houve um problema ao conectar, verifique sua conexão e tente novamente!"
                completion(.Failed, msg)
                return
            }
            // Server will define witch url will be used for api Path
            let serverAPI = String.stringValue(from: dict["api"]) ?? ""
            ProjectManager.shared.apiPath = "/api/\(serverAPI)/".replacingOccurrences(of: "api//", with: "api/")
            UserDefaults.standard.set(ProjectManager.shared.apiPath, forKey: "apiPath")
            // Session
            self.currentSessionId = (dict["sId"] as? Int) ?? 0
            // Terms
            self.lastTermsVersion = (dict["rv"] as? Float) ?? 1.0
            
            // show floating button if needed

            if let item = dict["floating_btn"] as? [String:Any] {
                let urlString = String.stringValue(from: item["url"])
                let imgUrlString  = String.stringValue(from: item["img"])
                let isEmbed = WebContentPresentationMode.from(item["embed"])
           let infos = ButtonInfos(url: urlString, imgUrl: imgUrlString, isEmbed: isEmbed)
                FloatingButton.shared.currentItem = infos
            }
            
            self.completeGetVersion(status: status, dict: dict, completion: completion)
        }
    }
    
    func completeGetVersion(status:Int, dict:[String : Any], completion: @escaping (_ status:VersionStatus?, _ message:String?)->Void) {
        // Handle version result
        switch status {
        case 200:
            LocalSessionManager.shared.sendSessionEndsToAPI()
            completion(.Updated, nil) // Version OK
            return
        case 425:
            let message = dict["msg"] as? String
            if let url = dict["url"] as? String {
                ProjectManager.shared.itunesLink = url
            }
            completion(.UpdateAvailable, message) // Update Available
            return
        case 403:
            let message = dict["msg"] as? String
            if let url = dict["url"] as? String {
                ProjectManager.shared.itunesLink = url
            }
            completion(.UpdateRequired, message) // Update Required
            return
        case 666:
            let message = dict["msg"] as? String
            completion(.Locked, message) // Server in maintanence
            return
        case 423:
            let message = dict["msg"] as? String
            completion(.Locked, message) // Access Denied
            return
        default:
            completion(.Failed, nil) // Error
            return
        }
    }
    
    
    
}

