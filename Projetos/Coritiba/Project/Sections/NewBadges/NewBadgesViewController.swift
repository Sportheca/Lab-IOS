//
//  NewBadgesViewController.swift
//  
//
//  Created by Roberto Oliveira on 20/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class NewBadgesViewController: BaseViewController {
    
    // MARK: - Properties
    private var loadingStatus:LoadingStatus = .NotRequested
    var dataSource:[NewBadge] = []
    private var currentIndex:Int = 0
    
    
    
    // MARK: - Methods
    // back views
    private var backView0Constraint:NSLayoutConstraint = NSLayoutConstraint()
    private let backView0:UIView = UIView()
    private var backView1Constraint:NSLayoutConstraint = NSLayoutConstraint()
    private let backView1:UIView = UIView()
    // content
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Nova Conquista!"
        return lbl
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.setTitle("CONCLUÍDO", for: .normal)
        btn.layer.cornerRadius = 10
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.9
        btn.addTarget(self, action: #selector(self.confirmMethod), for: .touchUpInside)
        return btn
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 15.0
        return vw
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 4
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 14)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    
    
    
    
    
    
    // MARK: - Methods
    @objc func confirmMethod() {
        if self.dataSource.count-1 > self.currentIndex {
            ServerManager.shared.setTrack(trackEvent: EventTrack.NewBadge.nextBadge, trackValue: nil)
            DispatchQueue.main.async {
                self.currentIndex += 1
                self.updateContent()
            }
        } else {
            ServerManager.shared.setTrack(trackEvent: EventTrack.NewBadge.close, trackValue: nil)
            DispatchQueue.main.async {
                self.dismissAction()
            }
        }
    }
    
    private func loadContent() {
        guard self.dataSource.isEmpty else {
            DispatchQueue.main.async {
                self.loadingStatus = .Completed
                self.currentIndex = 0
                self.checkLoadingResult()
            }
            return
        }
        self.loadingStatus = .Loading
        ServerManager.shared.getNewBadges(trackEvent: nil) { (objects:[NewBadge]?) in
            DispatchQueue.main.async {
                self.loadingStatus = .Completed
                self.dataSource = objects ?? []
                self.currentIndex = 0
                self.checkLoadingResult()
            }
        }
    }
    
    
    
    private func checkLoadingResult() {
        guard self.loadingStatus == .Completed else {return}
        DispatchQueue.main.async {
            self.updateContent()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations: {
                self.btnConfirm.alpha = 1.0
                self.btnConfirm.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    
    func updateContent() {
        guard self.currentIndex < self.dataSource.count else {return}
        let item = self.dataSource[self.currentIndex]
        self.ivCover.setServerImage(urlString: item.imageUrlString)
        self.lblTitle.text = item.title
        self.lblSubtitle.text = item.subtitle
        self.stackView.bounceAnimation()
    }
    
    
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.animateBackViews { (_) in
                self.animateTitle { (_) in
                    //self.checkLoadingResult()
                }
            }
        }
    }
    
    
    private func animateBackViews(completion: @escaping (_ finished:Bool)->Void) {
        self.backView0Constraint.isActive = false
        self.backView1Constraint.isActive = false
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations: {
            self.view.layoutSubviews()
        }, completion: completion)
    }
    
    
    private func animateTitle(completion: @escaping (_ finished:Bool)->Void) {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: [], animations: {
            self.lblHeader.alpha = 1.0
            self.lblHeader.transform = CGAffineTransform.identity
        }, completion: completion)
    }
    
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.view.backgroundColor = UIColor.clear
        // Back View 0
        self.view.addSubview(self.backView0)
        self.view.addBoundsConstraintsTo(subView: self.backView0, leading: nil, trailing: nil, top: 0, bottom: 0)
        self.view.addLeadingAlignmentConstraintTo(subView: self.backView0, relatedBy: .equal, constant: 0, priority: 750)
        self.view.addConstraint(NSLayoutConstraint(item: self.backView0, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.5, constant: 0))
        self.backView0Constraint = NSLayoutConstraint(item: self.backView0, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
        self.backView0Constraint.priority = UILayoutPriority(999)
        self.view.addConstraint(self.backView0Constraint)
        // Back View 1
        self.view.addSubview(self.backView1)
        self.view.addBoundsConstraintsTo(subView: self.backView1, leading: nil, trailing: nil, top: 0, bottom: 0)
        self.view.addTrailingAlignmentConstraintTo(subView: self.backView1, relatedBy: .equal, constant: 0, priority: 750)
        self.view.addWidthRelatedConstraintTo(subView: self.backView1, reference: self.backView0)
        self.backView1Constraint = NSLayoutConstraint(item: self.backView1, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
        self.backView1Constraint.priority = UILayoutPriority(999)
        self.view.addConstraint(self.backView1Constraint)
        
        self.backView0.backgroundColor = Theme.color(.PrimaryBackground)
        self.backView1.backgroundColor = Theme.color(.PrimaryBackground)
        // container
        self.view.addSubview(self.containerView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.containerView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.containerView, constant: 0)
        self.containerView.addWidthConstraint(constant: 500, relatedBy: .lessThanOrEqual, priority: 999)
        self.containerView.addHeightConstraint(constant: 700, relatedBy: .lessThanOrEqual, priority: 999)
        self.view.addLeadingAlignmentConstraintTo(subView: self.containerView, relatedBy: .equal, constant: 20, priority: 750)
        self.view.addTrailingAlignmentConstraintTo(subView: self.containerView, relatedBy: .equal, constant: -20, priority: 750)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.containerView, constant: 20, priority: 750, relatedBy: .equal)
        self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.containerView, constant: -20, priority: 750, relatedBy: .equal)
        // confirm
        self.containerView.addSubview(self.btnConfirm)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.btnConfirm, constant: 0)
        self.containerView.addBottomAlignmentConstraintTo(subView: self.btnConfirm, constant: 0)
        self.btnConfirm.addWidthConstraint(300)
        self.btnConfirm.addHeightConstraint(50)
        // Header
        self.containerView.addSubview(self.lblHeader)
        self.containerView.addBoundsConstraintsTo(subView: self.lblHeader, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.containerView.addTopAlignmentConstraintTo(subView: self.lblHeader, relatedBy: .equal, constant: 30, priority: 750)
        // Stack
        self.containerView.addSubview(self.stackView)
        self.containerView.addVerticalSpacingTo(subView1: self.lblHeader, subView2: self.stackView, constant: 40)
        self.containerView.addBoundsConstraintsTo(subView: self.stackView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.stackView.addArrangedSubview(self.ivCover)
        self.ivCover.addWidthConstraint(260)
        self.ivCover.addHeightConstraint(260)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.lblSubtitle)
        
        
        // Initial State
        // header
        self.lblHeader.alpha = 0.0
        self.lblHeader.transform = CGAffineTransform(scaleX: 0, y: 0)
        // confirm
        self.btnConfirm.alpha = 0.0
        self.btnConfirm.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    
    
}
