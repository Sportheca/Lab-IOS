//
//  ServerManager + Surveys.swift
//  
//
//  Created by Roberto Oliveira on 12/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

extension ServerManager {
    
    func getSurveyQuestion(requiredID:Int?, trackEvent:Int?, trackValue:Int?, completion: @escaping (_ item:SurveyQuestion?, _ message:String?)->Void) {
        var sufix:String = ""
        if let id = requiredID {
            sufix = "?idPergunta=\(id)"
        }
        APIManager.shared.get(sufix: "getPesquisa\(sufix)", header: self.header(trackEvent: trackEvent, trackValue: trackValue), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil, String.stringValue(from: dictObj?["msg"]))
                return
            }
            guard let id = Int.intValue(from: object["id"]), let title = String.stringValue(from: object["pergunta"]) else {
                completion(nil, String.stringValue(from: dict["msg"]))
                return
            }
            
            var answersArray:[SurveyAnswerOption] = []
            
            if let answers = object["respostas"] as? [[String:Any]] {
                for answer in answers {
                    guard let id = Int.intValue(from: answer["id"]), let title = String.stringValue(from: answer["resposta"]) else {continue}
                    let item = SurveyAnswerOption(id: id, title: title)
                    item.count = Int.intValue(from: answer["qtd"]) ?? 0
                    answersArray.append(item)
                }
            }
            
            var questionType:SurveyQuestion.QuestionType = .Options
            if Int.intValue(from: object["respAberta"]) == 1 {
                questionType = .Text
            }
            
            let item = SurveyQuestion(type: questionType, id: id)
            item.title = title
            item.isLastQuestion = Int.intValue(from: object["btnNovoDesafio"]) != 1
            if requiredID != nil {
                item.isLastQuestion = false
            }
            
            item.groupTitle = String.stringValue(from: object["grupo"])
            
            item.backgroundImageUrl = String.stringValue(from: object["img"])
            item.score = Int.intValue(from: object["moedas"])
            item.options = answersArray
            item.showAnswersPercentage = Int.intValue(from: object["showResults"]) == 1
            
            completion(item, String.stringValue(from: dict["msg"]))
        }
    }
    
    func setSurveyQuestion(item:SurveyQuestion, trackEvent:Int?, trackValue:Int?, completion: @escaping (_ success:Bool?)->Void) {
//        if DebugManager.shared.isColorDebugEnabled {
//            return
//        }
        
        // Create Data Dictionary
        var info:[String:Any] = ["idPergunta":item.id]
        if let choiceId = item.selectedOptionID {
            info["idResposta"] = choiceId
        }
        let txt = item.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if txt != "" {
            info["aberta"] = txt
        }
        
        // API Method
        APIManager.shared.post(sufix: "setPesquisa", header: self.header(trackEvent: trackEvent, trackValue: trackValue), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            completion(true)
        }
    }
    
}
