//
//  ServerManager + Ranking.swift
//  
//
//  Created by Roberto Oliveira on 13/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

struct RankingItem {
    var id:String
    var title:String
    var subtitle:String?
    var imageUrlString:String?
    var rankPosition:Int
    var score:Int
}

struct RankingGroup {
    var id:Int
    var title:String
    var helpMessage:String?
}

extension ServerManager {
    
    func getRankingGroups(trackEvent:Int?, completion: @escaping (_ items:[RankingGroup]?)->Void) {
        APIManager.shared.get(sufix: "getRankingsGrupos", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }

            var groups:[RankingGroup] = []
            if let items = object["itens"] as? [[String:Any]] {
                for item in items {
                    guard let id = Int.intValue(from: item["id"]), let title = String.stringValue(from: item["nome"]) else {continue}
                    let helpMessage:String? = String.stringValue(from: item["info"])
                    groups.append(RankingGroup(id: id, title: title, helpMessage: helpMessage))
                }
            }
            completion(groups)
        }
    }
    
    
    
    func getRanking(id:Int, page:Int, trackEvent:Int?, completion: @escaping (_ items:[RankingItem]?, _ userItem:RankingItem?, _ limit:Int?, _ margin:Int?)->Void) {
            APIManager.shared.get(sufix: "getRanking?id=\(id)&page=\(page)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
                guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                    completion(nil, nil, nil, nil)
                    return
                }
    
                var rankingItems:[RankingItem] = []
                if let items = object["itens"] as? [[String:Any]] {
                    for item in items {
                        guard let itemID = String.stringValue(from: item["id"]), let itemTitle = String.stringValue(from: item["nome"]) else {continue}
                        let itemSubtitle = String.stringValue(from: item["subtitle"]) ?? ""
                        let itemImage = String.stringValue(from: item["img"])
                        let itemScore = Int.intValue(from: item["score"]) ?? 0
                        let itemRank = Int.intValue(from: item["rank"]) ?? 0
                        rankingItems.append(RankingItem(id: itemID, title: itemTitle, subtitle: itemSubtitle, imageUrlString: itemImage, rankPosition: itemRank, score: itemScore))
                    }
                }
                
                
                var userItem:RankingItem?
                if let userInfo = object["user"] as? [String:Any] {
                    if let userInfoID = String.stringValue(from: userInfo["id"]) {
                        let userInfoTitle = String.stringValue(from: userInfo["nome"]) ?? ""
                        let defaultSubtitle = ServerManager.shared.user?.membershipTitle() ?? ""
                        let userInfoSubtitle = String.stringValue(from: userInfo["subtitle"]) ?? defaultSubtitle
                        let userInfoImage = String.stringValue(from: userInfo["img"])
                        let userInfoScore = Int.intValue(from: userInfo["score"]) ?? 0
                        let userInfoRank = Int.intValue(from: userInfo["rank"]) ?? 0
                        
                        userItem = RankingItem(id: userInfoID, title: userInfoTitle, subtitle: userInfoSubtitle, imageUrlString: userInfoImage, rankPosition: userInfoRank, score: userInfoScore)
                    }
                }
                
                
                let limit:Int? = Int.intValue(from: object["limit"])
                let margin:Int? = Int.intValue(from: object["margin"])
                
                completion(rankingItems, userItem, limit, margin)
            }
        }
    
}

