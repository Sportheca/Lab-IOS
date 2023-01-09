//
//  MultipleSurveysQuestionView.swift
//  
//
//  Created by Roberto Oliveira on 06/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MultipleSurveysQuestionView: UIView {
    
    // MARK: - Objects
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 4
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 14)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let finalScoreView:MultipleSurveysFinalScoreAnswerView = MultipleSurveysFinalScoreAnswerView()
    private let radioButtonView:MultipleSurveysRadioButtonAnswerView = MultipleSurveysRadioButtonAnswerView()
    let listSelectorView:MultipleSurveysListSelectorAnswerView = MultipleSurveysListSelectorAnswerView()
    
    
    // MARK: - Methods
    func updateContent(item:MultipleSurveyQuestion, group:MultipleSurveysGroup) {
        self.isUserInteractionEnabled = !group.isCompleted
        self.lblHeader.text = item.title
        
        switch item.mode {
        case .FinalScore:
            self.finalScoreView.updateContent(item: item, group: group)
            self.finalScoreView.isHidden = false
            self.radioButtonView.isHidden = true
            self.listSelectorView.isHidden = true
            return
        case .RadioButton:
            self.radioButtonView.updateContent(item: item)
            self.radioButtonView.isHidden = false
            self.finalScoreView.isHidden = true
            self.listSelectorView.isHidden = true
            return
        case .ListSelector:
            self.listSelectorView.updateContent(item: item)
            self.listSelectorView.isHidden = false
            self.finalScoreView.isHidden = true
            self.radioButtonView.isHidden = true
            return
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // header
        self.addSubview(self.lblHeader)
        self.addBoundsConstraintsTo(subView: self.lblHeader, leading: 10, trailing: -10, top: 10, bottom: nil)
        self.lblHeader.addHeightConstraint(60)
        // final score
        self.addAnswerView(self.finalScoreView)
        // Radio
        self.addAnswerView(self.radioButtonView)
        // List Selector
        self.addAnswerView(self.listSelectorView)
        
        
        self.lblHeader.textColor = Theme.color(.PrimaryCardElements)
    }
    
    private func addAnswerView(_ vw:UIView) {
        self.addSubview(vw)
        self.addVerticalSpacingTo(subView1: self.lblHeader, subView2: vw, constant: 0)
        self.addBoundsConstraintsTo(subView: vw, leading: 0, trailing: 0, top: nil, bottom: 0)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}
