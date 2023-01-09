//
//  MenuSectionHeaderView.swift
//
//
//  Created by Roberto Oliveira on 01/06/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol MenuSectionHeaderViewDelegate:AnyObject {
    func menuSectionHeaderView(menuSectionHeaderView:MenuSectionHeaderView, didTapHeaderAtSection section:Int)
}

class MenuSectionHeaderView: UIView {
    
    // MARK: - Properties
    weak var delegate:MenuSectionHeaderViewDelegate?
    var currentSection:Int?
    
    
    // MARK: - Objects
    private let backView:CustomGradientView = {
        let vw = CustomGradientView()
        vw.point1 = CGPoint(x: 0, y: 0)
        vw.point2 = CGPoint(x: 1, y: 0)
        return vw
    }()
    let ivDisclosure:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "disclosure_up")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let ivIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        return lbl
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = UIColor.clear
        btn.highlightedAlpha = 0.5
        btn.highlightedScale = 1.0
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    
    
    
    // MARK: - Methods
    func updateContent(section:MenuSection) {
        self.backgroundColor = section.backgroundColor1
        self.backView.setGradientColors(color1: section.backgroundColor1, color2: section.backgroundColor2)
        self.ivDisclosure.tintColor = section.elementsColor
        self.lblTitle.text = section.headerTitle
        self.lblTitle.textColor = section.elementsColor
        self.ivIcon.image = UIImage(named: section.headerImageName ?? "")
    }
    
    @objc func confirm() {
        guard let section = self.currentSection else {return}
        self.delegate?.menuSectionHeaderView(menuSectionHeaderView: self, didTapHeaderAtSection: section)
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Gradient
        self.addSubview(self.backView)
        self.addFullBoundsConstraintsTo(subView: self.backView, constant: 0)
        // Button
        self.addSubview(self.btnConfirm)
        self.addFullBoundsConstraintsTo(subView: self.btnConfirm, constant: 0)
        // disclosure
        self.btnConfirm.addSubview(self.ivDisclosure)
        self.ivDisclosure.addWidthConstraint(17)
        self.ivDisclosure.addHeightConstraint(11)
        self.addCenterYAlignmentConstraintTo(subView: self.ivDisclosure, constant: 0)
        self.addLeadingAlignmentConstraintTo(subView: self.ivDisclosure, constant: 24)
        // title
        self.btnConfirm.addSubview(self.lblTitle)
        self.addCenterYAlignmentConstraintTo(subView: self.lblTitle, constant: 0)
        self.addTrailingAlignmentConstraintTo(subView: self.lblTitle, constant: -30)
        self.addHorizontalSpacingTo(subView1: self.ivDisclosure, subView2: self.lblTitle, constant: 10)
        // Icon
        self.btnConfirm.addSubview(self.ivIcon)
        self.addBoundsConstraintsTo(subView: self.ivIcon, leading: nil, trailing: -30, top: 10, bottom: -10)
        
        self.ivDisclosure.isUserInteractionEnabled = false
        self.lblTitle.isUserInteractionEnabled = false
        self.ivIcon.isUserInteractionEnabled = false
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
