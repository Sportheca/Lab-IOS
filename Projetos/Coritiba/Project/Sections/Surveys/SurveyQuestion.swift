//
//  SurveyQuestion.swift
//  
//
//  Created by Roberto Oliveira on 12/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation

class SurveyQuestion {
    
    // MARK: - Enums
    enum QuestionType {
        case Options
        case Text
    }
    enum TextAnswerMode {
        case Disabled
        case Text
        case Integers
        case Decimals
    }
    
    
    // MARK: - Properties
    var type:SurveyQuestion.QuestionType
    var id:Int
    var score:Int?
    var groupTitle:String?
    var title:String?
    var backgroundImageUrl:String?
    var showAnswersPercentage:Bool = false
    var options:[SurveyAnswerOption] = []
    var textAnswerMode:SurveyQuestion.TextAnswerMode = .Disabled
    var isLastQuestion:Bool = false // If it is not last question, then shows "NEXT" and/or "SKIP" buttons
    var selectedOptionID:Int?
    var text:String?
    
    
    // MARK: - Methods
    func answerPercentageAt(index:Int, selectedId:Int) -> Float {
        var totalCount:Int = 0
        for option in self.options {
            totalCount += option.count
            if option.id == selectedId {
                totalCount += 1 // If it is just selected, increase one more
            }
        }
        
        var count = Float(self.options[index].count)
        if self.options[index].id == selectedId {
            count += 1
        }
        return (totalCount > 0) ? ((count/Float(totalCount))) : 0.0
    }
    
    func isAnswered() -> Bool {
        switch self.type {
        case .Options:
            return self.selectedOptionID != nil
        case .Text:
            let txt = self.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            return txt != ""
        }
    }
    
    
    // MARK: - Init
    init(type:SurveyQuestion.QuestionType, id:Int) {
        self.type = type
        self.id = id
    }
    
}




class SurveyAnswerOption {
    
    // MARK: - Properties
    var id:Int
    var title:String
    var count:Int = 0 // Count is used to show Research % of each option
    
    
    // MARK: - Init
    init(id:Int, title:String) {
        self.id = id
        self.title = title
    }
    
}
