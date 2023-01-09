//
//  ServerManager + MatchDetails.swift
//  
//
//  Created by Roberto Oliveira on 3/16/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

struct MatchDetails {
    var id:Int
    var title:String
    var subtitle:String
    var club0:MatchDetailsClub
    var club1:MatchDetailsClub
    var infos:[MatchDetailsInfo]
    
}

struct MatchDetailsClub {
    var title:String
    var imageUrl:String?
    var score:Int
    var penaltiesScore:Int?
    var goalsInfos:[String]
}

struct MatchDetailsInfo {
    var title:String
    var value0:String
    var value1:String
}

extension ServerManager {
    
    func getMatchDetails(id:Int, trackEvent:Int?, completion: @escaping (_ item:MatchDetails?)->Void) {
        APIManager.shared.get(sufix: "getJogoDetalhes?id=\(id)", header: self.header(trackEvent: trackEvent, trackValue: id), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            
            var club0Infos:[String] = []
            var club1Infos:[String] = []
            
            if let listGols = object["listGols"] as? [String:Any] {
                club0Infos = listGols["t1"] as? [String] ?? []
                club1Infos = listGols["t2"] as? [String] ?? []
            }
            
            let club0Title:String = String.stringValue(from: object["clube1"]) ?? ""
            let club0ImageUrl:String? = String.stringValue(from: object["clubeImg1"])
            let club0Score:Int = Int.intValue(from: object["gols1"]) ?? 0
            let club0PenaltiesScore:Int? = Int.intValue(from: object["penC1"])
            let club0 = MatchDetailsClub(title: club0Title, imageUrl: club0ImageUrl, score: club0Score, penaltiesScore: club0PenaltiesScore, goalsInfos: club0Infos)
            
            
            let club1Title:String = String.stringValue(from: object["clube2"]) ?? ""
            let club1ImageUrl:String? = String.stringValue(from: object["clubeImg2"])
            let club1Score:Int = Int.intValue(from: object["gols2"]) ?? 0
            let club1PenaltiesScore:Int? = Int.intValue(from: object["penC2"])
            let club1 = MatchDetailsClub(title: club1Title, imageUrl: club1ImageUrl, score: club1Score, penaltiesScore: club1PenaltiesScore, goalsInfos: club1Infos)
            
            
            let title = String.stringValue(from: object["title"]) ?? ""
            let subtitle = String.stringValue(from: object["subtit"]) ?? ""
            
            
            var infos:[MatchDetailsInfo] = []
            if let statsInfos = object["stats"] as? [[String:Any]] {
                for statsInfo in statsInfos {
                    guard let statsInfosTitle = String.stringValue(from: statsInfo["tipo"]), let v0 = String.stringValue(from: statsInfo["v1"]), let v1 = String.stringValue(from: statsInfo["v2"]) else {continue}
                    infos.append(MatchDetailsInfo(title: statsInfosTitle, value0: v0, value1: v1))
                }
            }
            
            
            let item = MatchDetails(id: id, title: title, subtitle: subtitle, club0: club0, club1: club1, infos: infos)
            
            completion(item)
        }
    }
    
}
