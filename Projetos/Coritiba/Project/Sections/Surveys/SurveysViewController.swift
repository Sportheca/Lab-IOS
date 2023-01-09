//
//  SurveysViewController.swift
//  
//
//  Created by Roberto Oliveira on 12/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class SurveysViewController: BaseViewController {
    
    // MARK: - Static Properties
    static let answerNotificationName = "SurveysViewController_didAnswer"
    
    // MARK: - Properties
    private var requiredQuestionID:Int?
    private var currentQuestion:SurveyQuestion?
    private var loadingStatus:LoadingStatus = .NotRequested
    var trackEvent:Int?
    
    
    // MARK: - Objects
    private let ivBackground:OverlayImageView = OverlayImageView()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private let contentContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let adsView:AdsView = AdsView()
    private lazy var contentView:SurveysContentView = {
        let vw = SurveysContentView()
        return vw
    }()
    private lazy var btnAction:CustomButton = {
        let btn = CustomButton()
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
        btn.addTarget(self, action: #selector(self.actionMethod), for: .touchUpInside)
        return btn
    }()
    private let separatorView:UIView = {
        let vw = UIView()
        vw.alpha = 0.35
        return vw
    }()
    
    
    // MARK: - Methods
    @objc func tryAgain() {
        self.trackEvent = EventTrack.Surveys.tryAgain
        self.loadContent()
    }
    
    @objc func actionMethod() {
        guard self.loadingStatus != .Loading else {return}
        guard let question = self.currentQuestion else {return}
        if question.isAnswered() {
            self.trackEvent = EventTrack.Surveys.nextQuestion
            self.loadContent()
        } else {
            self.skipQuestion()
        }
    }
    
    private func loadContent() {
        if self.loadingStatus == .Loading {
            return
        }
        DispatchQueue.main.async {
            self.contentContainerView.isHidden = true
        }
        if self.loadingStatus != .Loading {
            DispatchQueue.main.async {
                self.loadingView.startAnimating()
            }
        }
        self.loadingStatus = .Loading
        ServerManager.shared.getSurveyQuestion(requiredID: self.requiredQuestionID, trackEvent: self.trackEvent, trackValue: self.currentQuestion?.id) { (object:SurveyQuestion?, message:String?) in
            self.trackEvent = nil
            self.requiredQuestionID = nil
            self.loadingStatus = .Completed
            DispatchQueue.main.async {
                self.currentQuestion = object
                guard let item = self.currentQuestion else {
                    self.loadingView.emptyResults(title: message ?? "Você já respondeu todas as pesquisas!")
                    return
                }
                self.updateActionButton()
                // background
                self.ivBackground.setServerImage(urlString: item.backgroundImageUrl)
                // ads
                self.adsView.updateContent(position: AdsPosition.PesquisaInterna)
                // content
                self.contentView.isUserInteractionEnabled = true
                self.contentView.updateContent(item: item)
                // container
                self.loadingView.stopAnimating()
                self.contentContainerView.isHidden = false
                self.contentContainerView.isUserInteractionEnabled = true
            }
        }
    }
    
    func loadQuestion(id:Int) {
        self.loadingStatus = .NotRequested
        self.requiredQuestionID = id
        self.loadContent()
    }
    
    private func skipQuestion() {
        guard let question = self.currentQuestion else {return}
        ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
            guard confirmed else {return}
            self.loadingStatus = .Loading
            DispatchQueue.main.async {
                self.contentContainerView.isUserInteractionEnabled = false
                self.contentContainerView.isHidden = true
                self.loadingView.startAnimating()
            }
            ServerManager.shared.setSurveyQuestion(item: question, trackEvent: EventTrack.Surveys.skipQuestion, trackValue: question.id) { (success:Bool?) in
                self.loadingStatus = .Completed
                self.loadContent()
            }
        }
    }
    
    private func updateActionButton() {
        guard let question = self.currentQuestion else {return}
        if question.isAnswered() {
            self.btnAction.setTitle("Continuar", for: .normal)
        } else {
            self.btnAction.setTitle("Pular", for: .normal)
        }
        self.btnAction.isHidden = question.isLastQuestion
    }
    
    @objc func didAnswer() {
        guard let question = self.currentQuestion else {return}
        guard question.isAnswered() else {return}
        self.loadingStatus = .Loading
        DispatchQueue.main.async {
            self.showCoinsAlert(addCoins: question.score ?? 0)
            self.view.becomeFirstResponder()
            self.contentView.isUserInteractionEnabled = false
            self.contentContainerView.isUserInteractionEnabled = false
            self.btnAction.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.25) {
                self.btnAction.alpha = 0.0
            }
        }
        let trackEvent:Int? = question.type == .Options ? EventTrack.Surveys.selectAnswerOption : EventTrack.Surveys.sendTextAnswer
        
        let trackValue:Int? = question.type == .Options ? question.selectedOptionID : question.id
        
        ServerManager.shared.setSurveyQuestion(item: question, trackEvent: trackEvent, trackValue: trackValue) { (success:Bool?) in
            self.loadingStatus = .Completed
            DispatchQueue.main.async {
                self.contentContainerView.isUserInteractionEnabled = true
                self.updateActionButton()
                self.btnAction.isUserInteractionEnabled = true
                UIView.animate(withDuration: 0.25) {
                    self.btnAction.alpha = 1.0
                }
            }
            
        }
    }
    
    
    
    // MARK: - Super Methods
    override var canBecomeFirstResponder: Bool {return true}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didAnswer), name: NSNotification.Name(SurveysViewController.answerNotificationName), object: nil)
    }
    
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.loadContent()
    }
    
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Background
        self.view.addSubview(self.ivBackground)
        self.view.addFullBoundsConstraintsTo(subView: self.ivBackground, constant: 0)
        // Container
        self.view.addSubview(self.contentContainerView)
        self.view.addFullBoundsConstraintsTo(subView: self.contentContainerView, constant: 0)
        // Action
        self.contentContainerView.addSubview(self.btnAction)
        self.contentContainerView.addCenterXAlignmentConstraintTo(subView: self.btnAction, constant: 0)
        self.contentContainerView.addBottomAlignmentConstraintTo(subView: self.btnAction, constant: -15)
        self.btnAction.addWidthConstraint(100)
        // Separator
        self.contentContainerView.addSubview(self.separatorView)
        self.contentContainerView.addVerticalSpacingTo(subView1: self.separatorView, subView2: self.btnAction, constant: 15)
        self.contentContainerView.addBoundsConstraintsTo(subView: self.separatorView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.separatorView.addHeightConstraint(1)
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        // Ads
        self.contentContainerView.addSubview(self.adsView)
        self.adsView.addHeightConstraint(50)
        // Content
        self.contentContainerView.addSubview(self.contentView)
        self.contentContainerView.addBoundsConstraintsTo(subView: self.contentView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.contentContainerView.addVerticalSpacingTo(subView1: self.adsView, subView2: self.contentView, constant: 5)
        self.contentContainerView.addVerticalSpacingTo(subView1: self.contentView, subView2: self.separatorView, constant: 10)
        // Colors
        self.view.backgroundColor = Theme.color(Theme.Color.PrimaryCardBackground)
        self.ivBackground.updateColor(Theme.color(Theme.Color.PrimaryCardBackground))
        self.loadingView.color = Theme.color(.PrimaryCardElements)
        self.adsView.lblTitle.textColor = Theme.color(.PrimaryCardElements)
        self.separatorView.backgroundColor = Theme.color(.PrimaryCardElements)
        self.btnAction.setTitleColor(Theme.color(.PrimaryCardElements), for: .normal)
        
        if UIScreen.main.bounds.height < 667 {
            self.contentContainerView.addBoundsConstraintsTo(subView: self.adsView, leading: 0, trailing: 0, top: 0, bottom: nil)
            self.btnAction.addHeightConstraint(20)
        } else {
            self.contentContainerView.addBoundsConstraintsTo(subView: self.adsView, leading: 0, trailing: 0, top: 10, bottom: nil)
            self.btnAction.addHeightConstraint(40)
        }
        
    }
    
}



