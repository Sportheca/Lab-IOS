//
//  ServerManager + SquadSelector.swift
//  
//
//  Created by Roberto Oliveira on 05/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class SquadSelectorInfo {
    var id:Int
    var title:String
    var scheme:SquadScheme
    var completed:Bool = false
    var items:[Int:SquadSelectorItem?] = [:]
    var bannerItem:SquadSelectorBannerItem?
    
    func removeItemAt(position:Int) {
        self.items[position] = nil as SquadSelectorItem?
    }
    
    init(id:Int, title:String, scheme:SquadScheme) {
        self.id = id
        self.title = title
        self.scheme = scheme
        self.items = [
            1 : nil,
            2 : nil,
            3 : nil,
            4 : nil,
            5 : nil,
            6 : nil,
            7 : nil,
            8 : nil,
            9 : nil,
            10 : nil,
            11 : nil,
        ]
    }
}

struct SquadSelectorBannerItem {
    var backColor:UIColor
    var imageUrl:String?
    var urlString:String?
    var isEmbed:WebContentPresentationMode
}

struct SquadSelectorListItem {
    var id:Int
    var title:String
    var subtitle:String
    var shirtNumber:String
    var imageUrl:String?
}

extension ServerManager {
    
    func getSquadSelectorInfo(item:SquadSelectorInfo?, trackEvent:Int?, completion: @escaping (_ success:Bool?)->Void) {
        var sufix:String = ""
        if let id = item?.id {
            sufix = "id=\(id)"
        }
        
        APIManager.shared.get(sufix: "getEscalacao?\(sufix)", header: self.header(trackEvent: trackEvent, trackValue: item?.id), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            let scheme = SquadScheme(rawValue: Int.intValue(from: object["idEsquema"]) ?? 1) ?? SquadScheme.s343
            item?.scheme = scheme
            
            if let objects = object["players"] as? [[String:Any]] {
                var items:[Int:SquadSelectorItem] = [:]
                for obj in objects {
                    guard let pos = Int.intValue(from: obj["pos"]), let objTitle = String.stringValue(from: obj["nome"]) else {continue}
                    let img = String.stringValue(from: obj["img"])
                    items[pos] = SquadSelectorItem(id: 0, title: objTitle, description: nil, imageUrl: img)
                }
                item?.items = [
                    1 : items[1],
                    2 : items[2],
                    3 : items[3],
                    4 : items[4],
                    5 : items[5],
                    6 : items[6],
                    7 : items[7],
                    8 : items[8],
                    9 : items[9],
                    10 : items[10],
                    11 : items[11],
                ]
                item?.completed = true
            }
            
            if let newTitle = String.stringValue(from: object["title"]) {
                item?.title = newTitle
            }
            
            
            if let advertiser = object["patrocinador"] as? [String:Any] {
                var color = Theme.color(.PrimaryButtonBackground)
                let colorString = String.stringValue(from: advertiser["cor"]) ?? ""
                if colorString != "" {
                    color = UIColor(hexString: colorString)
                }
                
                let img = String.stringValue(from: advertiser["img"])
                let url = String.stringValue(from: advertiser["url"])
                let isEmbed = WebContentPresentationMode.from(advertiser["embed"])
                let banner = SquadSelectorBannerItem(backColor: color, imageUrl: img, urlString: url, isEmbed: isEmbed)
                item?.bannerItem = banner
            }
            
            completion(true)
        }
    }
    
    
    func getSquadSelectorItemsList(referenceID:Int?, trackEvent:Int?, trackValue:Int?, completion: @escaping (_ items:[SquadSelectorListItem]?)->Void) {
        var method:String = "getPlayersPalpites"
        if let id = referenceID {
            method = "getPlayersEscalacao?id=\(id)"
        }
        APIManager.shared.get(sufix: method, header: self.header(trackEvent: trackEvent, trackValue: trackValue ?? referenceID), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            
            var groupsNames:[Int:String] = [:]
            if let objects = object["pos"] as? [[String:Any]] {
                for obj in objects {
                    guard let id = Int.intValue(from: obj["id"]), let title = String.stringValue(from: obj["nome"]) else {continue}
                    groupsNames[id] = title
                }
            }
            
            var items:[SquadSelectorListItem] = []
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let id = Int.intValue(from: obj["id"]), let title = String.stringValue(from: obj["nome"]) else {continue}
                    let shirtNumber = Int.intValue(from: obj["camisa"])?.description ?? ""
                    var subtitle:String = ""
                    if let groupID = Int.intValue(from: obj["pos"]) {
                        subtitle = groupsNames[groupID] ?? ""
                    }
                    let img = String.stringValue(from: obj["img"])
                    let item = SquadSelectorListItem(id: id, title: title, subtitle: subtitle, shirtNumber: shirtNumber, imageUrl: img)
                    items.append(item)
                }
            }
            
            completion(items)
        }
    }
    
    
    
    
    func setSquadSelectorInfo(item:SquadSelectorInfo, trackEvent:Int?, completion: @escaping (_ success:Bool?, _ message:String?)->Void) {
        var itemsString:String = ""
        for (position, obj) in item.items {
            guard let object = obj else {continue}
            itemsString += "\(position):\(object.id);"
        }
        let info:[String:Any] = ["idEscalacao":item.id, "idEsquema":item.scheme.rawValue, "players":itemsString]
        // API Method
        APIManager.shared.post(sufix: "setEscalacao", header: self.header(trackEvent: trackEvent, trackValue: nil), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = dict["Status"] as? Int else {
                completion(false, nil)
                return
            }
            if status == 200 {
                item.completed = true
                completion(true, nil)
            } else {
                completion(false, dict["msg"] as? String)
            }
        }
    }
    
}
