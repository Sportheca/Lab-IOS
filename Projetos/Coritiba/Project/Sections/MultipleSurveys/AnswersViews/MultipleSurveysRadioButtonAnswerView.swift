//
//  MultipleSurveysRadioButtonAnswerView.swift
//  
//
//  Created by Roberto Oliveira on 06/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MultipleSurveysRadioButtonAnswerView: UIView {
    
    // MARK: - Properties
    private var currentQuestion:MultipleSurveyQuestion?
    
    
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.alignment = .fill
        vw.distribution = .fillEqually
        vw.spacing = 15.0
        return vw
    }()
    
    
    // MARK: - Methods
    func updateContent(item:MultipleSurveyQuestion) {
        self.currentQuestion = item
        for sub in self.stackView.arrangedSubviews {
            sub.removeFromSuperview()
        }
        
        var maxWidth:CGFloat = 0.0
        for option in item.options {
            
            let lbl = UILabel()
            lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 18)
            lbl.text = option.title
            lbl.sizeToFit()
            maxWidth = max(maxWidth, lbl.bounds.width)
            
            let btn = CustomButton()
            btn.tag = option.id
            btn.setTitle(option.title, for: .normal)
            btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 18)
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 15.0
            btn.layer.borderWidth = 1.0
            if item.selectedOptionID == option.id {
                btn.layer.borderColor = Theme.color(.PrimaryButtonBackground).cgColor
                btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
                btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
            } else {
                btn.layer.borderColor = Theme.color(.PrimaryCardElements).cgColor
                btn.backgroundColor = UIColor.clear
                btn.setTitleColor(Theme.color(.PrimaryCardElements), for: .normal)
            }
            btn.highlightedAlpha = 0.5
            btn.highlightedScale = 0.95
            btn.addHeightConstraint(35)
            btn.addWidthConstraint(100)
            btn.addTarget(self, action: #selector(self.tap(_:)), for: .touchUpInside)
            self.stackView.addArrangedSubview(btn)
        }
        
        self.stackView.axis = (maxWidth > 80 || item.options.count > 2) ? .vertical : .horizontal
    }
    
    @objc func tap(_ sender:UIButton) {
        guard let item = self.currentQuestion else {return}
        self.currentQuestion?.selectedOptionID = sender.tag
        ServerManager.shared.setTrack(trackEvent: EventTrack.MultipleSurveys.selectAnswerOption, trackValue: "\(sender.tag)@\(item.id)")
        NotificationCenter.default.post(name: NSNotification.Name(MultipleSurveysViewController.answerNotificationName), object: nil)
        DispatchQueue.main.async {
            self.updateContent(item: item)
        }
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.stackView)
        self.addCenterXAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.stackView, constant: 0)
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
