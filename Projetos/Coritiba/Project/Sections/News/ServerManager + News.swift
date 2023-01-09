//
//  ServerManager + News.swift
//  
//
//  Created by Roberto Oliveira on 09/03/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

struct News {
    var id:Int
    var bodyLink:String
    var shareLink:String?
}

struct AllNewsItem {
    var id:Int
    var date:Date?
    var title:String?
    var subtitle:String?
    var imageUrl:String?
    var category:String?
    var urlString:String?
}

extension ServerManager {
    
    func getNews(id:Int, trackEvent:Int?, completion: @escaping (_ item:News?)->Void) {
        APIManager.shared.get(sufix: "getNoticia?id=\(id)", header: self.header(trackEvent: trackEvent, trackValue: id), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            
            let bodyLink:String = String.stringValue(from: object["url"]) ?? ""
            let shareLink:String? = String.stringValue(from: object["share"])
            let item = News(id: id, bodyLink: bodyLink, shareLink: shareLink)
            
            completion(item)
        }
    }
    
    
    func getAllNews(filterID: Int, page:Int, trackEvent:Int?, completion: @escaping (_ objects:[AllNewsItem]?, _ limit:Int?, _ margin:Int?)->Void) {
        var sufix:String = ""
        if filterID > 0 {
            sufix = "&filter=\(filterID)"
        }
        APIManager.shared.get(sufix: "getNoticias?page=\(page)\(sufix)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil, nil, nil)
                return
            }
            var items:[AllNewsItem] = []
            if let objects = object["itens"] as? [[String:Any]] {
                for object in objects {
                    guard let id = Int.intValue(from: object["id"]), let imageUrl = String.stringValue(from: object["img"]) else {continue}
                    let urlString:String? = String.stringValue(from: object["url"])
                    let date:Date? = Date.dateFrom(string: String.stringValue(from: object["data"]) ?? "", format: "dd/MM/yyy")
                    
                    let title:String? = String.stringValue(from: object["titulo"])
                    let subtitle:String? = String.stringValue(from: object["desc"])
                    let category:String? = String.stringValue(from: object["cat"])
                    
                    items.append(AllNewsItem(id: id, date: date, title: title, subtitle: subtitle, imageUrl: imageUrl, category: category, urlString: urlString))
                }
            }
            
            let limit = Int.intValue(from: object["limit"])
            let margin = Int.intValue(from: object["margin"])
            
            completion(items, limit, margin)
        }
    }
    
    
    func getAllNewsFilters(trackEvent:Int?, completion: @escaping (_ objects:[BasicInfo]?)->Void) {
        APIManager.shared.get(sufix: "getNoticiasCategorias", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            var items:[BasicInfo] = []
            if let objects = object["itens"] as? [[String:Any]] {
                for object in objects {
                    guard let id = Int.intValue(from: object["id"]), let title = String.stringValue(from: object["titulo"]) else {continue}
                    items.append(BasicInfo(id: id, title: title))
                }
            }
            if !items.isEmpty {
                items.insert(BasicInfo(id: 0, title: "Todas"), at: 0)
            }
            completion(items)
        }
    }
    
}


