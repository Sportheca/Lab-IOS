//
//  ServerManager + Rating.swift
//
//
//  Created by Roberto Oliveira on 22/06/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

struct RatingDetails {
    var emptyOption:RatingOption
    var options:[RatingOption]
}

struct RatingOption {
    var id:Int
    var title:String
    var message:String
    var imageUrl:String?
    var showTextInput:Bool
    var requestStoreReview:Bool
}

extension ServerManager {
    
    func getRatingDetails(trackEvent:Int?, completion: @escaping (_ item:RatingDetails?, _ message:String?)->Void) {
        APIManager.shared.get(sufix: "getRatingDetails", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil, nil)
                return
            }
            let errorMessage = String.stringValue(from: object["Message"])
            
            var emptyOption:RatingOption = RatingOption(id: 0, title: "AVALIE SUA EXPERIÊNCIA", message: "Como você avaliaria a sua experiência em nosso app até agora?", imageUrl: nil, showTextInput: false, requestStoreReview: false)
            
            var items:[RatingOption] = []
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let id = Int.intValue(from: obj["star"]) else {continue}
                    let imageUrl = String.stringValue(from: obj["img"])
                    let title = String.stringValue(from: obj["titulo"]) ?? ""
                    let message = String.stringValue(from: obj["msg"]) ?? ""
                    let showTextInput = Int.intValue(from: obj["showInput"]) == 1
                    let requestStoreReview = Int.intValue(from: obj["store"]) == 1
                    
                    let item = RatingOption(id: id, title: title, message: message, imageUrl: imageUrl, showTextInput: showTextInput, requestStoreReview: requestStoreReview)
                    if id == 0 {
                        emptyOption = item
                    } else {
                        items.append(item)
                    }
                }
            }
            
            let item = RatingDetails(emptyOption: emptyOption, options: items)
            completion(item, errorMessage)
        }
    }
    
    
    
    
    
    func setRating(item:RatingOption, message:String?, trackEvent:Int?, completion: @escaping (_ success:Bool?, _ message:String?)->Void) {
        let msg = message?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let info:[String:Any] = ["stars":item.id, "msg":msg]
        // API Method
        APIManager.shared.post(sufix: "setRating", header: self.header(trackEvent: trackEvent, trackValue: item.id), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = Int.intValue(from: dict["Status"]) else {
                completion(false, nil)
                return
            }
            let message = String.stringValue(from: dict["msg"])
            if status == 200 {
                completion(true, message)
            } else {
                completion(false, message)
            }
        }
    }
    
    
    
}
