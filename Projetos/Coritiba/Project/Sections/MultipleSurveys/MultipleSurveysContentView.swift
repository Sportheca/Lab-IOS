//
//  MultipleSurveysContentView.swift
//  
//
//  Created by Roberto Oliveira on 06/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MultipleSurveysContentView: UIView {
    
    // MARK: - Properties
    private var currentItem:MultipleSurveysGroup?
    var currentQuestionIndex:Int? {
        didSet {
            self.updateCurrentQuestion()
        }
    }
    
    
    // MARK: - Objects
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    let btnResultsDetails:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("VER ÚLTIMOS RESULTADOS", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.adjustsAlphaWhenHighlighted = false
        btn.highlightedScale = 0.95
        return btn
    }()
    private let lblFooter:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 20)
        return lbl
    }()
    private lazy var btnNext:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = UIColor.clear
        btn.setTitle("Próxima", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.nextQuestionButtonMethod), for: .touchUpInside)
        return btn
    }()
    private lazy var btnPrevious:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = UIColor.clear
        btn.setTitle("Voltar", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.previousQuestionButtonMethod), for: .touchUpInside)
        return btn
    }()
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let coverView:MultipleSurveysGroupCoverView = MultipleSurveysGroupCoverView()
    let questionView:MultipleSurveysQuestionView = MultipleSurveysQuestionView()
    private let endView:MultipleSurveysGroupEndView = MultipleSurveysGroupEndView()
    
    
    
    // MARK: - Methods
    func updateContent(item:MultipleSurveysGroup) {
        self.currentItem = item
        self.currentQuestionIndex = nil
        self.updateCurrentQuestion()
        
        self.coverView.updateContent(item: item)
    }
    
    @objc func nextQuestionButtonMethod() {
        if let item = self.currentItem, let index = self.currentQuestionIndex {
            if item.questions.count > index {
                ServerManager.shared.setTrack(trackEvent: EventTrack.MultipleSurveys.nextQuestion, trackValue: item.questions[index].id)
            }
        }
        self.nextQuestion()
    }
    
    func nextQuestion() {
        self.changeCurrentQuestionIndex(forward: true)
    }
    
    @objc func previousQuestionButtonMethod() {
        if let item = self.currentItem, let index = self.currentQuestionIndex {
            if item.questions.count > index {
                ServerManager.shared.setTrack(trackEvent: EventTrack.MultipleSurveys.previousQuestion, trackValue: item.questions[index].id)
            }
        }
        self.previousQuestion()
    }
    
    func previousQuestion() {
        self.changeCurrentQuestionIndex(forward: false)
    }
    
    private func changeCurrentQuestionIndex(forward:Bool) {
        guard let index = self.currentQuestionIndex else {
            self.currentQuestionIndex = 0
            return
        }
        self.currentQuestionIndex = forward ? index+1 : index-1
    }
    
    private func updateCurrentQuestion() {
        self.coverView.isHidden = self.currentQuestionIndex != nil
        self.endView.isHidden = true
        guard let item = self.currentItem, let index = self.currentQuestionIndex else {
            let attributedHeader = NSMutableAttributedString()
            attributedHeader.append(NSAttributedString(string: "PALPITES", attributes: [
                NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Black, size: 24)
            ]))
            self.lblHeader.attributedText = attributedHeader
            self.questionView.isHidden = true
            self.lblFooter.text = nil
            self.btnPrevious.isHidden = true
            self.btnNext.isHidden = true
            self.btnResultsDetails.isHidden = self.currentItem?.hasPreviousResultsAvailable != true
            return
        }
        self.btnResultsDetails.isHidden = true
        // header
        let attributedHeader = NSMutableAttributedString()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 5.0
        let title = item.title ?? ""
        attributedHeader.append(NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 18),
            NSAttributedString.Key.paragraphStyle : paragraph
        ]))
        let subtitle = item.subtitle ?? ""
        attributedHeader.append(NSAttributedString(string: "\n\(subtitle)", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 16),
            NSAttributedString.Key.paragraphStyle : paragraph
        ]))
        self.lblHeader.attributedText = attributedHeader
        
        // content
        if index < item.questions.count { // just to make sure
            self.questionView.updateContent(item: item.questions[index], group: item)
        }
        self.questionView.isHidden = false
        
        // footer
        self.lblFooter.text = "\(index+1)/\(item.questions.count)"
        self.btnPrevious.isHidden = index == 0
        self.btnNext.isHidden = index >= item.questions.count-1
    }
    
    func setLoading() {
        self.questionView.isHidden = true
        self.lblFooter.text = nil
        self.btnPrevious.isHidden = true
        self.btnNext.isHidden = true
        self.endView.isHidden = true
        self.btnResultsDetails.isHidden = true
    }
    
    func showSuccess() {
        self.currentQuestionIndex = nil
        self.coverView.isHidden = true
        self.endView.updateContent(iconName: "large_check", message: "Seus palpites foram computados com sucesso, boa sorte!")
        self.endView.isHidden = false
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // header
        self.addSubview(self.lblHeader)
        self.addBoundsConstraintsTo(subView: self.lblHeader, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.lblHeader.addHeightConstraint(constant: 65, relatedBy: .lessThanOrEqual, priority: 999)
        // Results Details
        self.addSubview(self.btnResultsDetails)
        self.addCenterXAlignmentConstraintTo(subView: self.btnResultsDetails, constant: 0)
        self.btnResultsDetails.addWidthConstraint(210)
        self.btnResultsDetails.addHeightConstraint(28)
        self.addVerticalSpacingTo(subView1: self.lblHeader, subView2: self.btnResultsDetails, constant: 8)
        // Footer
        self.addSubview(self.lblFooter)
        self.addCenterXAlignmentConstraintTo(subView: self.lblFooter, constant: 0)
        self.addBottomAlignmentConstraintTo(subView: self.lblFooter, constant: 0)
        self.lblFooter.addHeightConstraint(40)
        // Next
        self.addSubview(self.btnNext)
        self.btnNext.addHeightConstraint(30)
        self.btnNext.addWidthConstraint(100)
        self.addBottomAlignmentConstraintTo(subView: self.btnNext, constant: -5)
        self.addTrailingAlignmentConstraintTo(subView: self.btnNext, constant: -10)
        // Previous
        self.addSubview(self.btnPrevious)
        self.btnPrevious.addHeightConstraint(30)
        self.btnPrevious.addWidthConstraint(100)
        self.addBottomAlignmentConstraintTo(subView: self.btnPrevious, constant: -5)
        self.addLeadingAlignmentConstraintTo(subView: self.btnPrevious, constant: 10)
        // Container
        self.addSubview(self.containerView)
        self.addBoundsConstraintsTo(subView: self.containerView, leading: 0, trailing: 0, top: 65, bottom: -40)
        // Cover
        self.containerView.addSubview(self.coverView)
        self.containerView.addFullBoundsConstraintsTo(subView: self.coverView, constant: 0)
        // Question
        self.containerView.addSubview(self.questionView)
        self.containerView.addFullBoundsConstraintsTo(subView: self.questionView, constant: 0)
        // End
        self.containerView.addSubview(self.endView)
        self.containerView.addFullBoundsConstraintsTo(subView: self.endView, constant: 0)
        
        self.lblHeader.textColor = Theme.color(.PrimaryCardElements)
        self.lblFooter.textColor = Theme.color(.PrimaryCardElements)
        self.btnNext.setTitleColor(Theme.color(.PrimaryCardElements), for: .normal)
        self.btnPrevious.setTitleColor(Theme.color(.PrimaryCardElements), for: .normal)
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
