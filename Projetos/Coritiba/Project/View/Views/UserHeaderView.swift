//
//  UserHeaderView.swift
//
//
//  Created by Roberto Oliveira on 03/04/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class UserHeaderView: UIView {
    
    // MARK: - Properties
    var openUserProfileTrackEvent:Int?
    var openStoreTrackEvent:Int?
    var openNotificationsTrackEvent:Int?
    
    
    // MARK: - Objects
    private let coinsView:CoinsView = {
        let vw = CoinsView()
        vw.lblCoins.textColor = UIColor.white
        return vw
    }()
    private lazy var btnAvatar:AvatarButton = {
        let btn = AvatarButton()
        btn.isUserInteractionEnabled = false
        return btn
    }()
    private lazy var infoButton:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = UIColor.clear
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.openUserProfile), for: .touchUpInside)
        return btn
    }()
    private let infoStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Knockout.Regular, size: 21)
        lbl.textColor = UIColor.white
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Knockout.Regular, size: 15)
        lbl.textColor = UIColor(hexString: "F4F5F7")
        return lbl
    }()
    private lazy var btnNotifications:NotificationBellButton = {
        let btn = NotificationBellButton()
        btn.addTarget(self, action: #selector(self.openNotificationsCentral), for: .touchUpInside)
        return btn
    }()
    private lazy var btnStore:CustomButton = {
        let btn = CustomButton()
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(self.openStore), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Methods
    func updateContent() {
        self.coinsView.updateContent()
        guard let user = ServerManager.shared.user else {return}
        self.btnAvatar.updateWithCurrentUserImage()
        self.lblTitle.text = user.name
        self.lblSubtitle.text = user.membershipTitle()
        
        self.btnNotifications.updateContent()
    }
    
    @objc func openNotificationsCentral() {
        DispatchQueue.main.async {
            let vc = NotificationsCentralViewController()
            vc.trackEvent = self.openNotificationsTrackEvent
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func openUserProfile() {
        ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
            guard confirmed else {return}
            DispatchQueue.main.async {
                let vc = UserProfileViewController()
                vc.badgesTrackEvent = self.openUserProfileTrackEvent
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func openStore() {
        ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
            guard confirmed else {return}
            DispatchQueue.main.async {
                let vc = StoreHomeViewController()
                vc.trackEvent = self.openStoreTrackEvent
                let nav = NavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                nav.isDarkStatusBarStyle = false
                nav.modalPresentationStyle = .fullScreen
                nav.modalTransitionStyle = .coverVertical
                UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Info
        self.addSubview(self.infoButton)
        self.addBoundsConstraintsTo(subView: self.infoButton, leading: nil, trailing: nil, top: 0, bottom: 0)
        // Avatar
        self.infoButton.addSubview(self.btnAvatar)
        self.infoButton.addBoundsConstraintsTo(subView: self.btnAvatar, leading: 0, trailing: nil, top: 0, bottom: 0)
        // Infos
        self.infoButton.addSubview(self.infoStackView)
        self.infoButton.addTrailingAlignmentConstraintTo(subView: self.infoStackView, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.btnAvatar, subView2: self.infoStackView, constant: 8)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.infoStackView, reference: self.btnAvatar, constant: 0)
        self.infoStackView.addArrangedSubview(self.lblTitle)
        self.infoStackView.addArrangedSubview(self.lblSubtitle)
        self.infoStackView.isUserInteractionEnabled = false
        // Notification
        self.addSubview(self.btnNotifications)
        self.addCenterYAlignmentConstraintTo(subView: self.btnNotifications, constant: 0)
        self.btnNotifications.addHeightConstraint(36)
        self.btnNotifications.addWidthConstraint(36)
        // Coins
        self.addSubview(self.btnStore)
        self.addCenterYAlignmentConstraintTo(subView: self.btnStore, constant: 0)
        self.btnStore.addSubview(self.coinsView)
        self.btnStore.addFullBoundsConstraintsTo(subView: self.coinsView, constant: 0)
        self.coinsView.isUserInteractionEnabled = false
        self.addHorizontalSpacingTo(subView1: self.btnStore, subView2: self.btnNotifications, constant: 6)
        self.addHorizontalSpacingTo(subView1: self.infoStackView, subView2: self.coinsView, relatedBy: .greaterThanOrEqual, constant: 5, priority: 999)
        
        if UIScreen.main.bounds.width < 375 {
            self.addLeadingAlignmentConstraintTo(subView: self.infoButton, constant: 10)
            self.btnAvatar.addSquareSizeConstraint(UserHeaderView.avatarButtonSize)
            self.addTrailingAlignmentConstraintTo(subView: self.btnNotifications, constant: -5)
        } else {
            self.addLeadingAlignmentConstraintTo(subView: self.infoButton, constant: 20)
            self.btnAvatar.addSquareSizeConstraint(UserHeaderView.avatarButtonSize)
            self.addTrailingAlignmentConstraintTo(subView: self.btnNotifications, constant: -15)
        }
    }
    
    static let avatarButtonSize:CGFloat = {
        return (UIScreen.main.bounds.width < 375) ? 42 : 52
    }()
    
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}



