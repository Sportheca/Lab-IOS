//
//  NewsViewController.swift
//  
//
//  Created by Roberto Oliveira on 09/03/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: BaseViewController {
    
    // MARK: - Properties
    private var currentID:Int?
    private var currentItem:News?
    var trackEvent:Int?
    
    var closeTrackEvent:Int? = EventTrack.News.close
    var tryAgainTrackEvent:Int? = EventTrack.News.tryAgain
    var shareTrackEvent:Int? = EventTrack.News.share
    
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
    private lazy var btnShare:CustomButton = {
        let btn = CustomButton()
        btn.setImage(UIImage(named: "icon_share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = Theme.color(.PrimaryText)
        btn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.shareAction), for: .touchUpInside)
        return btn
    }()
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryBackground)
        return vw
    }()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var webView:WKWebView = {
        let vw = WKWebView()
        vw.backgroundColor = UIColor.clear
        vw.isOpaque = false
        return vw
    }()
    
    
    
    
    // MARK: - Methods
    @objc func shareAction() {
        ServerManager.shared.setTrack(trackEvent: self.shareTrackEvent, trackValue: self.currentID)
        guard let shareLink = self.currentItem?.shareLink else {return}
        let string = shareLink + "\n\n" + ProjectInfoManager.TextInfo.baixe_agora_o_app.rawValue
        DispatchQueue.main.async {
            UIApplication.shared.shareString(string: string)
        }
    }
    
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: self.closeTrackEvent, trackValue: self.currentID)
        self.dismissAction()
    }
    
    @objc func tryAgain() {
        self.trackEvent = self.tryAgainTrackEvent
        self.loadContent()
    }
    
    private func loadContent() {
        guard let id = self.currentID else {return}
        DispatchQueue.main.async {
            self.btnShare.isHidden = true
            self.webView.isHidden = true
            self.loadingView.startAnimating()
        }
        ServerManager.shared.getNews(id: id, trackEvent: self.trackEvent) { (object:News?) in
            self.trackEvent = nil
            self.currentItem = object
            DispatchQueue.main.async {
                self.btnShare.isHidden = object?.shareLink == nil
                if let url = URL(string: object?.bodyLink ?? "") {
                    self.webView.isHidden = false
                    self.webView.load(URLRequest(url: url))
                    self.loadingView.stopAnimating()
                } else {
                    self.loadingView.emptyResults()
                }
            }
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
        // Share
        self.view.addSubview(self.btnShare)
        self.view.addCenterYAlignmentRelatedConstraintTo(subView: self.btnShare, reference: self.btnClose, constant: 0)
        self.btnShare.addWidthConstraint(33)
        self.btnShare.addHeightConstraint(33)
        self.view.addTrailingAlignmentConstraintTo(subView: self.btnShare, constant: -12)
        // Header
        self.view.insertSubview(self.headerView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.view.addBottomAlignmentRelatedConstraintTo(subView: self.headerView, reference: self.btnClose, constant: 10)
        // Container
        self.view.addSubview(self.containerView)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.containerView, constant: 0)
        self.view.addBoundsConstraintsTo(subView: self.containerView, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Web
        self.containerView.addSubview(self.webView)
        self.containerView.addFullBoundsConstraintsTo(subView: self.webView, constant: 0)
        // Loading
        self.containerView.addSubview(self.loadingView)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.containerView.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        
    }
    
    init(id:Int) {
        super.init()
        self.currentID = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}



