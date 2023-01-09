//
//  UserProfileHeaderView.swift
//
//
//  Created by Roberto Oliveira on 20/08/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UIView {
    
    // MARK: - Objects
    let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.layer.shadowRadius = 5.0
        vw.layer.shadowOpacity = 0.3
        vw.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        vw.layer.cornerRadius = 20.0
        vw.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return vw
    }()
    private let topSeparator:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardElements).withAlphaComponent(0.5)
        return vw
    }()
    let btnAvatar:AvatarButton = AvatarButton()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 18)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Normal, size: 13)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    private let lblFooter:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 14)
        lbl.textColor = Theme.color(.PrimaryAnchor)
        lbl.text = "MEDALHAS"
        return lbl
    }()
    private let scoreStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 2.0
        return vw
    }()
    private let lblScore:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .right
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let ivCoin:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon_coin")
        return iv
    }()
    let btnSettings:CustomButton = {
        let btn = CustomButton()
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor.clear
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.setImage(UIImage(named: "icon_settings")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = Theme.color(.PrimaryCardElements)
        btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return btn
    }()
    let btnMembershipCardID:IconButton = {
        let btn = IconButton(iconLeading: 0, iconTop: 5, iconBottom: -5, horizontalSpacing: 5, titleTrailing: 0, titleTop: 0, titleBottom: 0)
        btn.lblTitle.numberOfLines = 2
        btn.lblTitle.textColor = Theme.color(.PrimaryAnchor)
        btn.lblTitle.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 10)
        return btn
    }()
    
    
    
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent() {
        guard let user = ServerManager.shared.user else {return}
        self.btnAvatar.updateWithCurrentUserImage()
        self.lblTitle.text = user.name
        self.lblSubtitle.text = user.membershipTitle()
        
        let coins = user.coins ?? 0
        let attributed = NSMutableAttributedString()
        attributed.append(NSAttributedString(string: coins.descriptionWithThousandsSeparator(), attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 16)
        ]))
        let coinTitle = coins == 1 ? "Moeda" : "Moedas"
        attributed.append(NSAttributedString(string: "\n\(coinTitle)", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 10)
        ]))
        self.lblScore.attributedText = attributed
        
        
        // CARD ID
        let img = UIImage(named: "side_menu_9")?.withRenderingMode(.alwaysTemplate)
        if user.isMembershipCardIDCompleted() {
            self.btnMembershipCardID.updateContent(icon: img, title: "Ver Carteirinha\nTorcedor de Coração")
            self.btnMembershipCardID.ivIcon.tintColor = Theme.color(.PrimaryAnchor)
            self.btnMembershipCardID.isHidden = true
        } else {
            self.btnMembershipCardID.updateContent(icon: img, title: "Complete seu cadastro\ne libere sua carteirinha")
            self.btnMembershipCardID.ivIcon.tintColor = Theme.color(.MutedText)
            self.btnMembershipCardID.isHidden = true
        }
        
    }
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Back
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: 0, trailing: 0, top: nil, bottom: -5)
        // Settings
        self.addSubview(self.btnSettings)
        self.addBoundsConstraintsTo(subView: self.btnSettings, leading: nil, trailing: -5, top: 10, bottom: nil)
        self.btnSettings.addHeightConstraint(35)
        self.btnSettings.addWidthConstraint(35)
        // Score
        self.addSubview(self.scoreStackView)
        self.scoreStackView.isUserInteractionEnabled = false
        self.addHorizontalSpacingTo(subView1: self.scoreStackView, subView2: self.btnSettings, constant: 10)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.scoreStackView, reference: self.btnSettings, constant: 0)
        self.scoreStackView.addArrangedSubview(self.lblScore)
        self.lblScore.addWidthConstraint(100)
        self.scoreStackView.addArrangedSubview(self.ivCoin)
        self.ivCoin.addHeightConstraint(25)
        self.ivCoin.addWidthConstraint(25)
        // Top Separator
        self.addSubview(self.topSeparator)
        self.addVerticalSpacingTo(subView1: self.btnSettings, subView2: self.topSeparator, constant: 10)
        self.addBoundsConstraintsTo(subView: self.topSeparator, leading: 20, trailing: -20, top: nil, bottom: nil)
        self.topSeparator.addHeightConstraint(1)
        // Avatar
        self.addSubview(self.btnAvatar)
        self.addVerticalSpacingTo(subView1: self.topSeparator, subView2: self.btnAvatar, constant: 10)
        self.addLeadingAlignmentConstraintTo(subView: self.btnAvatar, constant: 20)
        // Title
        self.addSubview(self.lblTitle)
        self.addHorizontalSpacingTo(subView1: self.btnAvatar, subView2: self.lblTitle, constant: 20)
        self.addTopAlignmentRelatedConstraintTo(subView: self.lblTitle, reference: self.btnAvatar, constant: 10)
        self.addTrailingAlignmentConstraintTo(subView: self.lblTitle, constant: -20)
        // Subtitle
        self.addSubview(self.lblSubtitle)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.lblSubtitle, constant: 0)
        self.addLeadingAlignmentRelatedConstraintTo(subView: self.lblSubtitle, reference: self.lblTitle, constant: 0)
        self.addTrailingAlignmentRelatedConstraintTo(subView: self.lblSubtitle, reference: self.lblTitle, constant: 0)
        // Membership Card ID
        self.addSubview(self.btnMembershipCardID)
        self.addVerticalSpacingTo(subView1: self.lblSubtitle, subView2: self.btnMembershipCardID, constant: 10)
        self.addLeadingAlignmentRelatedConstraintTo(subView: self.btnMembershipCardID, reference: self.lblSubtitle, constant: 0)
        self.btnMembershipCardID.addHeightConstraint(35)
        
        // Footer
        self.backView.addSubview(self.lblFooter)
        self.addVerticalSpacingTo(subView1: self.btnAvatar, subView2: self.lblFooter, constant: 30)
        self.backView.addBoundsConstraintsTo(subView: self.lblFooter, leading: 10, trailing: -10, top: nil, bottom: -8)
        
        if UIScreen.main.bounds.height < 667 {
            self.btnAvatar.addHeightConstraint(70)
            self.btnAvatar.addWidthConstraint(70)
        } else {
            self.btnAvatar.addHeightConstraint(90)
            self.btnAvatar.addWidthConstraint(90)
        }
        
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

