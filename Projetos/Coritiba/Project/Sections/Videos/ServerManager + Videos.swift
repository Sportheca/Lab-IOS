//
//  ServerManager + Videos.swift
//
//
//  Created by Roberto Oliveira on 17/02/21.
//  Copyright © 2021 Roberto Oliveira. All rights reserved.
//

import Foundation

struct VideosCategory {
    var id:Int
    var title:String
    var sort:Int
}

struct VideosGroup {
    var id:Int
    var title:String
    var items:[VideoItem]
}

struct VideoItem {
    var id:Int
    var categoryID:Int
    var tagTitle:String
    var title:String
    var imageUrl:String
    var videoUrl:String
    var isDigitalMembershipOnly:Bool
    var isHighlighted:Bool
    var date:Date?
}

extension ServerManager {
    
    func getAllVideos(trackEvent:Int?, completion: @escaping (_ objects:[VideosGroup]?, _ message:String?)->Void) {
        APIManager.shared.get(sufix: "getVideosAll", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj else {
                completion(nil, nil)
                return
            }
            let message:String? = String.stringValue(from: dict["msg"])
            guard let object = dict["Object"] as? [String:Any] else {
                completion(nil, message)
                return
            }
            
            var categories:[VideosCategory] = []
            if let categoriesObjects = object["categories"] as? [[String:Any]] {
                for catObj in categoriesObjects {
                    guard let id = Int.intValue(from: catObj["id"]), let title = String.stringValue(from: catObj["titulo"]) else {continue}
                    let sort = Int.intValue(from: catObj["ordem"]) ?? 0
                    categories.append(VideosCategory(id: id, title: title, sort: sort))
                }
            }
            
            
            var items:[VideoItem] = []
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let id = Int.intValue(from: obj["id"]), let title = String.stringValue(from: obj["titulo"]) else {continue}
                    
                    var tagTitle = ""
                    let categoryID = Int.intValue(from: obj["cat"]) ?? 0
                    for category in categories {
                        if category.id == categoryID {
                            tagTitle = category.title
                        }
                    }
                    
                    let imageUrl = String.stringValue(from: obj["img"]) ?? ""
//                    let embedString = String.stringValue(from: obj["embed"]) ?? ""
//                    let videoUrl = embedString.replacingOccurrences(of: "<iframe src=\"", with: "").substringUpTo(char: "?", at: .first, charIncluded: false)
                    let videoUrl = String.stringValue(from: obj["embed"]) ?? ""
//                    let videoUrl = "https://cdn-vos360-latam-01.vos360.video/Content/HLS/Live/channel(7357bb2c-8045-79f2-8f10-fd0f174dd6bb)/variant.m3u8" // test
                    
                    let isDigitalMembershipOnly:Bool = Int.intValue(from: obj["std"]) == 1
                    let isHighlighted:Bool = Int.intValue(from: obj["destaque"]) == 1
                    
                    let date = Date.dateFrom(string: String.stringValue(from: obj["dataHora"]) ?? "", format: "yyyy-MM-dd HH:mm:ss")
                    
                    let item = VideoItem(id: id, categoryID: categoryID, tagTitle: tagTitle, title: title, imageUrl: imageUrl, videoUrl: videoUrl, isDigitalMembershipOnly: isDigitalMembershipOnly, isHighlighted: isHighlighted, date: date)
                    items.append(item)
                }
            }
            items.sort { (a:VideoItem, b:VideoItem) -> Bool in
                guard let d1 = a.date, let d2 = b.date else {return false}
                return d1 > d2
            }
            
            
            var groups:[VideosGroup] = []
            
            // Highlighted Items Group
            var highlightedItems:[VideoItem] = []
            var highlightedItemsIds:[Int] = []
            for item in items {
                if item.isHighlighted && !highlightedItemsIds.contains(item.id) {
                    highlightedItemsIds.append(item.id)
                    highlightedItems.append(item)
                }
            }
            if !highlightedItems.isEmpty {
                groups.append(VideosGroup(id: 0, title: "Recomendados", items: highlightedItems))
            }
            
            // Other Categories
            categories.sort { (a:VideosCategory, b:VideosCategory) -> Bool in
                return a.sort < b.sort
            }
            for category in categories {
                var categoryItems:[VideoItem] = []
                for item in items {
                    if item.categoryID == category.id {
                        categoryItems.append(item)
                    }
                }
                guard !categoryItems.isEmpty else {continue}
                groups.append(VideosGroup(id: category.id, title: category.title, items: categoryItems))
            }
            
            
            
            completion(groups, message)
        }
    }
    
    
    
    
    
    
    func getAllVideosCategory(group:VideosGroup, page:Int, trackEvent:Int?, completion: @escaping (_ objects:[VideoItem]?, _ limit:Int?, _ margin:Int?)->Void) {
        APIManager.shared.get(sufix: "getVideosCategoria?category=\(group.id)&page=\(page)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil, nil, nil)
                return
            }
            var items:[VideoItem] = []
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let id = Int.intValue(from: obj["id"]), let title = String.stringValue(from: obj["titulo"]) else {continue}
                    
                    let tagTitle = group.title
                    let imageUrl = String.stringValue(from: obj["img"]) ?? ""
//                    let embedString = String.stringValue(from: obj["embed"]) ?? ""
//                    let videoUrl = embedString.replacingOccurrences(of: "<iframe src=\"", with: "").substringUpTo(char: "?", at: .first, charIncluded: false)
                    let videoUrl = String.stringValue(from: obj["embed"]) ?? ""
                    
                    let isDigitalMembershipOnly:Bool = Int.intValue(from: obj["std"]) == 1
                    let isHighlighted:Bool = Int.intValue(from: obj["destaque"]) == 1
                    
                    let date = Date.dateFrom(string: String.stringValue(from: obj["dataHora"]) ?? "", format: "yyyy-MM-dd HH:mm:ss")
                    
                    
                    let item = VideoItem(id: id, categoryID: group.id, tagTitle: tagTitle, title: title, imageUrl: imageUrl, videoUrl: videoUrl, isDigitalMembershipOnly: isDigitalMembershipOnly, isHighlighted: isHighlighted, date: date)
                    items.append(item)
                }
            }
            
            let limit = Int.intValue(from: object["limit"])
            let margin = Int.intValue(from: object["margin"])
            
            completion(items, limit, margin)
        }
    }
    
    
    
    
    
    func getVideo(id:Int, trackEvent:Int?, completion: @escaping (_ object:VideoItem?, _ message:String?)->Void) {
        APIManager.shared.get(sufix: "getVideo?id=\(id)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj else {
                completion(nil, nil)
                return
            }
            let message:String? = String.stringValue(from: dict["msg"])
            guard let obj = dict["Object"] as? [String:Any] else {
                completion(nil, message)
                return
            }
            let videoUrl = String.stringValue(from: obj["embed"]) ?? ""
            let isDigitalMembershipOnly:Bool = Int.intValue(from: obj["std"]) == 1
            let item = VideoItem(id: id, categoryID: 0, tagTitle: "", title: "", imageUrl: "", videoUrl: videoUrl, isDigitalMembershipOnly: isDigitalMembershipOnly, isHighlighted: false, date: nil)
            completion(item, nil)
            
        }
    }
    
    
    
    
    
}



