//
//  QuizGroupViewController.swift
//  
//
//  Created by Roberto Oliveira on 07/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class QuizGroupViewController: BaseViewController {
    
    // MARK: - Properties
    var loadingStatus:LoadingStatus = .NotRequested
    var colorScheme:ColorScheme = .Primary
    var currentItem:QuizGroup?
    
    
    
    // MAKR: - Objects
    private let ivCover:OverlayImageView = OverlayImageView()
    private let ivShape:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "custom_shape_1")
        iv.alpha = 0.75
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        return iv
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
        btn.addTarget(self, action: #selector(self.backMethod), for: .touchUpInside)
        return btn
    }()
    private let separatorView:UIView = {
        let vw = UIView()
        vw.alpha = 0.35
        return vw
    }()
    private let adsView:AdsView = AdsView()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 24)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 5
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 14)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private let lblFooter:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 11)
        return lbl
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
    
    
    
    
    
    // MAKR: - Methods
    @objc func backMethod() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.QuizGroups.backToList, trackValue: self.currentItem?.id)
        self.dismissAction()
    }
    
    @objc func confirm() {
        guard let item = self.currentItem else {return}
        if let total = item.totalQuestions, let answered = item.answeredQuestions {
            if answered >= total {
                DispatchQueue.main.async {
                    self.basicAlert(message: "Você já respondeu todas as perguntas deste Quiz!", handler: nil)
                }
                return
            }
        }
        ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
            guard confirmed else {return}
            DispatchQueue.main.async {
                let vc = QuestionViewController(type: .Quiz)
                vc.trackEvent = EventTrack.QuizGroups.startGroup
                vc.trackValue = item.id
                vc.group = self.currentItem
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @objc func tryAgain() {
        self.loadContent()
    }
    
    private func loadContent() {
        guard self.loadingStatus != .Completed else {
            self.updateContent()
            return
        }
        DispatchQueue.main.async {
            self.containerView.isHidden = true
            self.loadingView.startAnimating()
        }
        ServerManager.shared.getQuizGroups(referenceId: self.currentItem?.id, page: 1, trackEvent: nil) { (items:[QuizGroup]?, limit:Int?, margin:Int?) in
            DispatchQueue.main.async {
                if let item = items?.first {
                    self.loadingView.stopAnimating()
                    self.currentItem = item
                    
                    self.updateContent()
                    self.containerView.isHidden = false
                } else {
                    self.loadingView.emptyResults()
                }
            }
        }
    }
    
    private func updateContent() {
        DispatchQueue.main.async {
            guard let item = self.currentItem else {return}
            self.ivCover.setServerImage(urlString: item.imageUrlString)
            self.lblTitle.text = item.title
            self.lblSubtitle.text = item.message
            var confirmTitle = "INICIAR QUIZ"
            if let value = item.answeredQuestions {
                if value > 0 {
                    confirmTitle = "CONTINUAR QUIZ"
                }
            }
            self.btnConfirm.setTitle(confirmTitle, for: .normal)
            var footer:String = ""
            if let total = item.totalQuestions, let answered = item.answeredQuestions {
                if answered > 0 {
                    footer = "\(item.correctAnswers.descriptionWithThousandsSeparator())/\(answered.descriptionWithThousandsSeparator())"
                }
                self.btnConfirm.alpha = answered >= total ? 0.5 : 1.0
            }
            self.lblFooter.text = footer
        }
    }
    
    
    
    
    
    // MAKR: - Super Methods
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.updateColors()
        self.adsView.updateContent(position: AdsPosition.Quiz)
        self.loadContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateContent()
        
    }
    
    private func updateColors() {
        self.view.backgroundColor = self.colorScheme.primaryColor()
        self.loadingView.color = self.colorScheme.elementsColor()
        self.ivCover.updateColor(self.colorScheme.primaryColor())
        self.btnClose.setTitleColor(self.colorScheme.elementsColor(), for: .normal)
        self.separatorView.backgroundColor = self.colorScheme.elementsColor()
        self.adsView.lblTitle.textColor = self.colorScheme.elementsColor()
        self.lblTitle.textColor = self.colorScheme.elementsColor()
        self.lblSubtitle.textColor = self.colorScheme.elementsColor()
        self.lblFooter.textColor = self.colorScheme.elementsColor()
        self.btnConfirm.backgroundColor = Theme.color(.PrimaryButtonBackground)
        self.btnConfirm.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
    }
    
    
    // MAKR: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Background
        self.view.addSubview(self.ivCover)
        self.view.addFullBoundsConstraintsTo(subView: self.ivCover, constant: 0)
        self.view.addSubview(self.ivShape)
        self.view.addConstraint(NSLayoutConstraint(item: self.ivShape, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.35, constant: 0))
        self.view.addBoundsConstraintsTo(subView: self.ivShape, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addCenterXAlignmentConstraintTo(subView: self.btnClose, constant: 0)
        self.view.addBottomAlignmentConstraintTo(subView: self.btnClose, constant: -15)
        self.btnClose.addHeightConstraint(40)
        self.btnClose.addWidthConstraint(100)
        // Separator
        self.view.addSubview(self.separatorView)
        self.view.addVerticalSpacingTo(subView1: self.separatorView, subView2: self.btnClose, constant: 15)
        self.view.addBoundsConstraintsTo(subView: self.separatorView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.separatorView.addHeightConstraint(1)
        // Ads
        self.view.addSubview(self.adsView)
        self.view.addBoundsConstraintsTo(subView: self.adsView, leading: 10, trailing: -10, top: 20, bottom: nil)
        self.adsView.addHeightConstraint(50)
        // Container
        self.view.addSubview(self.containerView)
        self.view.addBoundsConstraintsTo(subView: self.containerView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.view.addVerticalSpacingTo(subView1: self.adsView, subView2: self.containerView, constant: 10)
        self.view.addVerticalSpacingTo(subView1: self.containerView, subView2: self.separatorView, constant: 10)
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        // Titlte
        self.containerView.addSubview(self.lblTitle)
        self.containerView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 20, trailing: -20, top: 20, bottom: nil)
        // Subtitle
        self.containerView.addSubview(self.lblSubtitle)
        self.containerView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.lblSubtitle, constant: 10)
        self.containerView.addBoundsConstraintsTo(subView: self.lblSubtitle, leading: 20, trailing: -20, top: nil, bottom: nil)
        // Footer
        self.containerView.addSubview(self.lblFooter)
        self.containerView.addBoundsConstraintsTo(subView: self.lblFooter, leading: 20, trailing: -20, top: nil, bottom: -10)
        self.lblFooter.addHeightConstraint(20)
        // Confirm
        self.containerView.addSubview(self.btnConfirm)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.btnConfirm, constant: 0)
        self.containerView.addVerticalSpacingTo(subView1: self.btnConfirm, subView2: self.lblFooter, constant: 10)
        self.btnConfirm.addWidthConstraint(230)
        self.btnConfirm.addHeightConstraint(35)
    }
    
}


