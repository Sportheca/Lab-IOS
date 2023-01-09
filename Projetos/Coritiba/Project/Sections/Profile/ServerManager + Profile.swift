//
//  ServerManager + Profile.swift
//
//
//  Created by Roberto Oliveira on 15/01/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

extension ServerManager {
    
    func getUserBadges(page:Int, trackEvent:Int?, completion: @escaping (_ objects:[BadgeItem]?, _ limit:Int?, _ margin:Int?)->Void) {
        APIManager.shared.get(sufix: "getBadges?page=\(page)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil, nil, nil)
                return
            }
            var items:[BadgeItem] = []
            
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let id = Int.intValue(from: obj["id"]), let imageUrlString = String.stringValue(from: obj["img"]) else {continue}
                    let title = String.stringValue(from: obj["nome"]) ?? ""
                    let message = String.stringValue(from: obj["desc"]) ?? ""
                    let isActive = Int.intValue(from: obj["owned"]) == 1
                    items.append(BadgeItem(id: id, title: title, imageUrl: imageUrlString, message: message, isActive: isActive))
                }
            }
            
            let limit = Int.intValue(from: object["limit"])
            let margin = Int.intValue(from: object["margin"])
            
            completion(items, limit, margin)
        }
    }
    
    
    func getUserInfo(completion: @escaping (_ success:Bool?)->Void) {
        APIManager.shared.get(sufix: "getPerfil", header: self.header(), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            
            var gender:Gender?
            if let genderKey = String.stringValue(from: object["sexo"]) {
                if genderKey.uppercased() == "M" {
                    gender = .Male
                } else if genderKey.uppercased() == "F" {
                    gender = .Female
                } else if genderKey.uppercased() == "O" {
                    gender = .Other
                }
            }
            self.user?.gender = gender
            self.user?.coins = Int.intValue(from: object["moedas"])
            self.user?.badges = Int.intValue(from: object["notifications"])
            self.user?.email = String.stringValue(from: object["email"]) ?? ""
            self.user?.name = String.stringValue(from: object["nome"]) ?? ""
            self.user?.imageUrl = String.stringValue(from: object["img"]) ?? ""
            self.user?.termsVersion = Float.floatValue(from: object["rv"]) ?? 1.0
            self.user?.phone = String.stringValue(from: object["celular"]) ?? ""
            self.user?.cpf = String.stringValue(from: object["cpf"]) ?? ""
            self.user?.born = Date.dateFrom(string: String.stringValue(from: object["dn"]) ?? "", format: "yyyy-MM-dd")
            self.user?.signupAt = Date.dateFrom(string: String.stringValue(from: object["dtCreated"]) ?? "", format: "yyyy-MM-dd")
            
            self.user?.membershipCardID = Int.intValue(from: object["cardId"]) ?? 0
            
            self.user?.save()
            completion(true)
        }
    }
    
    
    func updateAvatar(image:UIImage, completion: @escaping (_ success:Bool?)->Void) {
        let img = image.resizeWithWidth(width: 500) ?? image
        guard let imageData = img.jpegData(compressionQuality: 0.7) else {return}
        APIManager.shared.postImageWithInfo(sufix: "uploadFotoUser", header: self.header(), imageData: imageData, info: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = dict["Status"] as? Int else {
                completion(nil) // Failed
                return
            }
            if status == 200 {
                if let url = dict["img"] as? String {
                    self.downloadImage(urlSufix: url, completion: { (obj:UIImage?) in
                        // Just download this image to be cached later
                    })
                    ServerManager.shared.user?.imageUrl = url
                    ServerManager.shared.user?.save()
                }
                completion(true) // Success
            } else {
                completion(false) // Error
            }
        }
    }
    
}




