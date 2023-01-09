//
//  RankingItemView.swift
//  
//
//  Created by Roberto Oliveira on 13/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class RankingItemView: UIView {
    
    static let defaultHeight:CGFloat = 55.0
    
    // MARK: - Objects
    let lblPosition:InsetsLabel = {
        let lbl = InsetsLabel()
        lbl.leftInset = 3.0
        lbl.rightInset = 3.0
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        lbl.textAlignment = .center
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 12.0
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    private let btnAvatar:AvatarButton = {
        let btn = AvatarButton()
        btn.isUserInteractionEnabled = false
        return btn
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 0.0
        return vw
    }()
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    let lblScore:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    
    
    
    // MARK: - Methods
    func updateContent(item:RankingItem?, isHighlighted:Bool) {
        self.lblPosition.backgroundColor = isHighlighted ? Theme.color(.PrimaryButtonBackground) : Theme.color(.PrimaryCardBackground)
        self.lblPosition.textColor = isHighlighted ? Theme.color(.PrimaryButtonText) : Theme.color(.PrimaryCardElements)
        guard let object = item else {
            self.btnAvatar.updateContent(imgUrl: nil)
            self.lblPosition.text = ""
            self.lblTitle.text = ""
            self.lblSubtitle.text = ""
            self.lblScore.text = ""
            return
        }
        self.btnAvatar.updateContent(imgUrl: object.imageUrlString)
        self.lblPosition.text = object.rankPosition.descriptionWithPostfix()
        self.lblTitle.text = object.title
        self.lblSubtitle.text = object.subtitle
        self.lblScore.text = object.score.descriptionWithPostfix()
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // avatar
        self.addSubview(self.btnAvatar)
        self.addLeadingAlignmentConstraintTo(subView: self.btnAvatar, constant: 30)
        self.addCenterYAlignmentConstraintTo(subView: self.btnAvatar, constant: 0)
        self.btnAvatar.addHeightConstraint(40)
        self.btnAvatar.addWidthConstraint(40)
        // position
        self.addSubview(self.lblPosition)
        self.lblPosition.addHeightConstraint(24)
        self.lblPosition.addWidthConstraint(constant: 24, relatedBy: .greaterThanOrEqual, priority: 999)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.lblPosition, reference: self.btnAvatar, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.lblPosition, subView2: self.btnAvatar, constant: -10)
        // score
        self.addSubview(self.lblScore)
        self.addTrailingAlignmentConstraintTo(subView: self.lblScore, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.lblScore, constant: 0)
        self.lblScore.addWidthConstraint(70)
        // info
        self.addSubview(self.stackView)
        self.addCenterYAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.btnAvatar, subView2: self.stackView, constant: 10)
        self.addHorizontalSpacingTo(subView1: self.stackView, subView2: self.lblScore, constant: 0)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.lblSubtitle)
        
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
