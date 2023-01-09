//
//  ServerManager + MultipleSurveys.swift
//  
//
//  Created by Roberto Oliveira on 06/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

enum MultipleSurveyQuestionMode:Int {
    case FinalScore = 1
    case RadioButton = 2
    case ListSelector = 3
}

class MultipleSurveyQuestion {
    var id:Int
    var mode:MultipleSurveyQuestionMode
    var title:String
    var options:[BasicInfo] = []
    
    // optional answers
    var selectedOptionID:Int?
    var selectedScore0:Int?
    var selectedScore1:Int?
    var selectedListItem:SquadSelectorListItem?
    
    
    func isAswered() -> Bool {
        switch self.mode {
        case .FinalScore:
            return self.selectedScore0 != nil && self.selectedScore1 != nil
        case .RadioButton:
            return self.selectedOptionID != nil
        case .ListSelector:
            return self.selectedListItem != nil
        }
    }
    
    init (id:Int, mode:MultipleSurveyQuestionMode, title:String) {
        self.id = id
        self.mode = mode
        self.title = title
    }
}



struct MultipleSurveysClub {
    var id:Int
    var title:String
    var imageUrlString:String?
}

class MultipleSurveysGroup {
    var id:Int
    var title:String?
    var questions:[MultipleSurveyQuestion] = []
    var isCompleted:Bool = false
    
    var subtitle:String?
    var message:String?
    var endAtDate:Date?
    var backgroundImageUrl:String?
    
    var club0:MultipleSurveysClub?
    var club1:MultipleSurveysClub?
    
    var hasPreviousResultsAvailable:Bool = false
    
    func isFinishAllowed() -> Bool {
        var flag:Bool = true
        for question in self.questions {
            if !question.isAswered() {
                flag = false
            }
        }
        return flag
    }
    
    init(id:Int) {
        self.id = id
    }
}



extension ServerManager {
    
    func getMultipleSurveysGroup(trackEvent:Int?, completion: @escaping (_ item:MultipleSurveysGroup?, _ hasPreviousResultsAvailable:Bool?)->Void) {
        let header = self.header(trackEvent: trackEvent, trackValue: nil)
        APIManager.shared.get(sufix: "getPalpiteAtual", header: header, sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil, nil)
                return
            }
            let hasPreviousResultsAvailable = Int.intValue(from: object["more"]) == 1
            guard let id = Int.intValue(from: object["id"]) else {
                completion(nil, hasPreviousResultsAvailable)
                return
            }
            
            
            let item = MultipleSurveysGroup(id: id)
            item.backgroundImageUrl = String.stringValue(from: object["img"])
            var message = ""
            if let coins = Int.intValue(from: object["coins"]) {
                let coinTitle = coins == 1 ? "moeda" : "moedas"
                message = "Dê seus palpites sobre o jogo! Você pode ganhar até \(coins.descriptionWithThousandsSeparator()) \(coinTitle) se acertar todas as perguntas."
            }
            item.message = message
            item.title = String.stringValue(from: object["campeonato"])
            
            var subtitle:String = ""
            if let value = String.stringValue(from: object["rodada"]) {
                subtitle = value
            }
            if let value = Date.dateFrom(string: String.stringValue(from: object["dataHoraJogo"]) ?? "", format: "yyyy-MM-dd HH:mm:ss") {
                if subtitle != "" {
                    subtitle += " - "
                }
                subtitle += value.stringWith(format: "dd/MM")
            }
            item.subtitle = subtitle
            
            item.endAtDate = Date.dateFrom(string: String.stringValue(from: object["expire"]) ?? "", format: "yyyy-MM-dd HH:mm:ss")
            
            
            
            item.club0 = MultipleSurveysClub(id: 0, title: String.stringValue(from: object["clube1"]) ?? "", imageUrlString: String.stringValue(from: object["imgClube1"]))
            item.club1 = MultipleSurveysClub(id: 0, title: String.stringValue(from: object["clube2"]) ?? "", imageUrlString: String.stringValue(from: object["imgClube2"]))
            
            var isCompleted:Bool = false
            var questions:[MultipleSurveyQuestion] = []
            if let objects = object["perguntas"] as? [[String:Any]] {
                for obj in objects {
                    guard let objID = Int.intValue(from: obj["id"]), let objType = MultipleSurveyQuestionMode(rawValue: Int.intValue(from: obj["tipo"]) ?? 0) else {continue}
                    let objTitle = String.stringValue(from: obj["pergunta"]) ?? ""
                    let question = MultipleSurveyQuestion(id: objID, mode: objType, title: objTitle)
                    if objType == .RadioButton {
                        question.options = [BasicInfo(id: 1, title: "SIM"), BasicInfo(id: 0, title: "NÃO")]
                    }
                    
                    switch question.mode {
                    case .FinalScore:
                        if let v1 = Int.intValue(from: obj["v1"]), let v2 = Int.intValue(from: obj["v2"]) {
                            isCompleted = true
                            question.selectedScore0 = v1
                            question.selectedScore1 = v2
                        }
                        break
                    case .RadioButton:
                        if let v1 = Int.intValue(from: obj["v1"]) {
                            isCompleted = true
                            question.selectedOptionID = v1
                        }
                        break
                    case .ListSelector:
                        if let v1 = Int.intValue(from: obj["v1"]), let v2 = String.stringValue(from: obj["v2"]) {
                            isCompleted = true
                            question.selectedListItem = SquadSelectorListItem(id: v1, title: v2, subtitle: "", shirtNumber: "")
                        }
                        break
                    }
                    
                    questions.append(question)
                }
            }
            
            item.questions = questions
            item.isCompleted = isCompleted
            
            item.hasPreviousResultsAvailable = hasPreviousResultsAvailable
            
            completion(item, hasPreviousResultsAvailable)
        }
    }
    
    
    
    
    func setMultipleSurveysGroup(item:MultipleSurveysGroup, trackEvent:Int?, completion: @escaping (_ success:Bool?, _ message:String?)->Void) {
        var answerString = ""
        for question in item.questions {
            switch question.mode {
            case .FinalScore:
                if let v1 = question.selectedScore0, let v2 = question.selectedScore1 {
                    answerString += "\(question.id):\(v1)/\(v2);"
                }
                break
            case .RadioButton:
                if let v1 = question.selectedOptionID {
                    answerString += "\(question.id):\(v1);"
                }
                break
            case .ListSelector:
                if let v1 = question.selectedListItem?.id {
                    answerString += "\(question.id):\(v1);"
                }
                break
            }
        }
        let info:[String:Any] = ["idPalpite":item.id, "palpites":answerString]
        // API Method
        APIManager.shared.post(sufix: "setPalpite", header: self.header(trackEvent: trackEvent, trackValue: item.id), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = Int.intValue(from: dict["Status"]) else {
                completion(false, nil)
                return
            }
            if status == 200 {
                item.isCompleted = true
                completion(true, nil)
            } else {
                completion(false, String.stringValue(from: dict["msg"]))
            }
        }
    }
    
    
}
