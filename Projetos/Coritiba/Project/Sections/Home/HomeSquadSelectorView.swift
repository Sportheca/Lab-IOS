//
//  HomeSquadSelectorView.swift
//  
//
//  Created by Roberto Oliveira on 04/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol HomeSquadSelectorViewDelegate:AnyObject {
    func homeSquadSelectorView(didSelectStartWith homeSquadSelectorView:HomeSquadSelectorView)
}

class HomeSquadSelectorView: UIView {
    
    // MARK: - Properties
    var currentItem:SquadSelectorInfo?
    weak var delegate:HomeSquadSelectorViewDelegate?
    
    
    // MARK: - Objects
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    let loadingView:ContentLoadingView = ContentLoadingView()
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor(hexString: "1D1D1D")
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        vw.layer.borderWidth = 1.0
        vw.layer.borderColor = UIColor.white.cgColor
        return vw
    }()
    private let adsView:AdsView = {
        let vw = AdsView()
        vw.lblTitle.textColor = Theme.color(.MutedText)
        return vw
    }()
    private lazy var btnAction:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("FAÇA A SUA ESCALAÇÃO", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Knockout.Regular, size: 22)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.highlightedAlpha = 0.70
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.actionMethod), for: .touchUpInside)
        return btn
    }()
    private let squadView:SquadSelectorView = SquadSelectorView()
    
    
    
    
    
    @objc func actionMethod() {
        self.delegate?.homeSquadSelectorView(didSelectStartWith: self)
    }
    
    
    
    // MARK: - Methods
    func updateContent(item:SquadSelectorInfo?) {
        self.currentItem = item
        guard let item = item else {
            self.containerView.alpha = 0
            return
        }
        self.containerView.alpha = 1
        // Title
        self.lblHeader.text = item.title.uppercased()
        // Content
        self.squadView.updateContent(scheme: item.scheme, items: item.items)
        // Ads
        self.adsView.updateContent(position: AdsPosition.Selecaoideal)
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Title
        self.addSubview(self.lblHeader)
        self.lblHeader.addHeightConstraint(35)
        self.addBoundsConstraintsTo(subView: self.lblHeader, leading: 22, trailing: -10, top: 12, bottom: nil)
        self.lblHeader.setContentCompressionResistancePriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        // Content
        self.addSubview(self.containerView)
        self.addCenterXAlignmentConstraintTo(subView: self.containerView, constant: 0)
        self.addVerticalSpacingTo(subView1: self.lblHeader, subView2: self.containerView, constant: 5)
        self.addBottomAlignmentConstraintTo(subView: self.containerView, constant: -20)
        self.addLeadingAlignmentConstraintTo(subView: self.containerView, relatedBy: .equal, constant: 10, priority: 750)
        self.addTrailingAlignmentConstraintTo(subView: self.containerView, relatedBy: .equal, constant: -10, priority: 750)
        self.containerView.addWidthConstraint(constant: 500, relatedBy: .lessThanOrEqual, priority: 999)
        // Loading
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.loadingView, reference: self.containerView, constant: 0)
        // Ads
//        self.containerView.addSubview(self.adsView)
//        self.containerView.addBoundsConstraintsTo(subView: self.adsView, leading: 10, trailing: -10, top: 10, bottom: nil)
//        self.adsView.addHeightConstraint(50)
        // Action
        self.containerView.addSubview(self.btnAction)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.btnAction, constant: 0)
        self.btnAction.addHeightConstraint(40)
        self.btnAction.addWidthConstraint(255)
//        self.containerView.addVerticalSpacingTo(subView1: self.adsView, subView2: self.btnAction, constant: 10)
        self.containerView.addTopAlignmentConstraintTo(subView: self.btnAction, constant: 25)
        // Content
        self.containerView.addSubview(self.squadView)
        self.containerView.addVerticalSpacingTo(subView1: self.btnAction, subView2: self.squadView, constant: 25)
        self.containerView.addBoundsConstraintsTo(subView: self.squadView, leading: 0, trailing: 0, top: nil, bottom: -20)
        self.addConstraint(NSLayoutConstraint(item: self.squadView, attribute: .width, relatedBy: .equal, toItem: self.squadView, attribute: .height, multiplier: 0.69, constant: 0))
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




