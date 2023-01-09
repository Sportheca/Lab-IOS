//
//  SurveysContentView.swift
//  
//
//  Created by Roberto Oliveira on 12/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class SurveysContentView: UIView {
    
    // MARK: - Objects
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        let fontSize:CGFloat = UIScreen.main.bounds.height < 667 ? 17 : 24
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: fontSize)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        let fontSize:CGFloat = UIScreen.main.bounds.height < 667 ? 12 : 14
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: fontSize)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let optionsView:SurveysOptionsView = SurveysOptionsView()
    private let textAnswerView:SurveysTextAnswerView = SurveysTextAnswerView()
    
    
    // MARK: - Methods
    func updateContent(item:SurveyQuestion) {
        self.lblHeader.text = item.groupTitle
        self.lblTitle.text = item.title
        // options
        self.optionsView.updateContent(item: item)
        self.optionsView.isHidden = item.type != .Options
        // text
        self.textAnswerView.updateContent(item: item)
        self.textAnswerView.isHidden = item.type != .Text
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Header
        self.addSubview(self.lblHeader)
        self.addBoundsConstraintsTo(subView: self.lblHeader, leading: 10, trailing: -10, top: 0, bottom: nil)
        // Title
        self.addSubview(self.lblTitle)
        self.addVerticalSpacingTo(subView1: self.lblHeader, subView2: self.lblTitle, constant: 5)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 10, trailing: -10, top: nil, bottom: nil)
        // Options
        self.addSubview(self.optionsView)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.optionsView, constant: 10)
        self.addBoundsConstraintsTo(subView: self.optionsView, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Text Answer
        self.addSubview(self.textAnswerView)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.textAnswerView, constant: 10)
        self.addBoundsConstraintsTo(subView: self.textAnswerView, leading: 0, trailing: 0, top: nil, bottom: 0)
        
        if (UIScreen.main.bounds.height < 667) {
            self.lblHeader.addHeightConstraint(40)
            self.lblTitle.addHeightConstraint(50)
        } else {
            self.lblHeader.addHeightConstraint(50)
            self.lblTitle.addHeightConstraint(60)
        }
        
        self.lblTitle.textColor = Theme.color(.PrimaryCardElements)
        self.lblHeader.textColor = Theme.color(.PrimaryCardElements)
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











 
