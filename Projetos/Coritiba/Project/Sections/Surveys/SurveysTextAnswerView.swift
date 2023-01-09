//
//  SurveysTextAnswerView.swift
//  
//
//  Created by Roberto Oliveira on 12/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class SurveysTextAnswerView: UIView, UITextViewDelegate {
    
    // MARK: - Properties
    private var currentQuestion:SurveyQuestion?
    
    
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.SurveyOptionBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private lazy var txvAnswer:UITextView = {
        let txv = UITextView()
        txv.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
        txv.textColor = Theme.color(.SurveyOptionText)
        txv.backgroundColor = UIColor.clear
        txv.delegate = self
        return txv
    }()
    private let lblPlaceholder:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
        lbl.textColor = Theme.color(.SurveyOptionText).withAlphaComponent(0.5)
        lbl.text = "Escreva sua resposta..."
        return lbl
    }()
    private let lblMessage:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 13)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.text = "Resposta enviada!"
        return lbl
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.setTitle("ENVIAR", for: .normal)
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    
    
    // MARK: - Methods
    func updateContent(item:SurveyQuestion) {
        self.currentQuestion = item
        self.txvAnswer.text = ""
        self.lblPlaceholder.isHidden = false
        self.lblMessage.alpha = 0.0
        self.btnConfirm.alpha = 1.0
    }
    
    @objc func confirm() {
        ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
            guard confirmed else {return}
            let txt = self.txvAnswer.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard txt != "" else {
                DispatchQueue.main.async {
                    UIApplication.topViewController()?.basicAlert(message: "Preencha o campo de resposta antes de enviar!", handler: nil)
                }
                return
            }
            DispatchQueue.main.async {
                self.txvAnswer.resignFirstResponder()
                UIView.animate(withDuration: 0.25) {
                    self.btnConfirm.alpha = 0.0
                    self.lblMessage.alpha = 1.0
                }
                self.lblMessage.bounceAnimation()
            }
            self.currentQuestion?.text = txt
            NotificationCenter.default.post(name: NSNotification.Name(SurveysViewController.answerNotificationName), object: nil)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlaceholder.isHidden = textView.text != ""
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // container
        self.addSubview(self.containerView)
        self.addCenterXAlignmentConstraintTo(subView: self.containerView, constant: 0)
        self.addTopAlignmentConstraintTo(subView: self.containerView, constant: 0)
        // textview
        self.containerView.addSubview(self.txvAnswer)
        self.txvAnswer.addDefaultAccessory()
        self.containerView.addBoundsConstraintsTo(subView: self.txvAnswer, leading: 10, trailing: -10, top: 0, bottom: 0)
        self.containerView.addSubview(self.lblPlaceholder)
        self.containerView.addBoundsConstraintsTo(subView: self.lblPlaceholder, leading: 15, trailing: -10, top: 8, bottom: nil)
        // Message
        self.addSubview(self.lblMessage)
        self.addVerticalSpacingTo(subView1: self.containerView, subView2: self.lblMessage, constant: 10)
        self.addCenterXAlignmentConstraintTo(subView: self.lblMessage, constant: 0)
        // Confirm
        self.addSubview(self.btnConfirm)
        self.addCenterXAlignmentConstraintTo(subView: self.btnConfirm, constant: 0)
        
        if (UIScreen.main.bounds.height < 667) {
            self.containerView.addHeightConstraint(100)
            self.btnConfirm.addWidthConstraint(200)
            self.btnConfirm.addHeightConstraint(30)
            self.containerView.addWidthConstraint(260)
            self.addBottomAlignmentConstraintTo(subView: self.btnConfirm, constant: -5)
        } else {
            self.containerView.addHeightConstraint(160)
            self.btnConfirm.addWidthConstraint(230)
            self.btnConfirm.addHeightConstraint(35)
            self.containerView.addWidthConstraint(280)
            self.addBottomAlignmentConstraintTo(subView: self.btnConfirm, constant: -8)
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

