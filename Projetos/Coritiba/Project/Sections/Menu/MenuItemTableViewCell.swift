//
//  MenuItemTableViewCell.swift
//
//
//  Created by Roberto Oliveira on 17/01/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    
    // MARK: - Objects
    private let backView:CustomGradientView = {
        let vw = CustomGradientView()
        vw.point1 = CGPoint(x: 0, y: 0)
        vw.point2 = CGPoint(x: 1, y: 0)
        return vw
    }()
    let ivIcon:ServerImageView = {
        let iv = ServerImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 14)
        return lbl
    }()
    private let ivImage:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    
    // MARK: - Methods
    func updateContent(item:MenuItem, section:MenuSection) {
        self.backgroundColor = section.backgroundColor1
        self.backView.setGradientColors(color1: section.backgroundColor1, color2: section.backgroundColor2)
        if item.type == .DynamicItem {
            self.ivIcon.setServerImage(urlString: item.imageUrlString)
        } else {
            self.ivIcon.image = UIImage(named: item.iconName)?.withRenderingMode(.alwaysTemplate)
            self.ivIcon.tintColor = section.elementsColor
        }
        self.lblTitle.textColor = section.elementsColor
        self.lblTitle.text = item.title
        if item.isIconLarge {
            self.ivImage.image = UIImage(named: item.iconName)
            self.ivImage.isHidden = false
            self.ivIcon.isHidden = true
            self.lblTitle.isHidden = true
        } else {
            self.ivImage.isHidden = true
            self.ivIcon.isHidden = false
            self.lblTitle.isHidden = false
        }
    }
    
    private func prepareElements() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        // Gradient
        self.addSubview(self.backView)
        self.addFullBoundsConstraintsTo(subView: self.backView, constant: 0)
        // Icon
        self.addSubview(self.ivIcon)
        self.addTrailingAlignmentConstraintTo(subView: self.ivIcon, constant: -30)
        self.addCenterYAlignmentConstraintTo(subView: self.ivIcon, constant: 0)
        self.ivIcon.addWidthConstraint(22)
        self.ivIcon.addHeightConstraint(22)
        // Title
        self.addSubview(self.lblTitle)
        self.addHorizontalSpacingTo(subView1: self.lblTitle, subView2: self.ivIcon, constant: 15)
        self.addCenterYAlignmentConstraintTo(subView: self.lblTitle, constant: 0)
        self.addLeadingAlignmentConstraintTo(subView: self.lblTitle, constant: 10)
        // Image
        self.addSubview(self.ivImage)
        self.addBoundsConstraintsTo(subView: self.ivImage, leading: nil, trailing: -30, top: 10, bottom: -10)
    }
    
    
    
    // MARK: - Super Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
}
