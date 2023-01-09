//
//  ShopGalleryFooterView.swift
//  
//
//  Created by Roberto Oliveira on 07/05/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class ShopGalleryFooterView: UIView {
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryButtonBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 22.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 14)
        lbl.textColor = Theme.color(.PrimaryButtonText)
        lbl.text = ProjectInfoManager.TextInfo.loja_rodape.rawValue
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.6
        return lbl
    }()
    let btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setImage(UIImage(named: "btn_close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageView?.tintColor = Theme.color(.PrimaryButtonText)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.adjustsImageWhenHighlighted = false
        btn.highlightedAlpha = 0.6
        btn.highlightedScale = 0.95
        return btn
    }()
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.containerView)
        self.addFullBoundsConstraintsTo(subView: self.containerView, constant: 0)
        self.containerView.addHeightConstraint(70)
        // close
        self.containerView.addSubview(self.btnClose)
        self.containerView.addTrailingAlignmentConstraintTo(subView: self.btnClose, constant: -10)
        self.containerView.addCenterYAlignmentConstraintTo(subView: self.btnClose, constant: 0)
        self.btnClose.addWidthConstraint(40)
        self.btnClose.addHeightConstraint(40)
        // title
        self.containerView.addSubview(self.lblTitle)
        self.containerView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 15, trailing: nil, top: 0, bottom: 0)
        self.containerView.addHorizontalSpacingTo(subView1: self.lblTitle, subView2: self.btnClose, constant: 10)
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
