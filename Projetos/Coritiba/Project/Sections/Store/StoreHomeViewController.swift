//
//  StoreHomeViewController.swift
//  
//
//  Created by Roberto Oliveira on 13/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class StoreHomeViewController: BaseViewController {
    
    // MARK: - Properties
    private var searchString:String = ""
    var trackEvent:Int?
    
    
    // MARK: - Objects
    private let headerView:PageHeaderView = {
        let vw = PageHeaderView()
        vw.updateContent(title: "Resgates", subtitle: "Troque suas Moedas por recompensas!")
        return vw
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PageHeaderText), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private let coinsView:CoinsView = {
        let vw = CoinsView()
        vw.lblCoins.textColor = Theme.color(.PageHeaderText)
        return vw
    }()
    private lazy var contentView:StoreContentView = {
        let vw = StoreContentView()
        vw.delegate = self
        return vw
    }()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    
    
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Store.close, trackValue: nil)
        self.dismissAction()
    }
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.Store.tryAgain
        self.loadContent()
    }
    
    private func loadContent() {
        DispatchQueue.main.async {
            self.view.becomeFirstResponder()
            self.contentView.isHidden = true
            self.contentView.alpha = 0.0
            self.coinsView.alpha = 0.5
            self.loadingView.startAnimating()
        }
        ServerManager.shared.getStoreGroups(searchString: self.searchString, trackEvent: self.trackEvent) { (items:[StoreGroup]?) in
            self.trackEvent = nil
            DispatchQueue.main.async {
                let objects = items ?? []
                self.contentView.updateContent(items: objects)
                if objects.isEmpty {
                    self.loadingView.emptyResults()
                } else {
                    self.loadingView.stopAnimating()
                }
                self.contentView.isHidden = false
                UIView.animate(withDuration: 0.25) {
                    self.contentView.alpha = 1.0
                }
            }
        }
        ServerManager.shared.getUserInfo { (success:Bool?) in
            DispatchQueue.main.async {
                self.coinsView.alpha = 1.0
                self.coinsView.updateContent()
            }
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.coinsView.updateContent()
        self.loadContent()
    }
    
    
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // Coins
        self.view.addSubview(self.coinsView)
        self.view.addTopAlignmentRelatedConstraintTo(subView: self.coinsView, reference: self.btnClose, constant: 0)
        self.view.addTrailingAlignmentConstraintTo(subView: self.coinsView, constant: -20)
        // Header
        self.view.insertSubview(self.headerView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: 0, bottom: nil)
        // Content
        self.view.insertSubview(self.contentView, belowSubview: self.headerView)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.contentView, constant: -25)
        self.view.addBoundsConstraintsTo(subView: self.contentView, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentRelatedConstraintTo(subView: self.loadingView, reference: self.contentView, constant: 0)
        
    }
    
    override var canBecomeFirstResponder: Bool {return true}
    
}



extension StoreHomeViewController: StoreContentViewDelegate {
    
    func storeContentView(storeContentView: StoreContentView, didSelectSearch search: String) {
        self.searchString = search
        self.loadContent()
    }
    
    func storeContentView(storeContentView: StoreContentView, didSelectItem item: StoreItem) {
        DispatchQueue.main.async {
            let vc = StoreItemDetailsViewController(item: item)
            vc.trackEvent = EventTrack.Store.selectItem
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
