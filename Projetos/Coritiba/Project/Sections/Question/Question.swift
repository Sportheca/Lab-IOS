//
//  Question.swift
//
//
//  Created by Roberto Oliveira on 13/07/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class Question {
    
    // MARK: - Enums
    enum QuestionType {
        case Quiz
        case Research
    }
    enum TextAnswerMode {
        case Disabled
        case Text
        case Integers
        case Decimals
    }
    
    
    // MARK: - Properties
    var type:QuestionType
    var id:Int
    var positiveScore:Int?
    var negativeScore:Int?
    var timeOutScore:Int?
    var time:Int?
    var title:String?
    var correctOptionId:Int? // Used by Quiz
    var images:[UIImage] = []
    var options:[QuestionAnswerOption] = []
    var textAnswerMode:TextAnswerMode = .Disabled
    var isLastQuestion:Bool = false // If it is not last question, then shows "NEXT" and/or "SKIP" buttons
    
    
    
    
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
        return (totalCount > 0) ? ((count/Float(totalCount))*100) : 0.0
    }
    
    
    // MARK: - Init
    init(type:QuestionType, id:Int) {
        self.type = type
        self.id = id
    }
    
}







class QuestionAnswerOption {
    
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










