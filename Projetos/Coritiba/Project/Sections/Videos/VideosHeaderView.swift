//
//  VideosHeaderView.swift
//
//
//  Created by Roberto Oliveira on 17/02/21.
//  Copyright © 2021 Roberto Oliveira. All rights reserved.
//

import UIKit

class VideosHeaderView: UIView {
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 21)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Destaques"
        return lbl
    }()
    private let lblMessage:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.textColor = Theme.color(.PrimaryText)
        let attributed = NSMutableAttributedString()
        attributed.append(NSAttributedString(string: "Tenha acesso a ", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 14)
        ]))
        attributed.append(NSAttributedString(string: "conteúdos exclusivos", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        ]))
        attributed.append(NSAttributedString(string: " para ficar por dentro de tudo que acontece no Mengão!", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        ]))
        lbl.attributedText = attributed
        return lbl
    }()
//    let btnDigitalMembership:DigitalMembershipCTAButton = DigitalMembershipCTAButton()
    
    
    // MARK: - Methods
    func updateContent(title:String) {
        self.lblTitle.text = title
//        self.lblMessage.text = message
//        self.btnDigitalMembership.isHidden = ServerManager.shared.user?.isDigitalMembership == true
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 22, trailing: -22, top: 20, bottom: 0)
//        self.addSubview(self.lblMessage)
//        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.lblMessage, constant: 8)
//        self.addBoundsConstraintsTo(subView: self.lblMessage, leading: 22, trailing: -22, top: nil, bottom: -20)
//        self.addSubview(self.btnDigitalMembership)
//        self.addBottomAlignmentConstraintTo(subView: self.btnDigitalMembership, constant: -20)
//        self.addVerticalSpacingTo(subView1: self.lblMessage, subView2: self.btnDigitalMembership, constant: 20)
//        self.addCenterXAlignmentConstraintTo(subView: self.btnDigitalMembership, constant: 0)
//        self.btnDigitalMembership.addHeightConstraint(30)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepareElements()
    }
    
}


