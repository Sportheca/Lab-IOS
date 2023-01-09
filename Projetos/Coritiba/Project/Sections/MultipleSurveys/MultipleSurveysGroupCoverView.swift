//
//  MultipleSurveysGroupCoverView.swift
//  
//
//  Created by Roberto Oliveira on 06/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MultipleSurveysGroupCoverView: UIView {
    
    // MARK: - Objects
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        return lbl
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 15.0
        return vw
    }()
    private let ivCover0:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let ivCover1:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    let lblX:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 24)
        lbl.text = "x"
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 16)
        return lbl
    }()
    private let lblMessage:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(item:MultipleSurveysGroup) {
        let attributedHeader = NSMutableAttributedString()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 12.0
        var title = ""
        if let date = item.endAtDate {
            title = "DISPONÍVEL ATÉ \(date.stringWith(format: "dd/MM/yyyy")) às \(date.stringWith(format: "HH:mm"))"
        }
        attributedHeader.append(NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12),
            NSAttributedString.Key.paragraphStyle : paragraph
        ]))
        let subtitle = item.title ?? ""
        attributedHeader.append(NSAttributedString(string: "\n\(subtitle)", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 18),
            NSAttributedString.Key.paragraphStyle : paragraph
        ]))
        self.lblHeader.attributedText = attributedHeader
        
        self.ivCover0.setServerImage(urlString: item.club0?.imageUrlString)
        self.ivCover1.setServerImage(urlString: item.club1?.imageUrlString)
        
        self.lblSubtitle.text = item.subtitle
        self.lblMessage.text = item.message
        self.lblX.isHidden = item.id == 0
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // header
        self.addSubview(self.lblHeader)
        // logos
        self.addSubview(self.stackView)
        self.addVerticalSpacingTo(subView1: self.lblHeader, subView2: self.stackView, constant: 15)
        self.addCenterXAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.stackView.addHeightConstraint(44)
        self.stackView.addArrangedSubview(self.ivCover0)
        self.stackView.addArrangedSubview(self.lblX)
        self.stackView.addArrangedSubview(self.ivCover1)
        self.addConstraint(NSLayoutConstraint(item: self.ivCover0, attribute: .width, relatedBy: .equal, toItem: self.ivCover0, attribute: .height, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.ivCover1, attribute: .width, relatedBy: .equal, toItem: self.ivCover1, attribute: .height, multiplier: 1.0, constant: 0))
        // subtitle
        self.addSubview(self.lblSubtitle)
        self.addVerticalSpacingTo(subView1: self.stackView, subView2: self.lblSubtitle, constant: 10)
        self.addBoundsConstraintsTo(subView: self.lblSubtitle, leading: 10, trailing: -10, top: nil, bottom: nil)
        // message
        self.addSubview(self.lblMessage)
        self.addBoundsConstraintsTo(subView: self.lblMessage, leading: 25, trailing: -25, top: nil, bottom: -5)
        
        
        
        if (UIScreen.main.bounds.height < 667) {
            self.lblMessage.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 10)
            self.addBoundsConstraintsTo(subView: self.lblHeader, leading: 10, trailing: -10, top: 5, bottom: nil)
        } else {
            self.lblMessage.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
            self.addBoundsConstraintsTo(subView: self.lblHeader, leading: 10, trailing: -10, top: 25, bottom: nil)
            self.lblMessage.addHeightConstraint(constant: 50, relatedBy: .greaterThanOrEqual, priority: 999)
        }
        
        self.lblHeader.textColor = Theme.color(.PrimaryCardElements)
        self.lblX.textColor = Theme.color(.PrimaryCardElements)
        self.lblSubtitle.textColor = Theme.color(.PrimaryCardElements)
        self.lblMessage.textColor = Theme.color(.PrimaryCardElements)
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
