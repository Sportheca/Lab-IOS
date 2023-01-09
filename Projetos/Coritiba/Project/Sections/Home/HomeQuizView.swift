//
//  HomeQuizView.swift
//  
//
//  Created by Roberto Oliveira on 24/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

struct HomeQuizItem {
    var id:Int
    var imageUrl:String?
    var title:String
    var subtitle:String
    var message:String
    var answeredQuestions:Int
}

protocol HomeQuizViewDelegate:AnyObject {
    func homeQuizView(homeQuizView:HomeQuizView, didSelectItem item:HomeQuizItem)
}

class HomeQuizView: UIView {
    
    // MARK: - Properties
    var currentItem:HomeQuizItem?
    weak var delegate:HomeQuizViewDelegate?
    
    
    // MARK: - Objects
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "QUIZ"
        return lbl
    }()
    let loadingView:ContentLoadingView = ContentLoadingView()
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private let ivCover:OverlayImageView = OverlayImageView()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Knockout.Regular, size: 12)
        return lbl
    }()
    private let lblMessage:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 4
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 14)
        return lbl
    }()
    private let adsView:AdsView = AdsView()
    private lazy var btnAction:CustomButton = {
        let btn = CustomButton()
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Knockout.Regular, size: 24)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.highlightedAlpha = 0.70
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.actionMethod), for: .touchUpInside)
        return btn
    }()
    @objc func actionMethod() {
        guard let item = self.currentItem else {return}
        self.delegate?.homeQuizView(homeQuizView: self, didSelectItem: item)
    }
    
    
    
    // MARK: - Methods
    func updateContent(item:HomeQuizItem?) {
        self.currentItem = item
        guard let item = item else {
            self.containerView.alpha = 0
            return
        }
        self.containerView.alpha = 1
        let textColor = Theme.color(.PrimaryCardElements)
        // Cover
        self.ivCover.updateColor(Theme.color(.PrimaryCardBackground))
        self.ivCover.setServerImage(urlString: item.imageUrl)
        // Title
        self.lblTitle.textColor = textColor
        self.lblTitle.text = item.title
        // Subtitle
        self.lblSubtitle.textColor = textColor
        self.lblSubtitle.text = item.subtitle
        // Message
        self.lblMessage.textColor = textColor
        self.lblMessage.text = item.message
        // Action
        self.btnAction.backgroundColor = Theme.color(.PrimaryButtonBackground)
        self.btnAction.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        let actionTitle = item.answeredQuestions == 0 ? "INICIAR AGORA" : "CONTINUAR QUIZ"
        self.btnAction.setTitle(actionTitle, for: .normal)
        // Ads
        self.adsView.updateContent(position: AdsPosition.QuizDashboard)
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Title
        self.addSubview(self.lblHeader)
        self.lblHeader.addHeightConstraint(25)
        self.addBoundsConstraintsTo(subView: self.lblHeader, leading: 22, trailing: nil, top: 12, bottom: nil)
        self.lblHeader.setContentCompressionResistancePriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        // Content
        self.addSubview(self.containerView)
        self.addVerticalSpacingTo(subView1: self.lblHeader, subView2: self.containerView, constant: 5)
        self.addBoundsConstraintsTo(subView: self.containerView, leading: 10, trailing: -10, top: nil, bottom: -10)
        self.containerView.addHeightConstraint(225)
        // Loading
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.loadingView, reference: self.containerView, constant: 0)
        // Image
        self.containerView.addSubview(self.ivCover)
        self.containerView.addFullBoundsConstraintsTo(subView: self.ivCover, constant: 0)
        // Title
        self.containerView.addSubview(self.lblTitle)
        self.containerView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 8, trailing: -8, top: 15, bottom: nil)
        // Subtitle
        self.containerView.addSubview(self.lblSubtitle)
        self.containerView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.lblSubtitle, constant: 0)
        self.containerView.addBoundsConstraintsTo(subView: self.lblSubtitle, leading: 8, trailing: -8, top: nil, bottom: nil)
        // Message
        self.containerView.addSubview(self.lblMessage)
        self.containerView.addBoundsConstraintsTo(subView: self.lblMessage, leading: 20, trailing: -20, top: nil, bottom: nil)
        self.containerView.addVerticalSpacingTo(subView1: self.lblSubtitle, subView2: self.lblMessage, constant: 10)
        // Ads
//        self.containerView.addSubview(self.adsView)
//        self.containerView.addBoundsConstraintsTo(subView: self.adsView, leading: 10, trailing: -10, top: nil, bottom: -10)
//        self.adsView.addHeightConstraint(50)
        // Action
        self.containerView.addSubview(self.btnAction)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.btnAction, constant: 0)
        self.btnAction.addHeightConstraint(40)
        self.btnAction.addWidthConstraint(255)
//        self.containerView.addVerticalSpacingTo(subView1: self.btnAction, subView2: self.adsView, constant: 10)
        self.containerView.addVerticalSpacingTo(subView1: self.lblMessage, subView2: self.btnAction, constant: 10)
        self.containerView.addBottomAlignmentConstraintTo(subView: self.btnAction, constant: -30)
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



