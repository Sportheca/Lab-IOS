//
//  ShopGalleryItemCell.swift
//  
//
//  Created by Roberto Oliveira on 30/04/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class ShopGalleryItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.layer.cornerRadius = 15.0
        vw.clipsToBounds = true
        return vw
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.backgroundColor = Theme.color(.PrimaryCardBackground)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 14)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    private let lblInfo0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    private let lblInfo1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    
    
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(item:ShopGalleryItem) {
        self.ivCover.setServerImage(urlString: item.imageUrlString)
        self.lblTitle.text = item.title
        
        let attributed0:NSMutableAttributedString = NSMutableAttributedString()
        if let membersPrice = item.membersPrice {
            attributed0.append(NSAttributedString(string: membersPrice.moneyFormatBRL(), attributes: [
                NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Apex.Bold, size: 18),
                NSAttributedString.Key.foregroundColor : Theme.color(.PrimaryCardElements)
            ]))
            attributed0.append(NSAttributedString(string: "\nPara sócio torcedor", attributes: [
                NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Apex.Bold, size: 10),
                NSAttributedString.Key.foregroundColor : Theme.color(.PrimaryCardElements)
            ]))
            self.lblInfo0.isHidden = false
            self.lblInfo0.attributedText = attributed0
        } else {
            self.lblInfo0.isHidden = true
            self.lblInfo0.attributedText = attributed0
        }
        
        let attributed1:NSMutableAttributedString = NSMutableAttributedString()
        let priceTitle = item.membersPrice == nil ? item.price.moneyFormatBRL() : "ou \(item.price.moneyFormatBRL())"
        let priceSice:CGFloat = item.membersPrice == nil ? 18 : 13
        attributed1.append(NSAttributedString(string: priceTitle, attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Apex.Bold, size: priceSice),
            NSAttributedString.Key.foregroundColor : Theme.color(.PrimaryCardElements)
        ]))
        if item.description != "" {
            attributed1.append(NSAttributedString(string: "\n"+item.description, attributes: [
                NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Knockout.Regular, size: 10),
                NSAttributedString.Key.foregroundColor : Theme.color(.MutedText)
            ]))
        }
        self.lblInfo1.attributedText = attributed1
        
    }
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Back View
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: 5, trailing: -5, top: 5, bottom: -5)
        // Cover
        self.backView.addSubview(self.ivCover)
        self.backView.addBoundsConstraintsTo(subView: self.ivCover, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.backView.addConstraint(NSLayoutConstraint(item: self.ivCover, attribute: .height, relatedBy: .equal, toItem: self.ivCover, attribute: .width, multiplier: 0.85, constant: 0))
        // Infos
        self.backView.addSubview(self.stackView)
        self.backView.addVerticalSpacingTo(subView1: self.ivCover, subView2: self.stackView, constant: 5)
        self.backView.addBoundsConstraintsTo(subView: self.stackView, leading: 8, trailing: -8, top: nil, bottom: -5)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.lblInfo0)
        self.stackView.addArrangedSubview(self.lblInfo1)
        self.lblTitle.addHeightConstraint(constant: 45, relatedBy: .equal, priority: 999)
        self.lblInfo0.addHeightConstraint(constant: 45, relatedBy: .equal, priority: 999)
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



