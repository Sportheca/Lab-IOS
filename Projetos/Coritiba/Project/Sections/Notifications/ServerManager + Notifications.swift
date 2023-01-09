//
//  ServerManager + Notifications.swift
//
//
//  Created by Roberto Oliveira on 28/02/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import Foundation

class NotificationsCentralItem {
    var pushItem:PushNotification
    var title:String
    var message:String
    var date:Date
    var read:Bool
    
    init(pushItem:PushNotification, title:String, message:String, date:Date, read:Bool) {
        self.pushItem = pushItem
        self.title = title
        self.message = message
        self.date = date
        self.read = read
    }
}

extension ServerManager {
    
    func getLogPushUser(page:Int, trackEvent:Int?, completion: @escaping (_ notifications: [NotificationsCentralItem]?, _ limit:Int?, _ margin:Int?)->()) {
        let searchString = "?page=\(page)"
        APIManager.shared.get(sufix: "getNotificationHistory\(searchString)", header: self.header(trackEvent: trackEvent), sendInfo: nil) { (dictObj:[String:Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let obj = dict["Object"] as? [String:Any] else {
                completion(nil, nil, nil)
                return
            }
            var notifications:[NotificationsCentralItem] = []
            
            if let objects = obj["itens"] as? [[String:Any]] {
                for object in objects {
                    guard let type = PushNotificationType(rawValue: (Int.intValue(from: object["tipo"]) ?? 0)),
                        let idPush = Int.intValue(from: object["idPush"]),
                        let date = Date.dateFrom(string: String.stringValue(from: object["dataHora"]) ?? "", format: "yyyy-MM-dd HH:mm:ss")
                        else {continue}

                    let title = String.stringValue(from: object["titulo"]) ?? ""
                    let msg = String.stringValue(from: object["msg"]) ?? ""
                    let read = Int.intValue(from: object["visualizou"]) == 1

                    let pushItem = PushNotification(type: type, id: idPush, value1: (object["id"] as? Int), value2: (object["id2"] as? Int))
                    notifications.append(NotificationsCentralItem(pushItem: pushItem, title: title, message: msg, date: date, read: read))
                }
            }
            let amount = (Int.intValue(from: dict["limit"]))
            let margin = (Int.intValue(from: dict["margin"]))
            completion(notifications, amount, margin)
        }
    }
    
    func setLogPushOpen(_ pushId:Int, trackId:Int?) {
        APIManager.shared.get(sufix: "setVisualizouPush?idPush=\(pushId)", header: self.header(trackEvent: trackId, trackValue: pushId), sendInfo: nil) { (dictObj:[String:Any]?, serverError:ServerError?) in
            // -----
        }
    }
    
    func setPushNotificationAllRead(trackId:Int?) {
        APIManager.shared.get(sufix: "setAllRead", header: self.header(trackEvent: trackId, trackValue: nil), sendInfo: nil) { (dictObj:[String:Any]?, serverError:ServerError?) in
            // -----
        }
    }
    
}


