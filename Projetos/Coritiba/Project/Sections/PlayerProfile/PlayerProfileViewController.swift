//
//  PlayerProfileViewController.swift
//  
//
//  Created by Roberto Oliveira on 20/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

extension PlayerProfileViewController {
    static func showPlayer(id:Int, trackEvent:Int?) {
        DispatchQueue.main.async {
            let vc = PlayerProfileViewController()
            vc.currentItem = PlayerProfile(id: id)
            vc.trackEvent = trackEvent
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }
    }
}

class PlayerProfileViewController: BaseViewController {
    
    // MARK: - Properties
    private var currentItem:PlayerProfile?
    private var loadingStatus:LoadingStatus = .NotRequested
    var trackEvent:Int?
    
    
    
    // MARK: - Objects
    private let navigationStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .equalSpacing
        return vw
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.closeAction), for: .touchUpInside)
        return btn
    }()
    private lazy var btnShare:CustomButton = {
        let btn = CustomButton()
        btn.setImage(UIImage(named: "icon_share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = Theme.color(.PrimaryAnchor)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.shareAction), for: .touchUpInside)
        return btn
    }()
    private let contentContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let contentView:PlayerProfileContentView = PlayerProfileContentView()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    
    
    
    // MARK: - Methods
    @objc func closeAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.PlayerProfile.close, trackValue: self.currentItem?.id)
        DispatchQueue.main.async {
            self.dismissAction()
        }
    }
    
    @objc func shareAction() {
        // --
    }
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.PlayerProfile.tryAgain
        self.loadContent()
    }
    
    private func loadContent() {
        guard let item = self.currentItem else {return}
        DispatchQueue.main.async {
            self.contentView.alpha = 0
            self.loadingView.startAnimating()
        }
        ServerManager.shared.getPlayerProfileDetails(item: item, trackEvent: self.trackEvent) { (success:Bool) in
            self.trackEvent = nil
            DispatchQueue.main.async {
                self.contentView.alpha = 1.0
                self.loadingView.stopAnimating()
                self.contentView.updateContent(item: item)
            }
        }
    }
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.loadingStatus == .NotRequested {
            self.loadContent()
        }
    }
    
    
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Navigation
        self.view.addSubview(self.navigationStackView)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.navigationStackView, constant: 10)
        self.view.addBoundsConstraintsTo(subView: self.navigationStackView, leading: 25, trailing: -15, top: nil, bottom: nil)
        self.navigationStackView.addArrangedSubview(self.btnClose)
        self.navigationStackView.addArrangedSubview(self.btnShare)
        self.view.addConstraint(NSLayoutConstraint(item: self.btnShare, attribute: .width, relatedBy: .equal, toItem: self.btnShare, attribute: .height, multiplier: 1.0, constant: 0))
        self.navigationStackView.addHeightConstraint(40)
        self.btnShare.alpha = 0
        self.btnShare.isUserInteractionEnabled = false
        // Container
        self.view.addSubview(self.contentContainerView)
        self.view.addVerticalSpacingTo(subView1: self.navigationStackView, subView2: self.contentContainerView, constant: 0)
        self.view.addBoundsConstraintsTo(subView: self.contentContainerView, leading: 10, trailing: -10, top: nil, bottom: nil)
        self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.contentContainerView, constant: -10)
        // Content
        self.contentContainerView.addSubview(self.contentView)
        self.contentContainerView.addFullBoundsConstraintsTo(subView: self.contentView, constant: 0)
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
    }
    
}
