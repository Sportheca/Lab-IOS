//
//  UserProfileViewController.swift
//
//
//  Created by Roberto Oliveira on 08/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class UserProfileViewController: BaseViewController {
    
    // MARK: - Properties
    var badgesTrackEvent:Int?
    
    
    // MARK: - Objects
    lazy var headerView:UserProfileHeaderView = {
        let vw = UserProfileHeaderView()
        vw.btnAvatar.addTarget(self, action: #selector(self.chooseAvatarImage), for: .touchUpInside)
        vw.btnSettings.addTarget(self, action: #selector(self.openSettings), for: .touchUpInside)
        vw.btnMembershipCardID.addTarget(self, action: #selector(self.openMembershipCardID), for: .touchUpInside)
        return vw
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryCardElements), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private lazy var badgesView:UserBadgesView = {
        let vw = UserBadgesView()
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.userBadgesTryAgain), for: .touchUpInside)
        vw.paginationDelegate = self
        return vw
    }()
    
    
    
    // MARK: - Methods
    private func loadContent() {
        ServerManager.shared.getUserInfo { (success:Bool?) in
            if success == true {
                DispatchQueue.main.async {
                    self.headerView.updateContent()
                }
            }
        }
    }
    
    @objc func openSettings() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Profile.openSettings, trackValue: nil)
        DispatchQueue.main.async {
            let vc = SettingsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Profile.close, trackValue: nil)
        self.dismissAction()
    }
    
    @objc func openMembershipCardID() {
        CardIDViewController.present()
    }
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerView.updateContent()
        self.loadContent()
    }
    
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.loadUserBadges()
    }
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.view.addSubview(self.headerView)
        self.view.addTopAlignmentConstraintTo(subView: self.headerView.backView, constant: 0)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.headerView, constant: 0)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: nil, bottom: nil)
        // Close
        self.headerView.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // Badges
        self.view.insertSubview(self.badgesView, belowSubview: self.headerView)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.badgesView, constant: -10)
        self.view.addBoundsConstraintsTo(subView: self.badgesView, leading: 0, trailing: 0, top: nil, bottom: 0)
    }
    
}








// MARK: - Badges
extension UserProfileViewController: PaginationContentViewDelegate {
    
    func didPullToReload() {
        self.badgesTrackEvent = EventTrack.Profile.pullToReloadBadges
        self.loadUserBadges()
    }
    
    
    func loadNexPage() {
        self.loadUserBadges()
    }
    
    private func loadUserBadges() {
        DispatchQueue.main.async {
            if self.badgesView.dataSource.isEmpty {
                self.badgesView.loadingView.startAnimating()
                self.badgesView.collectionView.isHidden = true
            }
        }
        ServerManager.shared.getUserBadges(page: self.badgesView.currentPage, trackEvent: self.badgesTrackEvent) { (objects:[BadgeItem]?, limit:Int?, margin:Int?) in
            self.badgesTrackEvent = nil
            let items = objects ?? []
            DispatchQueue.main.async() {
                if self.badgesView.currentPage == 1 {
                    self.badgesView.updateContent(items: items, limit: limit, margin: margin)
                    if items.isEmpty {
                        self.badgesView.loadingView.emptyResults()
                    } else {
                        self.badgesView.collectionView.isHidden = false
                        self.badgesView.loadingView.stopAnimating()
                    }
                } else {
                    self.badgesView.addContent(items: items)
                }
            }
        }
    }
    
    @objc func userBadgesTryAgain() {
        self.badgesTrackEvent = EventTrack.Profile.badgesTryAgain
        self.loadUserBadges()
    }
    
    
}
