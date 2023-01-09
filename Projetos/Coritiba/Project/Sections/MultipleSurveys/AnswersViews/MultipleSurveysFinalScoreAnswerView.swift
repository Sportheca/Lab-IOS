//
//  MultipleSurveysFinalScoreAnswerView.swift
//  
//
//  Created by Roberto Oliveira on 06/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MultipleSurveysFinalScoreAnswerView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    private var currentQuestion:MultipleSurveyQuestion?
    
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .top
        vw.distribution = .fillEqually
        vw.spacing = 40.0
        return vw
    }()
    private let lblX:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 24)
        lbl.text = "x"
        return lbl
    }()
    private lazy var item0:MultipleSurveysFinalScoreAnswerItemView = {
        let vw = MultipleSurveysFinalScoreAnswerItemView()
        vw.txfQuantity.delegate = self
        return vw
    }()
    private lazy var item1:MultipleSurveysFinalScoreAnswerItemView = {
        let vw = MultipleSurveysFinalScoreAnswerItemView()
        vw.txfQuantity.delegate = self
        return vw
    }()
    
    
    
    
    // MARK: - Methods
    func updateContent(item:MultipleSurveyQuestion, group:MultipleSurveysGroup) {
        self.currentQuestion = item
        // item 0
        self.item0.updateContent(title: group.club0?.title ?? "", imageUrl: group.club0?.imageUrlString)
        self.item0.txfQuantity.text = item.selectedScore0?.description
        // item 1
        self.item1.updateContent(title: group.club1?.title ?? "", imageUrl: group.club1?.imageUrlString)
        self.item1.txfQuantity.text = item.selectedScore1?.description
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var score:Int?
        let txt = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if txt != "" {
            score = Int.intValue(from: txt)
        }
        if textField == self.item0.txfQuantity {
            self.currentQuestion?.selectedScore0 = score
        } else {
            self.currentQuestion?.selectedScore1 = score
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(MultipleSurveysViewController.answerNotificationName), object: nil)
    }
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.stackView)
        self.addTopAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.addCenterXAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.stackView.addArrangedSubview(self.item0)
        self.stackView.addArrangedSubview(self.item1)
        self.insertSubview(self.lblX, belowSubview: self.stackView)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.lblX, reference: self.item0.containerView, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.item0.containerView, subView2: self.lblX, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.lblX, subView2: self.item1.containerView, constant: 0)
        
        self.item0.lblTitle.textColor = Theme.color(.PrimaryCardElements)
        self.item1.lblTitle.textColor = Theme.color(.PrimaryCardElements)
        self.lblX.textColor = Theme.color(.PrimaryCardElements)
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




class MultipleSurveysFinalScoreAnswerItemView: UIView {
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 6.0
        return vw
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 14)
        return lbl
    }()
    let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.SurveyOptionBackground)
        vw.layer.cornerRadius = 15.0
        vw.clipsToBounds = true
        return vw
    }()
    var txfQuantity:CustomTextField = {
        let txf = CustomTextField()
        txf.textAlignment = .center
        txf.textColor = Theme.color(.SurveyOptionText)
        txf.placeholderColor = Theme.color(.SurveyOptionText).withAlphaComponent(0.7)
        txf.placeholder = "00"
        txf.keyboardType = .numberPad
        return txf
    }()
    
    
    // MARK: - Methods
    func updateContent(title:String, imageUrl:String?) {
        self.lblTitle.text = title
        self.ivCover.setServerImage(urlString: imageUrl)
    }
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.stackView)
        self.addFullBoundsConstraintsTo(subView: self.stackView, constant: 0)
        self.stackView.addArrangedSubview(self.ivCover)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.containerView)
        self.containerView.addWidthConstraint(72)
        self.containerView.addSubview(self.txfQuantity)
        self.containerView.addFullBoundsConstraintsTo(subView: self.txfQuantity, constant: 5)
        self.txfQuantity.addDefaultAccessory()
        
        if (UIScreen.main.bounds.height < 667) {
            self.ivCover.addHeightConstraint(30)
            self.ivCover.addWidthConstraint(30)
            self.txfQuantity.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 18)
            self.containerView.addHeightConstraint(40)
        } else {
            self.ivCover.addHeightConstraint(44)
            self.ivCover.addWidthConstraint(44)
            self.txfQuantity.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 38)
            self.containerView.addHeightConstraint(67)
        }
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
