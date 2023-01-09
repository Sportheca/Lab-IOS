//
//  ServerManager + AudioLibrary.swift
//  
//
//  Created by Roberto Oliveira on 3/23/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

struct AudioLibraryGroup {
    var id:Int
    var title:String = ""
    
    init(id:Int) {
        self.id = id
    }
}

struct AudioLibraryGroupItem {
    var id:Int
    var title:String
    var imageUrl:String?
    var date:Date?
    var fileUrlString:String?
    var durationDescription:String
}

extension ServerManager {
    
    func getAudioLibraryGroupItems(id:Int, requiredItemID:Int?, page:Int, trackEvent:Int?, completion: @escaping (_ objects:[AudioLibraryGroupItem]?, _ limit:Int?, _ margin:Int?)->Void) {
        APIManager.shared.get(sufix: "getPlaylists?page=\(page)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil, nil, nil)
                return
            }
            var items:[AudioLibraryGroupItem] = []
            var ids:[Int] = []
            
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let itemID = Int.intValue(from: obj["id"]) else {continue}
                    let title:String = String.stringValue(from: obj["titulo"]) ?? ""
                    let date = Date.dateFrom(string: String.stringValue(from: obj["dataHora"]) ?? "", format: "yyyy-MM-dd HH:mm:ss")
                    let durationDescription:String = String.stringValue(from: obj["duracao"]) ?? ""
                    let fileUrlString:String? = String.stringValue(from: obj["audio"])
                    let imageUrl:String? = String.stringValue(from: obj["img"])
                    let item = AudioLibraryGroupItem(id: itemID, title: title, imageUrl: imageUrl, date: date, fileUrlString: fileUrlString, durationDescription: durationDescription)
                    items.append(item)
                    ids.append(itemID)
                }
            }
            
            let limit = Int.intValue(from: object["limit"])
            let margin = Int.intValue(from: object["margin"])
            
            if let requiredID = requiredItemID {
                if !ids.contains(requiredID) {
                    ServerManager.shared.getAudioLibraryItem(id: requiredID) { (requiredItem:AudioLibraryGroupItem?) in
                        if let item = requiredItem {
                            items.append(item)
                        }
                        completion(items, limit, margin)
                    }
                    return
                }
            }
            
            completion(items, limit, margin)
        }
    }
    
    
    
    
    func getAudioLibraryItemLyrics(id:Int) {
        APIManager.shared.get(sufix: "getAudio?id=\(id)", header: self.header(), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {return}
            guard let itemID = Int.intValue(from: object["id"]), let lyrics = String.stringValue(from: object["lyrics"]) else {return}
            AudioLibraryManager.shared.lyricsDataSource[itemID] = lyrics
        }
    }
    
    func getAudioLibraryItem(id:Int, completion: @escaping (_ item:AudioLibraryGroupItem?)->Void) {
        APIManager.shared.get(sufix: "getAudio?id=\(id)", header: self.header(), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            guard let itemID = Int.intValue(from: object["id"]) else {
                completion(nil)
                return
            }
            let title:String = String.stringValue(from: object["titulo"]) ?? ""
            let date = Date.dateFrom(string: String.stringValue(from: object["dataHora"]) ?? "", format: "yyyy-MM-dd HH:mm:ss")
            let durationDescription:String = String.stringValue(from: object["duracao"]) ?? ""
            let fileUrlString:String? = String.stringValue(from: object["audio"])
            let imageUrl:String? = String.stringValue(from: object["img"])
            let item = AudioLibraryGroupItem(id: itemID, title: title, imageUrl: imageUrl, date: date, fileUrlString: fileUrlString, durationDescription: durationDescription)
            completion(item)
        }
    }
    
}
