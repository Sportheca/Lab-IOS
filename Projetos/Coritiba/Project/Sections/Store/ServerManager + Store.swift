//
//  ServerManager + Store.swift
//
//
//  Created by Roberto Oliveira on 13/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

struct StoreGroup {
    var id:Int
    var title:String
    var items:[StoreItem]
    var backColor:UIColor
}

struct StoreItem {
    var id:Int
    var cuponID:Int?
    var title:String
    var imageUrlString:String?
    var subtitle:String?
    var coins:Int?
    var membershipCoins:Int?
    var isMembershipOnly:Bool
    var priceBlockDescription:String?
//    var itemTheme:PrizeTheme
}

struct StoreItemDetails {
    
    enum Mode:Int {
        case Cupom = 0
        case File = 1
    }
    
    var mode:StoreItemDetails.Mode
    var message:String
    var isDocumentAvailable:Bool
    var isAvailable:Bool = false
    var footerTitle:String?
    var footerInfo:String?
    var footerSubtitle:String?
    var fileUrlString:String?
    var fileName:String
    var fileSize:Int
}

extension ServerManager {
    
    func getStoreGroups(searchString:String, trackEvent:Int?, completion: @escaping (_ items:[StoreGroup]?)->Void) {
        let search = searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? searchString
        APIManager.shared.get(sufix: "getProdutos?search=\(search)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            
            var groupItems:[Int:[StoreItem]] = [:]
            if let values = object["itens"] as? [[String:Any]] {
                for value in values {
                    guard let id = Int.intValue(from: value["id"]), let groupID = Int.intValue(from: value["idGrupo"]), let title = String.stringValue(from: value["nome"]) else {continue}
                    let imageUrlString = String.stringValue(from: value["img"])
                    var subtitle:String?
                    if let dateString = Date.dateFrom(string: String.stringValue(from: value["adquirido"]) ?? "", format: "yyyy-MM-dd")?.stringWith(format: "dd/MM") {
                        subtitle = "ADQUIRIDO EM \(dateString)"
                    }
                    let coins:Int? = Int.intValue(from: value["valor"])
                    let membershipCoins:Int? = Int.intValue(from: value["valorST"])
                    
                    let cuponID:Int? = Int.intValue(from: value["idCupom"])
                    
                    let priceBlockDescription:String? = String.stringValue(from: value["tipoValor"])
                    
                    let isMembershipOnly:Bool = (coins == nil) && (membershipCoins != nil)
                    
//                    let itemTheme = PrizeTheme.themeFrom(string: String.stringValue(from: value["theme"])) ?? PrizeTheme.defaultTheme()
                    
                    let item = StoreItem(id: id, cuponID: cuponID, title: title, imageUrlString: imageUrlString, subtitle: subtitle, coins: coins, membershipCoins: membershipCoins, isMembershipOnly: isMembershipOnly, priceBlockDescription: priceBlockDescription)
                    
                    if let _ = groupItems[groupID] {
                        groupItems[groupID]?.append(item)
                    } else {
                        groupItems[groupID] = [item]
                    }
                }
            }
            
            var groups:[StoreGroup] = []
            if let values = object["grupos"] as? [[String:Any]] {
                for value in values {
                    guard let id = Int.intValue(from: value["id"]), let title = String.stringValue(from: value["titulo"]) else {continue}
                    let colorString = String.stringValue(from: value["color"]) ?? ""
                    let color = colorString == "" ? UIColor.clear : UIColor(hexString: colorString)
                    let items:[StoreItem] = groupItems[id] ?? []
                    if !items.isEmpty {
                        let group = StoreGroup(id: id, title: title, items: items, backColor: color)
                        groups.append(group)
                    }
                }
            }
            
            groups.sort { (a:StoreGroup, b:StoreGroup) -> Bool in
                return a.id < b.id
            }
            
            completion(groups)
        }
    }
    
    
    
    
    
    func getStoreItemDetails(id:Int, cuponID:Int?, trackEvent:Int?, completion: @escaping (_ item:StoreItemDetails?, _ object:StoreItem?)->Void) {
        var sufix = "id=\(id)"
        if let value = cuponID {
            sufix += "&idCupom=\(value)"
        }
        APIManager.shared.get(sufix: "getProduto?\(sufix)", header: self.header(trackEvent: trackEvent, trackValue: id), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil, nil)
                return
            }
            let mode:StoreItemDetails.Mode = StoreItemDetails.Mode(rawValue: Int.intValue(from: object["tipo"]) ?? 0) ?? .Cupom
            let message = String.stringValue(from: object["descricao"]) ?? ""
            
            var footerTitle:String?
            var footerInfo:String?
            var footerSubtitle:String?
            var isAvailable = true
            
            
            
            let cuponTitle:String = String.stringValue(from: object["cupom"])?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if cuponTitle != "" {
                footerTitle = "Seu cupom é:"
                footerInfo = cuponTitle
                if let date = Date.dateFrom(string: String.stringValue(from: object["dataExpiracao"]) ?? "", format: "yyyy-MM-dd HH:mm:ss") {
                    footerSubtitle = "Expira em: \(date.stringWith(format: "dd/MM/yyyy"))"
                }
                isAvailable = false
            }
            
            let fileUrlString:String? = String.stringValue(from: object["url"])?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if fileUrlString != "" && mode == .File {
                footerInfo = "BAIXAR ARQUIVO"
                isAvailable = false
            }

            var fileName:String = String.stringValue(from: object["file_name"]) ?? ""
            fileName = fileName.substringFrom(char: "/", at: .last, charIncluded: false)

            let fileSize:Int = Int.intValue(from: object["file_size"]) ?? 0
            
//            let mode:StoreItemDetails.Mode = .File
//            let fileName = "Testando.pdf"
//            let fileUrlString = "https://file-examples-com.github.io/uploads/2017/10/file-example_PDF_1MB.pdf"
//            let fileSize:Int = 3028
//            footerInfo = "BAIXAR ARQUIVO"
//            isAvailable = false
            
            let priceBlockDescription:String? = String.stringValue(from: object["tipoValor"])
            if (priceBlockDescription?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "") != "" {
                isAvailable = false
            }
            
            
            let details = StoreItemDetails(mode: mode, message: message, isDocumentAvailable: true, isAvailable: isAvailable, footerTitle: footerTitle, footerInfo: footerInfo, footerSubtitle: footerSubtitle, fileUrlString: fileUrlString, fileName: fileName, fileSize: fileSize)
            
            let coins:Int? = Int.intValue(from: object["valor"])
            let membershipCoins:Int? = Int.intValue(from: object["valorST"])
            let idCupom:Int? = Int.intValue(from: object["idCupom"])
            let isMembershipOnly:Bool = (coins == nil) && (membershipCoins != nil)
            
//            let itemTheme = PrizeTheme.themeFrom(string: String.stringValue(from: object["theme"])) ?? PrizeTheme.defaultTheme()
            
            let obj = StoreItem(id: id, cuponID: idCupom, title: String.stringValue(from: object["nome"]) ?? "", imageUrlString: String.stringValue(from: object["img"]), subtitle: String.stringValue(from: object["descricao"]), coins: coins, membershipCoins: membershipCoins, isMembershipOnly: isMembershipOnly, priceBlockDescription: priceBlockDescription)
            
            completion(details, obj)
            
            
            
        }
    }
    
    
    
    
    
    func setStoreItemRedeem(item:StoreItem, trackEvent:Int?, completion: @escaping (_ success:Bool?, _ cuponID:Int?, _ message:String?)->Void) {
        let info:[String:Any] = ["id":item.id]
        // API Method
        APIManager.shared.post(sufix: "setCompra", header: self.header(trackEvent: trackEvent, trackValue: item.id), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = Int.intValue(from: dict["Status"]) else {
                completion(false, nil, nil)
                return
            }
            guard status == 200, let object = dict["Object"] as? [String:Any] else {
                completion(false, nil, String.stringValue(from: dict["msg"]))
                return
            }
            let cuponID = Int.intValue(from: object["idCupom"])
            completion(true, cuponID, String.stringValue(from: dict["msg"]))
        }
    }
    
    
    
    
}

