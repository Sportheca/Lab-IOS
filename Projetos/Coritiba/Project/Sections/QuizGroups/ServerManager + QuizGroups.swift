//
//  ServerManager + QuizGroups.swift
//  
//
//  Created by Roberto Oliveira on 07/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

class QuizGroup {
    var id:Int
    var title:String?
    var imageUrlString:String?
    var message:String?
    var correctAnswers:Int = 0
    var totalQuestions:Int?
    var answeredQuestions:Int?
    
    
    init(id:Int) {
        self.id = id
    }
}

extension ServerManager {
    
    func getQuizGroups(referenceId:Int?, page:Int, trackEvent:Int?, completion: @escaping (_ items:[QuizGroup]?, _ limit:Int?, _ margin:Int?)->Void) {
        var sufix:String = ""
        if let ref = referenceId {
            sufix = "id=\(ref)"
        } else {
            sufix = "page=\(page)"
        }
        APIManager.shared.get(sufix: "getQuizes?\(sufix)", header: self.header(trackEvent: trackEvent, trackValue: nil), sendInfo: nil) { (dictObj:[String : Any]?, serverError:ServerError?) in
            guard let dict = dictObj, let object = dict["Object"] as? [String:Any] else {
                completion(nil, nil, nil)
                return
            }
            
            var groups:[QuizGroup] = []
            if let items = object["itens"] as? [[String:Any]] {
                for item in items {
                    guard let id = Int.intValue(from: item["id"]) else {continue}
                    let group = QuizGroup(id: id)
                    group.title = String.stringValue(from: item["titulo"])
                    group.imageUrlString = String.stringValue(from: item["img"])
                    group.message = String.stringValue(from: item["descricao"])
                    
                    // quantity
                    let quantityString = String.stringValue(from: item["quantidade"]) ?? ""
                    let quantityComponents = quantityString.components(separatedBy: "/")
                    if quantityComponents.count > 0 {
                        group.answeredQuestions = Int.intValue(from: quantityComponents[0])
                    }
                    if quantityComponents.count > 1 {
                        group.totalQuestions = Int.intValue(from: quantityComponents[1])
                    }
                    
                    group.correctAnswers = Int.intValue(from: item["corretas"]) ?? 0
                    
                    groups.append(group)
                }
            }
            
            let limit = Int.intValue(from: object["limit"])
            let margin = Int.intValue(from: object["margin"])
            
            completion(groups, limit, margin)
        }
    }
    
}

