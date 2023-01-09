//
//  VideoItemCell.swift
//
//
//  Created by Roberto Oliveira on 17/02/21.
//  Copyright © 2021 Roberto Oliveira. All rights reserved.
//

import UIKit

class VideoItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor(R: 200, G: 200, B: 200)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 14.0
        vw.layer.borderWidth = 1.0
        vw.layer.borderColor = UIColor(hexString: "FAD716").cgColor
        return vw
    }()
    private let ivCover:ServerImageView = {
        let vw = ServerImageView()
        vw.contentMode = .scaleAspectFill
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let gradientView:CustomGradientView = {
        let vw = CustomGradientView()
        vw.point1 = CGPoint(x: 0, y: 0.1)
        vw.point2 = CGPoint(x: 0, y: 0.9)
        vw.color1 = UIColor.clear
        vw.color2 = UIColor.black
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 14.9)
        lbl.textColor = UIColor.white
        return lbl
    }()
    private let lblTag:InsetsLabel = {
        let lbl = InsetsLabel()
        lbl.topInset = 0.0
        lbl.bottomInset = 0.0
        lbl.leftInset = 10.0
        lbl.rightInset = 10.0
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 10.0
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.font = FontsManager.customFont(key: FontsManager.Knockout.Regular, size: 12)
        lbl.textColor = Theme.color(.PrimaryButtonText)
        lbl.backgroundColor = Theme.color(.PrimaryButtonBackground)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    private let highlightedView:UIView = {
        let vw = CustomGradientView()
        vw.point1 = CGPoint(x: 0, y: -0.2)
        vw.point2 = CGPoint(x: 0, y: 1.0)
        vw.color1 = UIColor(R: 203, G: 20, B: 24)
        vw.color2 = UIColor.clear
        return vw
    }()
    private let ivHighlighted:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_video_highlighted")
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    
    
    
    
    // MARK: - Methods
    func updateContent(item:VideoItem) {
        self.ivCover.setServerImage(urlString: item.imageUrl)
        self.lblTitle.text = item.title
        self.lblTag.text = item.tagTitle
        self.highlightedView.isHidden = !item.isDigitalMembershipOnly
    }
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.containerView)
        self.addBoundsConstraintsTo(subView: self.containerView, leading: 0, trailing: 0, top: 0, bottom: 0)
        self.containerView.addSubview(self.ivCover)
        self.containerView.addFullBoundsConstraintsTo(subView: self.ivCover, constant: 0)
        self.containerView.addSubview(self.gradientView)
        self.containerView.addBoundsConstraintsTo(subView: self.gradientView, leading: 0, trailing: 0, top: 0, bottom: 0)
        // cover
        self.containerView.addSubview(self.highlightedView)
        self.containerView.addBoundsConstraintsTo(subView: self.highlightedView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.highlightedView.addHeightConstraint(40)
        self.highlightedView.addSubview(self.ivHighlighted)
        self.ivHighlighted.addHeightConstraint(31)
        self.highlightedView.addBoundsConstraintsTo(subView: self.ivHighlighted, leading: 0, trailing: 0, top: 0, bottom: nil)
        
        // title
        self.containerView.addSubview(self.lblTitle)
        self.containerView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 10, trailing: -10, top: nil, bottom: -15)
        // tag
        self.containerView.addSubview(self.lblTag)
        self.containerView.addLeadingAlignmentRelatedConstraintTo(subView: self.lblTag, reference: self.lblTitle, constant: 0)
        self.containerView.addTrailingAlignmentRelatedConstraintTo(subView: self.lblTag, reference: self.lblTitle, relatedBy: .lessThanOrEqual, constant: 0, priority: 999)
        self.containerView.addVerticalSpacingTo(subView1: self.lblTag, subView2: self.lblTitle, constant: 8)
        self.lblTag.addHeightConstraint(20)
        self.lblTag.addWidthConstraint(constant: 70, relatedBy: .greaterThanOrEqual, priority: 999)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepareElements()
    }
    
}

