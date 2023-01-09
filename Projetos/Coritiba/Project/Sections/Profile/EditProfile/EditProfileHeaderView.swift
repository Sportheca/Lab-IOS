//
//  EditProfileHeaderView.swift
//
//
//  Created by Roberto Oliveira on 23/08/18.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit

protocol EditProfileHeaderViewDelegate {
    func updateAvatar()
}

class EditProfileHeaderView: UIView {
    
    // MARK: - Properties
    var delegate:EditProfileHeaderViewDelegate?
    
    
    // MARK: - Objects
    private let avatarShadowContainer:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        vw.layer.shadowColor = Theme.color(.MutedText).cgColor
        vw.layer.shadowOpacity = 0.2
        vw.layer.shadowRadius = 20.0
        vw.layer.shadowOffset = CGSize(width: 0, height: 20)
        return vw
    }()
    lazy var btnAvatar:AvatarButton = {
        let btn = AvatarButton()
        btn.addTarget(self, action: #selector(self.avatarAction), for: .touchUpInside)
        return btn
    }()
    lazy var btnChangePhoto:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = UIColor.clear
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.setTitle("Alterar\nFoto", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.addTarget(self, action: #selector(self.avatarAction), for: .touchUpInside)
        if let lbl = btn.titleLabel {
            lbl.numberOfLines = 2
            lbl.textAlignment = .center
            lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 12)
        }
        return btn
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 18)
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Normal, size: 13)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    @objc func avatarAction() {
        self.delegate?.updateAvatar()
    }
    private let bottomSeparator:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.MutedText)
        return vw
    }()
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent() {
        let user = ServerManager.shared.user
        self.btnAvatar.updateWithCurrentUserImage()
        self.lblTitle.text = user?.name
        self.lblSubtitle.text = user?.membershipTitle()
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Avatar
        self.addSubview(self.avatarShadowContainer)
        self.addFullBoundsConstraintsTo(subView: self.avatarShadowContainer, constant: 0)
        self.avatarShadowContainer.addSubview(self.btnAvatar)
        self.avatarShadowContainer.isUserInteractionEnabled = true
        self.addCenterXAlignmentConstraintTo(subView: self.btnAvatar, constant: 0)
        self.addBoundsConstraintsTo(subView: self.btnAvatar, leading: nil, trailing: nil, top: 70, bottom: nil)
        // Change Photo
        self.addSubview(self.btnChangePhoto)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.btnChangePhoto, reference: self.btnAvatar, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.btnAvatar, subView2: self.btnChangePhoto, constant: 2)
        self.btnChangePhoto.addWidthConstraint(70)
        self.btnChangePhoto.addHeightConstraint(40)
        // Title
        self.addSubview(self.lblTitle)
        self.addVerticalSpacingTo(subView1: self.btnAvatar, subView2: self.lblTitle, constant: 20)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 0, trailing: 0, top: nil, bottom: nil)
        // Subtitle
        self.addSubview(self.lblSubtitle)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.lblSubtitle, constant: 0)
        self.addBoundsConstraintsTo(subView: self.lblSubtitle, leading: 0, trailing: 0, top: nil, bottom: -20)
        
        
        
        if UIScreen.main.bounds.height < 667 {
            self.btnAvatar.addHeightConstraint(80)
            self.btnAvatar.addWidthConstraint(80)
        } else {
            self.btnAvatar.addHeightConstraint(100)
            self.btnAvatar.addWidthConstraint(100)
        }
        
        self.updateContent()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

