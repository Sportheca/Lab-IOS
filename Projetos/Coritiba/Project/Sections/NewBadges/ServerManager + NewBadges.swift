//
//  ServerManager + NewBadges.swift
//  
//
//  Created by Roberto Oliveira on 20/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

struct NewBadge {
    var id:Int
    var title:String
    var subtitle:String?
    var imageUrlString:String?
}

extension ServerManager {
    
    func getNewBadges(trackEvent:Int?, completion: @escaping (_ items:[NewBadge]?)->Void) {
        APIManager.shared.get(sufix: "getNewBadges", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            
            var items:[NewBadge] = []
            
            if let infos = object["itens"] as? [[String:Any]] {
                for info in infos {
                    guard let id = Int.intValue(from: info["id"]), let title = String.stringValue(from: info["nome"]) else {continue}
                    let subtitle = String.stringValue(from: info["descricao"])
                    let imageUrl = String.stringValue(from: info["img"])
                    items.append(NewBadge(id: id, title: title, subtitle: subtitle, imageUrlString: imageUrl))
                }
            }
            
            completion(items)
        }
    }
    
    
    
}
