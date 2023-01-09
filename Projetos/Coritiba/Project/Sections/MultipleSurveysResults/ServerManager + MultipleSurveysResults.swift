//
//  ServerManager + MultipleSurveysResults.swift
//  
//
//  Created by Roberto Oliveira on 3/17/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

struct MultipleSurveysResultsGroup {
    var id:Int
    var title:String
    var subtitle:String
    var correctAnswers:Int
    var coins:Int
    var club0:MultipleSurveysResultsGroupClub
    var club1:MultipleSurveysResultsGroupClub
}

struct MultipleSurveysResultsGroupClub {
    var title:String
    var imageUrl:String?
    var goals:Int
    var penaltyGoals:Int?
}


struct MultipleSurveysResultsGroupAnswerItem {
    var title:String
    var correct:Bool
    var userAnswer:String
    var correctAnswer:String?
    var coins:Int
}

extension ServerManager {
    
    func getMultipleSurveysResultsGroups(page:Int, trackEvent:Int?, completion: @escaping (_ objects:[MultipleSurveysResultsGroup]?, _ limit:Int?, _ margin:Int?)->Void) {
        APIManager.shared.get(sufix: "getPalpitesRespondidos?page=\(page)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil, nil, nil)
                return
            }
            var groups:[MultipleSurveysResultsGroup] = []
            
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let id = Int.intValue(from: obj["id"]) else {continue}
                    let title:String = String.stringValue(from: obj["campeonato"]) ?? ""
                    let subtitle:String = String.stringValue(from: obj["rodada"]) ?? ""
                    let correctAnswers:Int = Int.intValue(from: obj["acertos"]) ?? 0
                    let coins:Int = Int.intValue(from: obj["moedas"]) ?? 0
                    
                    let club0Title:String = String.stringValue(from: obj["time1"]) ?? ""
                    let club0ImageUrl:String? = String.stringValue(from: obj["time1img"])
                    let club0Goals:Int = Int.intValue(from: obj["golsClube1"]) ?? 0
                    let club0PealtiesGoals:Int? = Int.intValue(from: obj["penC1"])
                    let club0 = MultipleSurveysResultsGroupClub(title: club0Title, imageUrl: club0ImageUrl, goals: club0Goals, penaltyGoals: club0PealtiesGoals)
                    
                    let club1Title:String = String.stringValue(from: obj["time2"]) ?? ""
                    let club1ImageUrl:String? = String.stringValue(from: obj["time2img"])
                    let club1Goals:Int = Int.intValue(from: obj["golsClube2"]) ?? 0
                    let club1PealtiesGoals:Int? = Int.intValue(from: obj["penC2"])
                    let club1 = MultipleSurveysResultsGroupClub(title: club1Title, imageUrl: club1ImageUrl, goals: club1Goals, penaltyGoals: club1PealtiesGoals)
                    
                    let group = MultipleSurveysResultsGroup(id: id, title: title, subtitle: subtitle, correctAnswers: correctAnswers, coins: coins, club0: club0, club1: club1)
                    groups.append(group)
                }
            }
            
            let limit = Int.intValue(from: object["limit"])
            let margin = Int.intValue(from: object["margin"])
            
            completion(groups, limit, margin)
        }
    }
    
    
    
    
    
    func getMultipleSurveysResultsGroup(id:Int, trackEvent:Int?, completion: @escaping (_ objects:[MultipleSurveysResultsGroupAnswerItem]?)->Void) {
        APIManager.shared.get(sufix: "getPalpiteResults?id=\(id)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil)
                return
            }
            var items:[MultipleSurveysResultsGroupAnswerItem] = []
            
            if let objects = object["itens"] as? [[String:Any]] {
                for obj in objects {
                    guard let title:String = String.stringValue(from: obj["pergunta"]) else {continue}
                    let correct:Bool = Int.intValue(from: obj["certo"]) == 1
                    let coins:Int = Int.intValue(from: obj["moedas"]) ?? 0
                    
                    
                    var userAnswer:String = ""
                    if let u1:String = String.stringValue(from: obj["respostaUser1"]) {
                        userAnswer = u1
                        if let u2:String = String.stringValue(from: obj["respostaUser2"]) {
                            userAnswer = "\(u1) x \(u2)"
                        }
                    }
                    
                    var correctAnswer:String?
                    if let c1:String = String.stringValue(from: obj["respostaCorreta1"]) {
                        correctAnswer = c1
                        if let c2:String = String.stringValue(from: obj["respostaCorreta2"]) {
                            correctAnswer = "\(c1) x \(c2)"
                        }
                    }
                    
                    let item = MultipleSurveysResultsGroupAnswerItem(title: title, correct: correct, userAnswer: userAnswer, correctAnswer: correctAnswer, coins: coins)
                    items.append(item)
                }
            }
            
            completion(items)
        }
    }
    
}
