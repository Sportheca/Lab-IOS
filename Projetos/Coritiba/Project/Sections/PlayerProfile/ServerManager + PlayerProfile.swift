//
//  ServerManager + PlayerProfile.swift
//  
//
//  Created by Roberto Oliveira on 20/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

class PlayerProfile {
    
    enum Category {
        case Default
        case GoalKeeper
    }
    
    var id:Int
    var title:String?
    var imageUrl:String?
    var shirtNumber:String?
    var isHighlighted:Bool = false
    var infos:[PlayerProfileInfo] = []
    var highlightedInfo:PlayerProfileInfo?
    var startDate:Date?
    var startDescription:String?
    var positionDescription:String?
    var chartInfos:[Int:RadarChartInfo] = [:]
    
    // infos
    var category:PlayerProfile.Category = .Default
    var goals:Int = 0
    var assists:Int = 0
    var averageGoalsPerMatch:Float = 0.0
    var redCards:Int = 0
    var yellowCards:Int = 0
    var matches:Int = 0
    var goalsAgainst:Int = 0
    var penaltiesSaved:Int = 0
    var iconsList:[PlayerProfileIconItem] = []
    
    init(id:Int) {
        self.id = id
    }
    
}

struct PlayerProfileInfo {
    var title:String
    var subtitle:String?
    var info:String
    var iconName:String?
}



extension ServerManager {
    
    func getPlayerProfileDetails(item:PlayerProfile, trackEvent:Int?, completion: @escaping (_ success:Bool)->Void) {
        APIManager.shared.get(sufix: "getPlayer?id=\(item.id)", header: self.header(trackEvent: trackEvent, trackValue: item.id), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(false)
                return
            }
            
            item.title = String.stringValue(from: object["nome"])
            item.imageUrl = String.stringValue(from: object["img"])
            
            item.positionDescription = String.stringValue(from: object["pos"])
            item.shirtNumber = Int.intValue(from: object["camisa"])?.description
            item.isHighlighted = Int.intValue(from: object["highlighted"]) == 1 || Int.intValue(from: object["criaBase"]) == 1
            
            let fullName = String.stringValue(from: object["nomeCompleto"])?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if fullName != "" {
                item.infos.append(PlayerProfileInfo(title: "Nome Completo", subtitle: nil, info: fullName, iconName: nil))
            }
            
            if let date = Date.dateFrom(string: String.stringValue(from: object["dataNascimento"]) ?? "", format: "yyyy-MM-dd") {
                var info:String = date.stringWith(format: "dd/MM/yyyy")
                let calendar = Calendar.current
                let date1 = calendar.startOfDay(for: date)
                let date2 = calendar.startOfDay(for: Date.now())
                let components = calendar.dateComponents([.year], from: date1, to: date2)
                if let years = components.year {
                    info += " (\(years) Anos)"
                }
                
                item.infos.append(PlayerProfileInfo(title: "Data de Nascimento", subtitle: nil, info: info, iconName: nil))
            }
            
            
            let previousClub = String.stringValue(from: object["clubeAnterior"])?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if previousClub != "" {
                item.infos.append(PlayerProfileInfo(title: "Clube Anterior", subtitle: nil, info: previousClub, iconName: nil))
            }
            
            
            let local = String.stringValue(from: object["local"])?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if local != "" {
                item.infos.append(PlayerProfileInfo(title: "Naturalidade", subtitle: nil, info: local, iconName: nil))
            }
            
            
            
            if let gols = Int.intValue(from: object["gols"]) {
                item.highlightedInfo = PlayerProfileInfo(title: "GOLS", subtitle: "MARCADOS PELO CLUBE", info: gols.descriptionWithThousandsSeparator(), iconName: "icon_goal")
            }
            
            
//            let startDateString = String.stringValue(from: object["estreia"]) ?? ""
//            item.startDate = Date.dateFrom(string: startDateString, format: "yyyy-MM-dd")
//            item.startDescription = String.stringValue(from: object["estreiaDesc"])
            item.startDescription = String.stringValue(from: object["estreia"])
            
            
            
            
            item.goals = Int.intValue(from: object["gols"]) ?? 0
            item.assists =  Int.intValue(from: object["assistencias"]) ?? 0
            item.redCards =  Int.intValue(from: object["cVermelhos"]) ?? 0
            item.yellowCards =  Int.intValue(from: object["cAmarelos"]) ?? 0
            item.matches =  Int.intValue(from: object["jogos"]) ?? 0
            item.averageGoalsPerMatch = (item.matches == 0) ? 0 : Float(item.goals) / Float(item.matches)
            
            item.goalsAgainst = Int.intValue(from: object["golsSofridos"]) ?? 0
            item.penaltiesSaved = Int.intValue(from: object["penaltisDefendidos"]) ?? 0
            
            
            var category:PlayerProfile.Category = .Default
            if item.positionDescription?.lowercased() == "goleiro" {
                category = .GoalKeeper
            }
            item.category = category
            
            // titulos
            var icons:[PlayerProfileIconItem] = []
            if let iconItems = object["titulos"] as? [[String:Any]] {
                for iconItem in iconItems {
                    guard let iconTitle = String.stringValue(from: iconItem["info"]) else {continue}
                    let iconImage = String.stringValue(from: iconItem["img"])
                    icons.append(PlayerProfileIconItem(title: iconTitle, iconUrlString: iconImage))
                }
            }
            item.iconsList = icons
            
//            completion(true)
            
            
            ServerManager.shared.getPlayerProfileChartInfo(item: item, infoID: 1, trackEvent: nil) { (_) in
                completion(true)
//                ServerManager.shared.getPlayerProfileChartInfo(item: item, infoID: 2, trackEvent: nil) { (_) in
//                    ServerManager.shared.getPlayerProfileChartInfo(item: item, infoID: 3, trackEvent: nil) { (_) in
//                        completion(true)
//                    }
//                }
            }
            
        }
    }
    
    
    
    
    func getPlayerProfileChartInfo(item:PlayerProfile, infoID:Int, trackEvent:Int?, completion: @escaping (_ success:Bool)->Void) {
        APIManager.shared.get(sufix: "getPlayerChartDataAtual?id=\(item.id)&t=\(infoID)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(false)
                return
            }
            
            if let items = object["itens"] as? [[String:Any]] {
                var infos:[RadarChartInfoItem] = []
                for item in items {
                    guard let title = String.stringValue(from: item["tit"]), let max = Float.floatValue(from: item["max"]), let value = Float.floatValue(from: item["v"]) else {continue}
                    let isPercentage = Int.intValue(from: item["p"]) == 1
                    
                    infos.append(RadarChartInfoItem(title: title, maxValue: max, value: value, isPercentage: isPercentage))
                }
                if infos.count >= 5 {
                    var lastItem = RadarChartInfoItem(title: "", maxValue: 0, value: 0, isPercentage: false)
                    if infos.count >= 6 {
                        lastItem = infos[5]
                    }
                    
                    item.chartInfos[infoID] = RadarChartInfo(
                        topLeft: infos[0],
                        topRight: infos[1],
                        centerRight: infos[2],
                        bottomRight: infos[3],
                        bottomLeft: infos[4],
                        centerLeft: lastItem
                    )
                }
            }
            
            completion(true)
        }
    }
    
}
