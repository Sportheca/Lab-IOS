//
//  HomeVideoView.swift
//
//
//  Created by Roberto Oliveira on 30/06/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit
import WebKit

struct HomeVideoItem {
    var id:Int
    var urlString:String
    var headerImage:UIImage?
}

class HomeVideoView: UIView {
    
    // MARK: - Properties
    var currentItem:HomeVideoItem?
    
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    let loadingView:ContentLoadingView = ContentLoadingView()
    private let ivHeader:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let webView:WKWebView = {
        let vw = WKWebView()
        vw.isOpaque = false
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    
    
    
    // MARK: - Methods
    func updateContent(item:HomeVideoItem?) {
        self.ivHeader.image = item?.headerImage
        
        let size = item?.headerImage?.size ?? CGSize.zero
        let height:CGFloat = 22.0
        let width:CGFloat = (size.height == 0) ? 0 : (height*size.width) / size.height
        self.ivHeader.frame = CGRect(x: 22, y: 5, width: width, height: height)
        
        guard let url = URL(string: item?.urlString ?? "") else {
            self.webView.loadHTMLString("", baseURL: nil)
            return
        }
        self.webView.load(URLRequest(url: url))
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Stack
        self.addSubview(self.containerView)
        self.addBoundsConstraintsTo(subView: self.containerView, leading: 0, trailing: 0, top: 10, bottom: -10)
        // Header
        self.containerView.addSubview(self.ivHeader)
        // Web
        self.containerView.addSubview(self.webView)
        let videoHeightConstraint = NSLayoutConstraint(item: self.webView, attribute: .height, relatedBy: .equal, toItem: self.webView, attribute: .width, multiplier: 0.6, constant: 0)
        videoHeightConstraint.priority = UILayoutPriority(750)
        self.addConstraint(videoHeightConstraint)
        self.containerView.addBoundsConstraintsTo(subView: self.webView, leading: 0, trailing: 0, top: 40, bottom: -10)
        // Loading
        self.containerView.addSubview(self.loadingView)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.containerView.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}
