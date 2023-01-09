//
//  FullScreenTweetViewController.swift
//
//
//  Created by Roberto Oliveira on 22/06/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class FullScreenTweetViewController: UIViewController {
    
    // MARK: - Properties
    var currentItem:TweetItem!
    var referenceView:UIView?
    
    
    // MARK: - Objects
    private lazy var blurView:UIVisualEffectView = {
        let vw = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        vw.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeMethod)))
        return vw
    }()
    @objc func closeMethod() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    var contentView:TweetView = {
        let vw = TweetView()
        vw.lblText.numberOfLines = 0
        return vw
    }()
    
    
    
    
    
    
    // MARK: - Init Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentView.alpha = 1
        self.view.layoutIfNeeded()
    }
    
    private func prepareElements() {
        self.view.backgroundColor = UIColor.clear
        // Blur View
        self.view.addSubview(self.blurView)
        self.view.addFullBoundsConstraintsTo(subView: self.blurView, constant: 0)
        // Content View
        self.view.addSubview(self.contentView)
        let contentWidth = min(UIScreen.main.bounds.size.width-30, 345)
        self.contentView.addWidthConstraint(contentWidth)
        self.view.addCenterXAlignmentConstraintTo(subView: self.contentView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.contentView, constant: 0)
        self.contentView.lblText.frame = CGRect(x: 0, y: 0, width: contentWidth-30, height: 10)
        self.contentView.updateContent(tweet: self.currentItem)
        let height = 290 + self.contentView.lblText.contentHeight()
        self.contentView.addHeightConstraint(min(UIScreen.main.bounds.height-100, height))
        self.contentView.lblMore.isHidden = true
        self.contentView.alpha = 0
    }
    
    init(item:TweetItem, referenceView:UIView?) {
        super.init(nibName: nil, bundle: nil)
        self.currentItem = item
        self.referenceView = referenceView
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
