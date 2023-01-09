//
//  MenuHeaderView.swift
//  
//
//  Created by Roberto Oliveira on 31/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MenuHeaderView: UIView {
    
    // MARK: - Objects
    private let avatarShadowContainer:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        vw.layer.shadowColor = UIColor(R: 35, G: 32, B: 32).cgColor
        vw.layer.shadowOpacity = 0.2
        vw.layer.shadowRadius = 20.0
        vw.layer.shadowOffset = CGSize(width: 0, height: 20)
        return vw
    }()
    let btnAvatar:AvatarButton = AvatarButton()
    private let infoStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 16)
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Normal, size: 13)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent() {
        guard let user = ServerManager.shared.user else {return}
        self.btnAvatar.updateWithCurrentUserImage()
        self.lblTitle.text = user.name
        self.lblSubtitle.text = user.membershipTitle()
    }
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Avatar
        self.addSubview(self.avatarShadowContainer)
        self.addFullBoundsConstraintsTo(subView: self.avatarShadowContainer, constant: 0)
        self.avatarShadowContainer.addSubview(self.btnAvatar)
        self.avatarShadowContainer.isUserInteractionEnabled = true
        self.addCenterYAlignmentConstraintTo(subView: self.btnAvatar, constant: 0)
        self.addTrailingAlignmentConstraintTo(subView: self.btnAvatar, constant: -30)
        self.btnAvatar.addHeightConstraint(60)
        self.btnAvatar.addWidthConstraint(60)
        // Infos
        self.addSubview(self.infoStackView)
        self.addLeadingAlignmentConstraintTo(subView: self.infoStackView, constant: 20)
        self.addHorizontalSpacingTo(subView1: self.infoStackView, subView2: self.btnAvatar, constant: 15)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.infoStackView, reference: self.btnAvatar, constant: 0)
        self.infoStackView.addArrangedSubview(self.lblTitle)
        self.infoStackView.addArrangedSubview(self.lblSubtitle)
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
