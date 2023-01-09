//
//  SettingsViewController.swift
//  
//
//  Created by Roberto Oliveira on 27/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class SettingsViewController: BaseStackViewController {
    
    // MARK: - Properties
    var menuTrackEvent:Int?
    
    
    
    // MARK: - Objects
    private let headerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryBackground)
        return vw
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private lazy var userProfileView:SettingsUserProfileView = {
        let vw = SettingsUserProfileView()
        vw.delegate = self
        return vw
    }()
    private lazy var menuView:SettingsMenuView = {
        let vw = SettingsMenuView()
        vw.delegate = self
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.menuTryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var dangerOptionsView:SettingsDangerOptionsView = {
        let vw = SettingsDangerOptionsView()
        vw.delegate = self
        return vw
    }()
    
    
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Settings.close, trackValue: nil)
        self.dismissAction()
    }
    
    
    // MARK: - Super Methods
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.loadMenuItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userProfileView.updateContent()
        
        self.dangerOptionsView.updateContent(items: [SettingsDangerOptionItem.DeleteAccount])
        self.dangerOptionsView.isHidden = !ServerManager.shared.isUserRegistered()
//        self.dangerOptionsView.isHidden = true
        
    }
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.scrollView.alwaysBounceVertical = true
        self.addStackSpaceView(height: 50)
        self.addFullWidthStackSubview(self.userProfileView)
        self.addFullWidthStackSubview(self.menuView)
        self.addFullWidthStackSubview(self.dangerOptionsView)
        self.addStackSpaceView(height: 50)
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // Header
        self.view.insertSubview(self.headerView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.view.addBottomAlignmentRelatedConstraintTo(subView: self.headerView, reference: self.btnClose, constant: 10)
    }
    
}




// MARK: - Infos
extension SettingsViewController: SettingsUserProfileViewDelegate {
    
    func settingsUserProfileView(settingsUserProfileView: SettingsUserProfileView, didSelectItem item: SettingsUserProfileItem) {
        switch item.mode {
        case .Password:
            ServerManager.shared.setTrack(trackEvent: EventTrack.Settings.changePassword, trackValue: nil)
            ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
                guard confirmed else {return}
                DispatchQueue.main.async {
                    let vc = UserProfileChangePasswordViewController()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true, completion: nil)
                }
            }
            return
        case .EditProfile:
            ServerManager.shared.setTrack(trackEvent: EventTrack.Settings.editProfile, trackValue: nil)
            ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
                guard confirmed else {return}
                DispatchQueue.main.async {
                    let vc = EditProfileViewController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .coverVertical
                    self.present(vc, animated: true, completion: nil)
                }
            }
            return
        default: break
        }
    }
    
}




// MARK: - Menu
extension SettingsViewController: SettingsMenuViewDelegate {
    
    func settingsMenuView(settingsMenuView: SettingsMenuView, didSelectItem item: BasicInfo) {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Settings.openDocument, trackValue: item.id)
        DispatchQueue.main.async {
            let vc = WebDocumentViewController(id: item.id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func loadMenuItems() {
        DispatchQueue.main.async {
            self.menuView.updateContent(items: [])
            self.menuView.loadingView.startAnimating()
        }
        ServerManager.shared.getMenuDocumentsOptions(trackEvent: self.menuTrackEvent) { (infos:[BasicInfo]?) in
            self.menuTrackEvent = nil
            DispatchQueue.main.async {
                let items:[BasicInfo] = infos ?? []
                self.menuView.updateContent(items: items)
                if items.isEmpty {
                    self.menuView.loadingView.emptyResults()
                } else {
                    self.menuView.loadingView.stopAnimating()
                }
            }
        }
    }
    
    @objc func menuTryAgain() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Settings.documentsTryAgain, trackValue: nil)
        self.menuTrackEvent = nil//--
        self.loadMenuItems()
    }
    
}

extension SettingsViewController: SettingsDangerOptionsViewDelegate {
    
    func settingsDangerOptionsView(settingsDangerOptionsView: SettingsDangerOptionsView, didSelectItem item: SettingsDangerOptionItem) {
        DispatchQueue.main.async {
            let vc = UserProfileDeleteAccountViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
