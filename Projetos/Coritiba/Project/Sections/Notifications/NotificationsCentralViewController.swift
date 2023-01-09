//
//  NotificationsCentralViewController.swift
//  
//
//  Created by Roberto Oliveira on 07/04/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class NotificationsCentralViewController: BaseViewController {
    
    // MARK: - Properties
    var trackEvent:Int?
    
    
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
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 16)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Notificações"
        return lbl
    }()
    private lazy var contentView:NotificationCentralContentView = {
        let vw = NotificationCentralContentView()
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        vw.paginationDelegate = self
        vw.delegate = self
        return vw
    }()
    private lazy var btnAllRead:CustomButton = {
        let btn = CustomButton()
        btn.setImage(UIImage(named: "icon_options_menu")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = Theme.color(.PrimaryText)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        btn.adjustsImageWhenHighlighted = false
        btn.highlightedAlpha = 0.6
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.setAllRead), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.NotificationsCentral.close, trackValue: nil)
        self.dismissAction()
    }
    
    @objc func setAllRead() {
        DispatchQueue.main.async {
            let items:[BasicInfo] = [BasicInfo(id: 1, title: "Marcar todas como lidas")]
            let vc = OptionsMenuViewController(items: items, isLeftSideFixed: false, topSpace: self.btnAllRead.frame.maxY, sideSpace: 15)
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - Super Methods
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.loadContent()
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // Filters
        self.view.addSubview(self.btnAllRead)
        self.view.addCenterYAlignmentRelatedConstraintTo(subView: self.btnAllRead, reference: self.btnClose, constant: 0)
        self.view.addTrailingAlignmentConstraintTo(subView: self.btnAllRead, constant: -15)
        self.btnAllRead.addHeightConstraint(35)
        self.btnAllRead.addWidthConstraint(40)
        // Title
        self.view.addSubview(self.lblTitle)
        self.view.addVerticalSpacingTo(subView1: self.btnClose, subView2: self.lblTitle, constant: 10)
        self.view.addLeadingAlignmentRelatedConstraintTo(subView: self.lblTitle, reference: self.btnClose, constant: 0)
        // Header
        self.view.insertSubview(self.headerView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.view.addBottomAlignmentRelatedConstraintTo(subView: self.headerView, reference: self.lblTitle, constant: 10)
        // Content
        self.view.addSubview(self.contentView)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.contentView, constant: 0)
        self.view.addBoundsConstraintsTo(subView: self.contentView, leading: 0, trailing: 0, top: nil, bottom: 0)
    }
    
}





// MARK: - Badges
extension NotificationsCentralViewController: PaginationContentViewDelegate, NotificationCentralContentViewDelegate, OptionsMenuViewControllerDelegate {
    
    func didPullToReload() {
        self.trackEvent = EventTrack.NotificationsCentral.pullToReload
        self.loadContent()
    }
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.NotificationsCentral.tryAgain
        self.loadContent()
    }
    
    func loadNexPage() {
        self.loadContent()
    }
    
    private func loadContent() {
        DispatchQueue.main.async {
            if self.contentView.dataSource.isEmpty {
                self.contentView.loadingView.startAnimating()
                self.contentView.collectionView.isHidden = true
            }
        }
        ServerManager.shared.getLogPushUser(page: self.contentView.currentPage, trackEvent: self.trackEvent) { (objects:[NotificationsCentralItem]?, limit:Int?, margin:Int?) in
            self.trackEvent = nil
            let items = objects ?? []
            DispatchQueue.main.async() {
                if self.contentView.currentPage == 1 {
                    self.contentView.updateContent(items: items, limit: limit, margin: margin)
                    if items.isEmpty {
                        self.contentView.loadingView.emptyResults()
                    } else {
                        self.contentView.collectionView.isHidden = false
                        self.contentView.loadingView.stopAnimating()
                    }
                } else {
                    self.contentView.addContent(items: items)
                }
            }
        }
    }
    
    
    func notificationCentralContentView(notificationCentralContentView: NotificationCentralContentView, didSelectItem item: NotificationsCentralItem) {
        ServerManager.shared.setLogPushOpen(item.pushItem.id, trackId: EventTrack.NotificationsCentral.selectItem)
        DispatchQueue.main.async {
            UIApplication.shared.performPushNotificationDeeplink(for: item.pushItem, fromNotificationCentral: true)
        }
    }
    
    
    func optionsMenuViewController(optionsMenuViewController: OptionsMenuViewController, didSelectItem item: BasicInfo) {
        guard item.id == 1 else {return}
        ServerManager.shared.setPushNotificationAllRead(trackId: EventTrack.NotificationsCentral.setAllRead)
        let items = self.contentView.dataSource as? [NotificationsCentralItem] ?? []
        for item in items {
            item.read = true
        }
        DispatchQueue.main.async {
            self.contentView.collectionView.reloadData()
        }
    }
    
}

