//
//  ServerManager + Menu.swift
//
//
//  Created by Roberto Oliveira on 23/10/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import Foundation

extension ServerManager {
    
    func getMenuDynamicItems(trackEvent:Int?, completion: @escaping (_ results:[MenuItem]?)->Void) {
        APIManager.shared.get(sufix: "getMenu", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            
            var objects:[MenuItem] = []
            
            if let items = object["itens"] as? [[String:Any]] {
                for item in items {
                    guard let id = Int.intValue(from: item["id"]) else {continue}
                    let urlString = String.stringValue(from: item["link"]) ?? ""
                    let imageUrl = String.stringValue(from: item["icon"])
                    let title = String.stringValue(from: item["title"]) ?? ""
                    let isEmbed = WebContentPresentationMode.from(item["embed"])
                    
                    var deeplink:PushNotification?
                    if let t = Int.intValue(from: item["t"]) {
                        if let pushType = PushNotificationType(rawValue: t) {
                            deeplink = PushNotification(type: pushType, id: id, value1: Int.intValue(from: item["v"]), value2: Int.intValue(from: item["v2"]))
                        }
                    }
                    objects.append(MenuItem(id: id, type: .DynamicItem, title: title, iconName: "", isIconLarge: false, imageUrlString: imageUrl, link: urlString, isEmbed: isEmbed, deeplink: deeplink))
                }
            }
            completion(objects)
        }
    }
    
}
