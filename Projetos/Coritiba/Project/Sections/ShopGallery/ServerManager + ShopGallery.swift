//
//  ServerManager + ShopGallery.swift
//  
//
//  Created by Roberto Oliveira on 30/04/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

struct ShopGalleryItem {
    var id:Int
    var title:String
    var imageUrlString:String?
    var membersPrice:Float?
    var price:Float
    var description:String
    var link:String?
    var isEmbed:WebContentPresentationMode
}

extension ServerManager {
    
    func getShopGalleryItems(home:Bool, searchString:String, page:Int, filterID:Int, trackEvent:Int?, completion: @escaping (_ items:[ShopGalleryItem]?, _ limit:Int?, _ margin:Int?)->Void) {
        let search = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchString
        var sufix = "search=\(search)&page=\(page)"
        if filterID > 0 {
            sufix += "&filter=\(filterID)"
        }
        if home == true {
            sufix += "&home=1"
        }
        APIManager.shared.get(sufix: "getLojaVirtualProdutos?\(sufix)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil, nil, nil)
                return
            }
            
            var items:[ShopGalleryItem] = []
            if let values = object["itens"] as? [[String:Any]] {
                for value in values {
                    guard let id = Int.intValue(from: value["id"]), let title = String.stringValue(from: value["nome"]), let price = Float.floatValue(from: value["valor"]) else {continue}
                    let isEmbed = WebContentPresentationMode.from(value["embed"])
                    let imageUrl = String.stringValue(from: value["img"])
                    let link = String.stringValue(from: value["url"])
                    
                    let membersPrice:Float? = Float.floatValue(from: value["valorST"])
                    
                    var description:String = ""
                    if let v0 = Int.intValue(from: value["numeroParcelas"]), let v1 = Float.floatValue(from: value["valorParcelado"]) {
                        description = "Em até \(v0)x de \(v1.moneyFormatBRL())"
                    }
                    items.append(ShopGalleryItem(id: id, title: title, imageUrlString: imageUrl, membersPrice: membersPrice, price: price, description: description, link: link, isEmbed: isEmbed))
                }
            }
            
            let limit = Int.intValue(from: object["limit"])
            let margin = Int.intValue(from: object["margin"])
            
            completion(items, limit, margin)
        }
    }
    
    
    
    func getShopGalleryFilters(trackEvent:Int?, completion: @escaping (_ objects:[BasicInfo]?)->Void) {
        APIManager.shared.get(sufix: "getLojaVirtualProdutosCategorias", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
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


