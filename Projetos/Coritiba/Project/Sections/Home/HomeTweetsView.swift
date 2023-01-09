//
//  HomeTweetsView.swift
//
//
//  Created by Roberto Oliveira on 28/11/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol HomeTweetsViewDelegate:AnyObject {
    func didSelectAllTweets()
}

class HomeTweetsView: UIView {
    
    // MARK: - Properties
    weak var delegate:HomeTweetsViewDelegate?
    
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Twitter".uppercased()
        return lbl
    }()
    let loadinView:ContentLoadingView = ContentLoadingView()
    let twitterView:TwitterHorizontalFeedView = {
        let vw = TwitterHorizontalFeedView()
        vw.expandTweetEventTrack = EventTrack.Home.expandTweet
        vw.showAllTweetsEventTrack = EventTrack.Home.seeMoreTweets
        vw.loadingView.lblTitle.textColor = UIColor(R: 150, G: 150, B: 150)
        vw.loadingView.ivLogo.tintColor = UIColor(R: 150, G: 150, B: 150)
        return vw
    }()
    private lazy var btnAll:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Ver Todos", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 13)
        btn.addTarget(self, action: #selector(self.allAction), for: .touchUpInside)
        return btn
    }()
    @objc func allAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Home.openAllTweets, trackValue: TwitterFeedPosition.Home.rawValue)
        self.delegate?.didSelectAllTweets()
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Title
        self.addSubview(self.lblTitle)
        self.lblTitle.addHeightConstraint(25)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 22, trailing: nil, top: 12, bottom: nil)
        self.lblTitle.setContentCompressionResistancePriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        // See All
        self.addSubview(self.btnAll)
        self.addTrailingAlignmentConstraintTo(subView: self.btnAll, constant: -22)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.btnAll, reference: self.lblTitle, constant: 0)
        // Content
        self.addSubview(self.twitterView)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.twitterView, constant: 5)
        self.addBoundsConstraintsTo(subView: self.twitterView, leading: 0, trailing: 0, top: nil, bottom: -10)
        // Loading
        self.addSubview(self.loadinView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadinView, constant: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.loadinView, reference: self.twitterView, constant: 0)
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


