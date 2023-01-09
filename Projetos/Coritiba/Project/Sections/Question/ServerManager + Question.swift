//
//  ServerManager + Question.swift
//
//
//  Created by Roberto Oliveira on 16/07/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import Foundation

extension ServerManager {
    
    func getQuestion(type:Question.QuestionType, referenceID:Int?, trackEvent:Int?, trackValue:Int?, completion: @escaping (_ item:Question?, _ message:String?)->Void) {
        switch type {
        case .Quiz:
            ServerManager.shared.getQuizQuestion(referenceID: referenceID, trackEvent: trackEvent, trackValue: trackValue, completion: completion)
        case .Research:
            ServerManager.shared.getResearchQuestion(trackEvent: trackEvent, trackValue: trackValue, completion: completion)
        }
    }
    
    func setQuestion(type:Question.QuestionType, id:Int, choice:Int?, trackEvent:Int, secondsToAnswer:TimeInterval?, timeOut:Bool) {
        switch type {
        case .Quiz:
            ServerManager.shared.setQuizQuestion(id: id, choice: choice, secondsToAnswer: secondsToAnswer, timeOut: timeOut, trackEvent: trackEvent)
        case .Research:
            ServerManager.shared.setResearchQuestion(id: id, choice: choice, trackEvent: trackEvent)
        }
    }
    
    
    
    
    
    
    
    // Research
    func getResearchQuestion(trackEvent:Int?, trackValue:Int?, completion: @escaping (_ item:Question?, _ message:String?)->Void) {
        APIManager.shared.get(sufix: "getPesquisa", header: self.header(trackEvent: trackEvent, trackValue: trackValue), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = dict["Status"] as? Int else {
                completion(nil, nil)
                return
            }
            if status == 200 {
                guard let object = dict["Object"] as? [String:Any] else {
                    completion(nil, nil)
                    return
                }
                guard let id = object["idQuestion"] as? Int, let title = object["question"] as? String, let answers = object["respostas"] as? [[String:Any]] else {
                    completion(nil, nil)
                    return
                }
                let hasNext = ((object["bnd"] as? Bool) ?? false)
                let score = (object["score"] as? Int) ?? 1
                
                var answersArray:[QuestionAnswerOption] = []
                for answer in answers {
                    guard let id = answer["id"] as? Int, let title = answer["answer"] as? String else {continue}
                    let item = QuestionAnswerOption(id: id, title: title)
                    item.count = (answer["qtd"] as? Int) ?? 0
                    answersArray.append(item)
                }
                
                let item = Question(type: .Research, id: id)
                item.isLastQuestion = !hasNext
                item.title = title
                item.positiveScore = score
                item.options = answersArray
                completion(item, nil)
            } else if status == 400 {
                completion(nil, dict["Message"] as? String)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func setResearchQuestion(id:Int, choice:Int?, trackEvent:Int?) {
        // Create Data Dictionary
        var info:[String:Any] = ["questionId":id]
        if let choiceId = choice {
            info["choiceId"] = choiceId
        } else {
            info["choiceId"] = "null"
        }
        
        // API Method
        APIManager.shared.post(sufix: "respondePesquisa", header: self.header(trackEvent: trackEvent, trackValue: id), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            //
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Quiz
    func getQuizQuestion(referenceID:Int?, trackEvent:Int?, trackValue:Int?, completion: @escaping (_ item:Question?, _ message:String?)->Void) {
        var sufix = ""
        if let ref = referenceID {
            sufix = "id=\(ref.description)"
        }
        APIManager.shared.get(sufix: "getQuiz?\(sufix)", header: self.header(trackEvent: trackEvent, trackValue: trackValue), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let status = Int.intValue(from: dict["Status"]) else {
                completion(nil, nil)
                return
            }
            if status == 200 {
                guard let object = dict["Object"] as? [String:Any] else {
                    completion(nil, nil)
                    return
                }
                guard let id = Int.intValue(from: object["id"]), let title = String.stringValue(from: object["pergunta"]), let answers = object["respostas"] as? [[String:Any]] else {
                    completion(nil, nil)
                    return
                }
                let hasNext = Int.intValue(from: object["bnd"]) == 1
                let positiveScore = Int.intValue(from: object["moedasVitoria"])
                let negativeScore = Int.intValue(from: object["moedasDerrota"])
                let timeOutScore = Int.intValue(from: object["moedasTimeout"])
                let time:Int = Int((object["tempo"] as? Double) ?? 15)
                var correctId:Int?
                
                var answersArray:[QuestionAnswerOption] = []
                for answer in answers {
                    guard let answerId = Int.intValue(from: answer["id"]), let answerTitle = String.stringValue(from: answer["resposta"]) else {continue}
                    if (Int.intValue(from: answer["correto"]) == 1) {
                        correctId = answerId
                    }
                    answersArray.append(QuestionAnswerOption(id: answerId, title: answerTitle))
                }
                guard let correct = correctId else {
                    completion(nil, nil)
                    return
                }
                
                let item = Question(type: .Quiz, id: id)
                item.correctOptionId = correct
                item.time = time
                item.isLastQuestion = !hasNext
                item.title = title
                item.positiveScore = positiveScore
                item.negativeScore = negativeScore
                item.timeOutScore = timeOutScore
                item.options = answersArray
                
                item.options.shuffle()
                
                completion(item, nil)
            } else {
                completion(nil, String.stringValue(from: dict["msg"]))
            }
        }
    }
    
    func setQuizQuestion(id:Int, choice:Int?, secondsToAnswer:TimeInterval?, timeOut:Bool, trackEvent:Int?) {
//        if DebugManager.shared.isColorDebugEnabled {
//            return
//        }
        // Create Data Dictionary
        var info:[String:Any] = ["idPergunta":id]
        if let choiceId = choice {
            info["idResposta"] = choiceId
        }
        if let seconds = secondsToAnswer {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ""
            formatter.decimalSeparator = "."
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            info["tempo"] = formatter.string(for: seconds) ?? seconds.description
        }
        if timeOut {
            info["timeout"] = 1
        }
        // API Method
        APIManager.shared.post(sufix: "setQuiz", header: self.header(trackEvent: trackEvent, trackValue: id), postInfo: info) { (dictObj:[String : Any]?, serverError:ServerError?) in
            //
        }
    }
    
}
