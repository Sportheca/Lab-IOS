//
//  BaseWebViewController.swift
//
//
//  Created by Roberto Oliveira on 11/10/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit
import WebKit


enum WebContentPresentationMode:Int {
    case ExternalBrowser = 0
    case DefaultEmbed = 1
    case InternalBrowser = 3
    
    static func from(_ ref:Any?) -> WebContentPresentationMode {
        let t = Int.intValue(from: ref) ?? 0
        return WebContentPresentationMode(rawValue: t) ?? WebContentPresentationMode.ExternalBrowser
    }
}

import SafariServices
extension BaseWebViewController {
    
    static func open(urlString:String?, mode:WebContentPresentationMode?) {
        guard let url = URL(string: urlString ?? "") else {return}
        guard let currentMode = mode else {return}
        switch currentMode {
        case .ExternalBrowser:
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            break
            
        case .DefaultEmbed:
            DispatchQueue.main.async {
                let vc = BaseWebViewController(urlString: urlString ?? "")
                let topVc = UIApplication.topViewController()
                if let nav = topVc?.navigationController {
                    nav.pushViewController(vc, animated: true)
                } else {
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .coverVertical
                    topVc?.present(vc, animated: true, completion: nil)
                }
            }
            break
            
        case .InternalBrowser:
            DispatchQueue.main.async {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = false
                let vc = SFSafariViewController(url: url, configuration: config)
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .coverVertical
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
            break
        }
    }
    
}

class BaseWebViewController: BaseViewController, WKNavigationDelegate {
    
    // MARK: - Properties
    private var url:URL?
    private var htmlString:String?
    var closeTrackEvent:Int?
    var closeTrackValue:Int?
    
    // MARK: - Objects
    private let headerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryBackground)
        return vw
    }()
    private lazy var btnClose:BackButton = {
        let btn = BackButton()
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private let loadingActivity:UIActivityIndicatorView = {
        let vw = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        vw.hidesWhenStopped = true
        return vw
    }()
    private lazy var webview:WKWebView = {
        let vw = WKWebView()
        vw.navigationDelegate = self
        vw.backgroundColor = Theme.color(.PrimaryBackground)
        vw.isOpaque = false
        return vw
    }()
    
    
    
    
    // MARK: - Methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.loadingActivity.stopAnimating()
        }
    }
    
    @objc func close() {
        if let track = self.closeTrackEvent {
            ServerManager.shared.setTrack(trackEvent: track, trackValue: self.closeTrackValue)
        }
        self.dismissAction()
    }
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let body = self.htmlString?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if body != "" {
            self.loadingActivity.startAnimating()
            self.webview.loadHTMLString(body, baseURL: nil)
            return
        }
        
        guard let urlObject = self.url else {return}
        self.loadingActivity.startAnimating()
        self.webview.load(URLRequest(url: urlObject))
    }
    
    override func prepareElements() {
        super.prepareElements()
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 10)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // Header
        self.view.insertSubview(self.headerView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.view.addBottomAlignmentRelatedConstraintTo(subView: self.headerView, reference: self.btnClose, constant: 10)
        // Webview
        self.view.addSubview(self.webview)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.webview, constant: 0)
        self.view.addBoundsConstraintsTo(subView: self.webview, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Loading
        self.view.addSubview(self.loadingActivity)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingActivity, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingActivity, constant: 0)
    }
    
    init(htmlString:String) {
        super.init()
        self.htmlString = htmlString
    }
    
    init(urlString:String) {
        super.init()
        self.url = URL(string: urlString)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
