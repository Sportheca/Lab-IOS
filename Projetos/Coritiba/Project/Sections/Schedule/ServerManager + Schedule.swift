//
//  ServerManager + Schedule.swift
//
//
//  Created by Roberto Oliveira on 05/11/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import Foundation

struct ScheduleMatchesGroup {
    var id:Int
    var title:String
    var items:[ScheduleMatchItem]
}

struct ScheduleMatchItem {
    var id:Int
    var title:String
    var categoryTitle:String
    var imageUrl0:String?
    var imageUrl1:String?
    var date:Date?
    var placeDescription:String
    var linkUrlString:String?
    var isEmbed:WebContentPresentationMode
    let chanels:[String]
    var isCheckinAllowed:Bool
}


extension ServerManager {
    
    func getSchedule(home:Bool, trackEvent:Int?, completion: @escaping (_ objects:[ScheduleMatchesGroup]?, _ message:String?)->Void) {
        let sufix = home ? "home=1" : ""
        APIManager.shared.get(sufix: "getJogos?\(sufix)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil, nil)
                return
            }
            let hideDates:Bool = Int.intValue(from: object["hide"]) == 1
            
            var items:[Int:[ScheduleMatchItem]] = [:]
            
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let id = Int.intValue(from: obj["id"]),
                    let headerTitle = String.stringValue(from: obj["header"]),
                    let title = String.stringValue(from: obj["title"]),
                    let placeDescription = String.stringValue(from: obj["estadio"]),
                    let dateString = String.stringValue(from: obj["dataHora"])
                    else {continue}
                    
                    var realDate:Date? = Date.dateFrom(string: dateString, format: "yyyy-MM-dd HH:mm:ss")
                    let date:Date? = Date.dateFrom(string: realDate?.stringWith(format: "yyyy-MM-dd") ?? "", format: "yyyy-MM-dd")
                    if hideDates {
                        realDate = nil
                    }
                    
                    let linkUrlString = String.stringValue(from: obj["linkCompra"])
                    let imageUrl0 = String.stringValue(from: obj["clubeImg1"])
                    let imageUrl1 = String.stringValue(from: obj["clubeImg2"])
                    
                    let chanels:[String] = obj["channels"] as? [String] ?? []
//                    var chanelsIds:[Int] = []
//                    let chanelsString = String.stringValue(from: obj["idTransmissao"]) ?? ""
//                    for i in chanelsString.components(separatedBy: ",") {
//                        let chanelID = Int.intValue(from: i) ?? 0
//                        if chanelID > 0 {
//                            chanelsIds.append(chanelID)
//                        }
//                    }
                    
                    
                    let isCheckinAllowed = Int.intValue(from: obj["permiteCheckIn"]) == 1
                    
                    let embed = WebContentPresentationMode.from(obj["embed"])
                    let isEmbed = embed
                    
                    let item = ScheduleMatchItem(id: id, title: title, categoryTitle: headerTitle, imageUrl0: imageUrl0, imageUrl1: imageUrl1, date: realDate, placeDescription: placeDescription, linkUrlString: linkUrlString, isEmbed: isEmbed, chanels: chanels, isCheckinAllowed: isCheckinAllowed)
                    let timestamp:Int = Int.intValue(from: date?.timeIntervalSince1970) ?? 0
                    if let _ = items[timestamp] {
                        if home == false {
                            items[timestamp]?.append(item)
                        }
                    } else {
                        items[timestamp] = [item]
                    }
                }
            }
            
            var groups:[ScheduleMatchesGroup] = []
            
            for (key,values) in items {
                var title = ""
                if let first = values.first {
                    title = first.date?.stringWith(format: "dd/MM") ?? ""
                }
                if hideDates {
                    title = "-"
                }
                var matches = values
                matches.sort { (a:ScheduleMatchItem, b:ScheduleMatchItem) -> Bool in
                    guard let dateA = a.date, let dateB = b.date else {return true}
                    return dateA < dateB
                }
                let group = ScheduleMatchesGroup(id: key, title: title, items: matches)
                groups.append(group)
            }
            
            groups.sort { (a:ScheduleMatchesGroup, b:ScheduleMatchesGroup) -> Bool in
                return a.id < b.id
            }
            
            var message = String.stringValue(from: object["msg"]) ?? ""
            if groups.isEmpty && message.isEmpty {
                message = "Data do próximo jogo ainda não definida"
            }
            completion(groups, message)
        }
    }
    
}
