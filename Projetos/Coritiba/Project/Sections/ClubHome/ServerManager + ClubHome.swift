//
//  ServerManager + ClubHome.swift
//  
//
//  Created by Roberto Oliveira on 28/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

extension ServerManager {
    
    func getHomeClubSquad(trackEvent:Int?, completion: @escaping (_ items:[ClubHomeSquadGroup]?)->Void) {
        APIManager.shared.get(sufix: "getPlayersAtuais", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            
            var groupsIds:[Int] = []
            var groupsNames:[Int:String] = [:]
            if let objects = object["pos"] as? [[String:Any]] {
                for obj in objects {
                    guard let id = Int.intValue(from: obj["id"]), let title = String.stringValue(from: obj["nome"]) else {continue}
                    groupsIds.append(id)
                    groupsNames[id] = title
                }
            }
            var ids:[Int] = []
            var items:[Int:[ClubHomeSquadItem]] = [:]
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let id = Int.intValue(from: obj["id"]), let groupID = Int.intValue(from: obj["pos"]) else {continue}
                    ids.append(id)
                    let imageUrlString = String.stringValue(from: obj["img"])
                    let item = ClubHomeSquadItem(id: id, imageUrl: imageUrlString)
                    if let _ = items[groupID] {
                        items[groupID]?.append(item)
                    } else {
                        items[groupID] = [item]
                    }
                }
            }
            
            var groups:[ClubHomeSquadGroup] = []
            groupsIds.sort { (a:Int, b:Int) -> Bool in
                return a < b
            }
            for id in groupsIds {
                groups.append(ClubHomeSquadGroup(title: groupsNames[id] ?? "", items: items[id] ?? []))
            }
            completion(groups)
        }
    }
    
}
