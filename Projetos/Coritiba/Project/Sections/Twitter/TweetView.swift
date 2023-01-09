//
//  TweetView2.swift
//
//
//  Created by Roberto Oliveira on 21/06/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit
import AVFoundation

class TweetView: UIView {
    
    // MARK: - Properties
    private var currentItem:TweetItem?
    
    
    
    // MARK: - Transition
    func openFullScreen() {
        guard let topVc = UIApplication.topViewController(), let item = self.currentItem else {return}
        DispatchQueue.main.async {
            let vc = FullScreenTweetViewController(item: item, referenceView: self)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            topVc.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    
    // MARK: - Objects
    let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.TwitterCardBackground)
        vw.layer.cornerRadius = 5.0
        vw.layer.shadowOpacity = 0.25
        vw.layer.shadowRadius = 2.0
        vw.layer.shadowOffset = CGSize.zero
        return vw
    }()
    private let ivAvatar:ServerImageView = {
        let iv = ServerImageView()
        iv.backgroundColor = Theme.color(.PrimaryBackground)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    private let lblAuthorName:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        lbl.textColor = Theme.color(.TwitterCardPrimaryText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblAuthorAccount:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        lbl.textColor = Theme.color(.TwitterCardMutedText)
        return lbl
    }()
    private let lblDate:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        lbl.textColor = Theme.color(.TwitterCardMutedText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    let lblText:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        lbl.textColor = Theme.color(.TwitterCardPrimaryText)
        lbl.frame = CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.size.width-30)-20, height: 10)
        return lbl
    }()
    let lblMore:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular)
        lbl.textColor = Theme.color(.TwitterCardAnchor)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        lbl.text = "ler mais..."
        lbl.isHidden = true
        return lbl
    }()
    private let mediaContainer:TweetMediaView = {
        let vw = TweetMediaView()
        vw.layer.cornerRadius = 5.0
        vw.clipsToBounds = true
        return vw
    }()
    
    
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(tweet: TweetItem) {
        self.currentItem = tweet
        // Reset
        
        // Update
        self.currentItem = tweet
        self.ivAvatar.setServerImage(urlString: tweet.authorImageUrl)
        self.lblAuthorName.text = tweet.authorName
        self.lblAuthorAccount.text = tweet.authorAccount
        self.lblDate.text = tweet.date.timeAgoDescription()
        self.lblText.text = tweet.text
        self.lblText.frame.size.width = min(UIScreen.main.bounds.size.width-30, 345) - 30
        self.lblMore.isHidden = !self.lblText.isTruncated
        self.mediaContainer.updateContent(item: tweet)
        
    }
    
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Container
        self.addSubview(self.containerView)
        self.addFullBoundsConstraintsTo(subView: self.containerView, constant: 5)
        // Avatar
        self.containerView.addSubview(self.ivAvatar)
        self.containerView.addBoundsConstraintsTo(subView: self.ivAvatar, leading: 8, trailing: nil, top: 8, bottom: nil)
        self.ivAvatar.addWidthConstraint(40)
        self.ivAvatar.addHeightConstraint(40)
        // Author Name
        self.containerView.addSubview(self.lblAuthorName)
        self.containerView.addHorizontalSpacingTo(subView1: self.ivAvatar, subView2: self.lblAuthorName, constant: 7)
        self.containerView.addTopAlignmentRelatedConstraintTo(subView: self.lblAuthorName, reference: self.ivAvatar, constant: 0)
        self.lblAuthorName.addHeightConstraint(20)
        // Author Account
        self.containerView.addSubview(self.lblAuthorAccount)
        self.containerView.addVerticalSpacingTo(subView1: self.lblAuthorName, subView2: self.lblAuthorAccount, constant: 0)
        self.containerView.addLeadingAlignmentRelatedConstraintTo(subView: self.lblAuthorAccount, reference: self.lblAuthorName, constant: 0)
        self.containerView.addTrailingAlignmentRelatedConstraintTo(subView: self.lblAuthorAccount, reference: self.lblAuthorName, constant: 0)
        self.lblAuthorAccount.addHeightConstraint(20)
        // Date
        self.containerView.addSubview(self.lblDate)
        self.containerView.addTopAlignmentRelatedConstraintTo(subView: self.lblDate, reference: self.lblAuthorName, constant: 0)
        self.containerView.addHorizontalSpacingTo(subView1: self.lblAuthorName, subView2: self.lblDate, relatedBy: .greaterThanOrEqual, constant: 2.0, priority: 999)
        self.containerView.addTrailingAlignmentConstraintTo(subView: self.lblDate, constant: -5)
        self.lblDate.addWidthConstraint(90)
        self.lblDate.addHeightConstraint(20)
        // Text
        self.containerView.addSubview(self.lblText)
        self.addVerticalSpacingTo(subView1: self.ivAvatar, subView2: self.lblText, constant: 8)
        self.containerView.addBoundsConstraintsTo(subView: self.lblText, leading: 10, trailing: -10, top: nil, bottom: nil)
        // More
        self.containerView.addSubview(self.lblMore)
        self.containerView.addVerticalSpacingTo(subView1: self.lblText, subView2: self.lblMore, constant: 2)
        self.addTrailingAlignmentConstraintTo(subView: self.lblMore, constant: -10)
        self.lblMore.addHeightConstraint(10)
        // Media Container
        self.containerView.addSubview(self.mediaContainer)
        self.addVerticalSpacingTo(subView1: self.lblMore, subView2: self.mediaContainer, constant: 2)
        self.containerView.addBoundsConstraintsTo(subView: self.mediaContainer, leading: 5, trailing: -5, top: nil, bottom: -10)
        self.mediaContainer.addHeightConstraint(200)
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




