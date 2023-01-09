//
//  WebDocumentViewController.swift
//  
//
//  Created by Roberto Oliveira on 11/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit
import WebKit

enum WebDocumentMode {
    case Default
    case StoreItem
}

class WebDocumentViewController: BaseViewController {
    
    // MARK: - Properties
    private var mode:WebDocumentMode = .Default
    private var currentID:Int?
    var trackEvent:Int?
    
    var closeTrackEvent:Int? = EventTrack.Document.close
    var tryAgainTrackEvent:Int? = EventTrack.Document.tryAgain
    
    
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
        vw.isOpaque = false
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    
    
    
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: self.closeTrackEvent, trackValue: self.currentID)
        self.dismissAction()
    }
    
    @objc func tryAgain() {
        ServerManager.shared.setTrack(trackEvent: self.tryAgainTrackEvent, trackValue: self.currentID)
        self.loadContent()
    }
    
    private func loadContent() {
        guard let id = self.currentID else {return}
        DispatchQueue.main.async {
            self.webView.isHidden = true
            self.loadingView.startAnimating()
        }
        ServerManager.shared.getWebDocumentItem(mode:self.mode, id: id, trackEvent: self.trackEvent) { (object:WebDocumentItem?) in
            self.trackEvent = nil
            DispatchQueue.main.async {
                if let item = object {
                    self.webView.isHidden = false
                    self.webView.loadHTMLString(item.body, baseURL: nil)
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
    
    init(id:Int, mode:WebDocumentMode = .Default) {
        super.init()
        self.mode = mode
        self.currentID = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


