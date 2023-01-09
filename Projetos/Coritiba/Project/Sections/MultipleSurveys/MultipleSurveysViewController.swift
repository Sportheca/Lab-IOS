//
//  MultipleSurveysViewController.swift
//  
//
//  Created by Roberto Oliveira on 06/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MultipleSurveysViewController: BaseViewController {
    
    // MARK: - Static Properties
    static let answerNotificationName = "MultipleSurveysViewController_answerNotificationName"
    static let listSelectorNotificationName = "MultipleSurveysViewController_listSelectorNotificationName"
    
    // MARK: - Properties
    private var currentItem:MultipleSurveysGroup?
    private var listSelectorDataSource:[SquadSelectorListItem] = []
    private var trackEvent:Int?
    
    
    // MARK: - Objects
    private let ivBackground:OverlayImageView = OverlayImageView()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.setTitle("Atualizar", for: .normal)
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private let contentContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let adsView:AdsView = AdsView()
    private lazy var contentView:MultipleSurveysContentView = {
        let vw = MultipleSurveysContentView()
        vw.btnResultsDetails.addTarget(self, action: #selector(self.openResultDetails), for: .touchUpInside)
        return vw
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.adjustsAlphaWhenHighlighted = false
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    private lazy var btnResultsDetails:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("VER ÚLTIMOS RESULTADOS", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.adjustsAlphaWhenHighlighted = false
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.openResultDetails), for: .touchUpInside)
        return btn
    }()
    
    
    // MARK: - Methods
    @objc func openResultDetails() {
        DispatchQueue.main.async {
            let vc = MultipleSurveysResultsGroupsViewController()
            vc.trackEvent = EventTrack.MultipleSurveys.openResultsDetails
            let nav = NavigationController(rootViewController: vc)
            nav.navigationBar.isTranslucent = false
            nav.navigationBar.isHidden = true
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .coverVertical
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.MultipleSurveys.tryAgain
        self.loadContent()
    }
    
    @objc func confirm() {
        DispatchQueue.main.async {
            guard let item = self.currentItem else {return}
            guard !item.questions.isEmpty else {return}
            if item.isCompleted {
                if self.contentView.currentQuestionIndex == nil {
                    ServerManager.shared.setTrack(trackEvent: EventTrack.MultipleSurveys.showAnswers, trackValue: item.id)
                    self.contentView.nextQuestion() // show previous answers
                } else {
                    ServerManager.shared.setTrack(trackEvent: EventTrack.MultipleSurveys.back, trackValue: item.id)
                    self.contentView.updateContent(item: item) // back to intro
                }
                self.updateConfirmButton()
                return
            }
            
            if self.contentView.currentQuestionIndex == nil {
                // start
                ServerManager.shared.setTrack(trackEvent: EventTrack.MultipleSurveys.start, trackValue: item.id)
                ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
                    guard confirmed else {return}
                    DispatchQueue.main.async {
                        self.contentView.nextQuestion()
                        self.updateConfirmButton()
                    }
                }
            } else {
                if item.isFinishAllowed() {
                    self.trackEvent = EventTrack.MultipleSurveys.send
                    self.sendAnswers()
                } else {
                    self.basicAlert(message: "Responda todos os palpites para finalizar", handler: nil)
                }
            }
        }
    }
    
    private func loadContent() {
        DispatchQueue.main.async {
            self.contentContainerView.isHidden = true
            self.loadingView.startAnimating()
        }
        ServerManager.shared.getMultipleSurveysGroup(trackEvent: self.trackEvent) { (object:MultipleSurveysGroup?, hasPreviousResultsAvailable:Bool?) in
            self.trackEvent = nil
            DispatchQueue.main.async {
                self.currentItem = object
                guard let item = self.currentItem else {
                    self.btnConfirm.isHidden = true
                    self.contentContainerView.isHidden = false
                    self.btnResultsDetails.isHidden = hasPreviousResultsAvailable != true
                    self.contentView.updateContent(item: MultipleSurveysGroup(id: 0))
                    self.loadingView.emptyResults(title: "Nenhum confronto ativo.")
                    return
                }
                self.contentContainerView.isHidden = false
                self.loadingView.stopAnimating()
                // background
                self.ivBackground.setServerImage(urlString: item.backgroundImageUrl)
                // ads
                self.adsView.updateContent(position: AdsPosition.Palpite)
                // content
                self.contentView.updateContent(item: item)
                // action
                self.btnResultsDetails.isHidden = true
                self.btnConfirm.isHidden = false
                self.updateConfirmButton()
            }
        }
    }
    
    private func updateConfirmButton() {
        guard let item = self.currentItem else {return}
        var title = "PARTICIPAR"
        if item.isCompleted {
            if self.contentView.currentQuestionIndex == nil {
                title = "VER PALPITES"
            } else {
                title = "VOLTAR"
            }
        } else {
            if self.contentView.currentQuestionIndex != nil {
                title = "FINALIZAR"
                self.btnConfirm.alpha = item.isFinishAllowed() ? 1.0 : 0.5
            }
        }
        self.btnConfirm.setTitle(title, for: .normal)
    }
    
    
    @objc func checkAnswers() {
        DispatchQueue.main.async {
            self.updateConfirmButton()
        }
    }
    
    private func sendAnswers() {
        guard let item = self.currentItem else {return}
        DispatchQueue.main.async {
            self.contentView.setLoading()
            self.loadingView.startAnimating()
            self.btnConfirm.alpha = 0.5
            self.btnConfirm.isUserInteractionEnabled = false
        }
        ServerManager.shared.setMultipleSurveysGroup(item: item, trackEvent: self.trackEvent) { (success:Bool?, message:String?) in
            self.trackEvent = nil
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.contentView.showSuccess()
                self.btnConfirm.alpha = 1.0
                self.btnConfirm.isUserInteractionEnabled = true
                self.updateConfirmButton()
            }
        }
    }
    
    @objc func openListSelector() {
        guard let item = self.currentItem else {return}
        DispatchQueue.main.async {
            let vc = SquadSelectorItemsListViewController()
            vc.trackEvent = EventTrack.MultipleSurveys.openPlayersSelector
            vc.closeAndTryAgainTrackValue = item.id
            vc.closeTrackEvent = EventTrack.MultipleSurveysListSelector.close
            vc.tryAgainTrackEvent = EventTrack.MultipleSurveysListSelector.tryAgain
            vc.selecteItemTrackEvent = EventTrack.MultipleSurveysListSelector.selectItem
            
            if let index = self.contentView.currentQuestionIndex {
                if index < item.questions.count {
                    vc.trackValue = item.questions[index].id
                }
            }
            vc.extendedLayoutIncludesOpaqueBars = true
            vc.edgesForExtendedLayout = [.all]
            vc.dataSource = self.listSelectorDataSource
            var selectedIds:[Int] = []
            if let currentIndex = self.contentView.currentQuestionIndex {
                if currentIndex < item.questions.count {
                    let question = item.questions[currentIndex]
                    if let selected = question.selectedListItem {
                        selectedIds.append(selected.id)
                    }
                }
            }
            vc.selectedIds = selectedIds
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkAnswers), name: NSNotification.Name(MultipleSurveysViewController.answerNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openListSelector), name: NSNotification.Name(MultipleSurveysViewController.listSelectorNotificationName), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.loadContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        // Ads
        self.contentContainerView.addSubview(self.adsView)
        self.adsView.addHeightConstraint(50)
        // Confirm
        self.contentContainerView.addSubview(self.btnConfirm)
        self.contentContainerView.addCenterXAlignmentConstraintTo(subView: self.btnConfirm, constant: 0)
        self.btnConfirm.addWidthConstraint(240)
        // Confirm
        self.contentContainerView.addSubview(self.btnResultsDetails)
        self.contentContainerView.addCenterXAlignmentConstraintTo(subView: self.btnResultsDetails, constant: 0)
        self.btnResultsDetails.addWidthConstraint(240)
        // Content
        self.contentContainerView.addSubview(self.contentView)
        self.contentContainerView.addBoundsConstraintsTo(subView: self.contentView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.contentContainerView.addVerticalSpacingTo(subView1: self.adsView, subView2: self.contentView, constant: 5)
        self.contentContainerView.addVerticalSpacingTo(subView1: self.contentView, subView2: self.btnConfirm, constant: 10)
        // Colors
        self.view.backgroundColor = Theme.color(Theme.Color.PrimaryCardBackground)
        self.ivBackground.updateColor(Theme.color(Theme.Color.PrimaryCardBackground))
        self.loadingView.color = Theme.color(.PrimaryCardElements)
        self.btnConfirm.backgroundColor = Theme.color(.PrimaryButtonBackground)
        self.btnConfirm.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        self.btnResultsDetails.backgroundColor = Theme.color(.PrimaryButtonBackground)
        self.btnResultsDetails.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        
        
        if (UIScreen.main.bounds.height < 667) {
            self.contentContainerView.addBoundsConstraintsTo(subView: self.adsView, leading: 0, trailing: 0, top: 5, bottom: nil)
            self.btnConfirm.addHeightConstraint(30)
            self.contentContainerView.addBottomAlignmentConstraintTo(subView: self.btnConfirm, constant: -10)
            self.btnResultsDetails.addHeightConstraint(30)
            self.contentContainerView.addBottomAlignmentConstraintTo(subView: self.btnResultsDetails, constant: -10)
        } else {
            self.contentContainerView.addBoundsConstraintsTo(subView: self.adsView, leading: 0, trailing: 0, top: 10, bottom: nil)
            self.btnConfirm.addHeightConstraint(40)
            self.contentContainerView.addBottomAlignmentConstraintTo(subView: self.btnConfirm, constant: -30)
            self.btnResultsDetails.addHeightConstraint(40)
            self.contentContainerView.addBottomAlignmentConstraintTo(subView: self.btnResultsDetails, constant: -30)
        }
    }
    
}





extension MultipleSurveysViewController: SquadSelectorItemsListViewControllerDelegate {
    
    func squadSelectorItemsListViewController(squadSelectorItemsListViewController: SquadSelectorItemsListViewController, didSelectItem item: SquadSelectorListItem) {
        guard let object = self.currentItem else {return}
        DispatchQueue.main.async {
            if let currentIndex = self.contentView.currentQuestionIndex {
                if currentIndex < object.questions.count {
                    let question = object.questions[currentIndex]
                    question.selectedListItem = item
                    self.contentView.questionView.listSelectorView.updateContent(item: question)
                    self.checkAnswers()
                }
            }
        }
    }
    
    func squadSelectorItemsListViewController(squadSelectorItemsListViewController: SquadSelectorItemsListViewController, didFinishLoadItems items: [SquadSelectorListItem]) {
        self.listSelectorDataSource = items
    }
    
}




