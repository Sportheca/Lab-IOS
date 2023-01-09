//
//  AllNewsItemCell.swift
//
//
//  Created by Roberto Oliveira on 02/12/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class AllNewsItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.white//Theme.color(.PrimaryCardBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.backgroundColor = Theme.color(.MutedText)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 0.0
        return vw
    }()
    private let lblDate:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Knockout.Regular, size: 14)
        lbl.textColor = UIColor(hexString: "48535A")
        return lbl
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 22)
        lbl.textColor = UIColor(hexString: "48535A")
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 15)
        lbl.textColor = UIColor(hexString: "48535A")
        return lbl
    }()
    private let tagBackView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryButtonBackground)
        vw.layer.borderWidth = 1.0
        vw.layer.borderColor = UIColor(hexString: "FFFFFF").cgColor
        vw.layer.cornerRadius = 25/2
        return vw
    }()
    private let lblTag:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Knockout.Regular, size: 14)
        lbl.textColor = Theme.color(.PrimaryButtonText)
        return lbl
    }()
    
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(item:AllNewsItem) {
        // Cover
        self.ivCover.setServerImage(urlString: item.imageUrl)
        self.lblTitle.text = item.title
        self.lblSubtitle.text = item.subtitle
        self.lblTag.text = item.category
        self.tagBackView.isHidden = (item.category ?? "") == ""
        var dateDescription:String = ""
        if let value = item.date {
            dateDescription = value.stringWith(format: "dd") + " de " + value.monthDescription(short: false)
        }
        self.lblDate.text = dateDescription
    }
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Container
        self.addSubview(self.containerView)
        self.addBoundsConstraintsTo(subView: self.containerView, leading: 0, trailing: 0, top: 0, bottom: 0)
        self.containerView.addSubview(self.backView)
        self.containerView.addBoundsConstraintsTo(subView: self.backView, leading: nil, trailing: nil, top: 0, bottom: 0)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.backView, constant: 0)
        self.backView.addWidthConstraint(constant: 900, relatedBy: .lessThanOrEqual, priority: 999)
        self.containerView.addLeadingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: 10, priority: 900)
        self.containerView.addTrailingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: -10, priority: 900)
        // Cover
        self.backView.addSubview(self.ivCover)
        self.backView.addBoundsConstraintsTo(subView: self.ivCover, leading: 0, trailing: 0, top: 0, bottom: -120)
        // Date
        self.backView.addSubview(self.stackView)
        self.backView.addVerticalSpacingTo(subView1: self.ivCover, subView2: self.stackView, constant: 15)
        self.backView.addBoundsConstraintsTo(subView: self.stackView, leading: 15, trailing: -15, top: nil, bottom: -10)
        self.stackView.addArrangedSubview(self.lblDate)
        // title
        self.stackView.addArrangedSubview(self.lblTitle)
        self.lblTitle.addHeightConstraint(40)
        // subtitle
        self.stackView.addArrangedSubview(self.lblSubtitle)
        self.lblSubtitle.addHeightConstraint(40)
        // taag
        self.backView.addSubview(self.tagBackView)
        self.backView.addTrailingAlignmentConstraintTo(subView: self.tagBackView, constant: -14)
        self.tagBackView.addHeightConstraint(25)
        self.tagBackView.addSubview(self.lblTag)
        self.tagBackView.addBoundsConstraintsTo(subView: self.lblTag, leading: 12, trailing: -12, top: 0, bottom: 0)
        self.addConstraint(NSLayoutConstraint(item: self.tagBackView, attribute: .centerY, relatedBy: .equal, toItem: self.ivCover, attribute: .bottom, multiplier: 1.0, constant: 0))
    }
    
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}

