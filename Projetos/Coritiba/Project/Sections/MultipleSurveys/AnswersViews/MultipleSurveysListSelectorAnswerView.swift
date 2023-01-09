//
//  MultipleSurveysListSelectorAnswerView.swift
//  
//
//  Created by Roberto Oliveira on 06/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MultipleSurveysListSelectorAnswerView: UIView {
    
    // MARK: - Objects
    private lazy var btnAction:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = Theme.color(.SurveyOptionBackground)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15.0
        btn.highlightedAlpha = 0.5
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.actionMethod), for: .touchUpInside)
        return btn
    }()
    private let ivArrow:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon_arrow_right")?.withRenderingMode(.alwaysTemplate)
        iv.isUserInteractionEnabled = false
        iv.tintColor = Theme.color(.SurveyOptionText)
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.isUserInteractionEnabled = false
        return lbl
    }()
    
    
    
    // MARK: - Methods
    func updateContent(item:MultipleSurveyQuestion) {
        let attributed = NSMutableAttributedString()
        if let info = item.selectedListItem {
            attributed.append(NSAttributedString(string: info.title, attributes: [
                NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Black, size: 13),
                NSAttributedString.Key.foregroundColor : Theme.color(.SurveyOptionText),
            ]))
            let subtitle = info.subtitle
            attributed.append(NSAttributedString(string: "\n\(subtitle)", attributes: [
                NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 11),
                NSAttributedString.Key.foregroundColor : Theme.color(.SurveyOptionText).withAlphaComponent(0.7),
            ]))
        } else {
            attributed.append(NSAttributedString(string: "Selecione um jogador...", attributes: [
                NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 11),
                NSAttributedString.Key.foregroundColor : Theme.color(.SurveyOptionText),
            ]))
        }
        self.lblTitle.attributedText = attributed
    }
    
    @objc func actionMethod() {
        NotificationCenter.default.post(name: NSNotification.Name(MultipleSurveysViewController.listSelectorNotificationName), object: nil)
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.btnAction)
        self.addCenterXAlignmentConstraintTo(subView: self.btnAction, constant: 0)
        self.addTopAlignmentConstraintTo(subView: self.btnAction, constant: 20)
        // Arrow
        self.btnAction.addSubview(self.ivArrow)
        self.btnAction.addCenterYAlignmentConstraintTo(subView: self.ivArrow, constant: 0)
        self.btnAction.addTrailingAlignmentConstraintTo(subView: self.ivArrow, constant: -15)
        self.ivArrow.addWidthConstraint(6)
        self.ivArrow.addHeightConstraint(11)
        // Title
        self.btnAction.addSubview(self.lblTitle)
        self.btnAction.addCenterYAlignmentConstraintTo(subView: self.lblTitle, constant: 0)
        self.btnAction.addLeadingAlignmentConstraintTo(subView: self.lblTitle, constant: 15)
        
        if (UIScreen.main.bounds.height < 667) {
            self.btnAction.addWidthConstraint(250)
            self.btnAction.addHeightConstraint(52)
        } else {
            self.btnAction.addWidthConstraint(280)
            self.btnAction.addHeightConstraint(52)
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

