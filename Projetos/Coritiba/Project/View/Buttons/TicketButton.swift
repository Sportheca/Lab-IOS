//
//  TicketButton.swift
//  
//
//  Created by Roberto Oliveira on 31/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class TicketButton: CustomButton {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryButtonBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 5.0
        vw.isUserInteractionEnabled = false
        return vw
    }()
    let ivIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = Theme.color(.PrimaryButtonText)
        iv.image = UIImage(named: "icon_ticket")?.withRenderingMode(.alwaysTemplate)
        return iv
    }()
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Medium, size: 12)
        lbl.textColor = Theme.color(.PrimaryButtonText)
        lbl.text = "Comprar Ingresso"
        return lbl
    }()
    
    
    func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.highlightedAlpha = 0.7
        self.highlightedScale = 0.95
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: 0, trailing: 0, top: 8, bottom: -8)
        self.backView.addSubview(self.ivIcon)
        self.backView.addLeadingAlignmentConstraintTo(subView: self.ivIcon, constant: 10)
        self.backView.addCenterYAlignmentConstraintTo(subView: self.ivIcon, constant: 0)
        self.ivIcon.addWidthConstraint(12)
        self.addConstraint(NSLayoutConstraint(item: self.ivIcon, attribute: .width, relatedBy: .equal, toItem: self.ivIcon, attribute: .height, multiplier: 1.0, constant: 0))
        self.backView.addSubview(self.lblTitle)
        self.addHorizontalSpacingTo(subView1: self.ivIcon, subView2: self.lblTitle, constant: 5)
        self.backView.addTrailingAlignmentConstraintTo(subView: self.lblTitle, constant: -10)
        self.backView.addCenterYAlignmentConstraintTo(subView: self.lblTitle, constant: 0)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
