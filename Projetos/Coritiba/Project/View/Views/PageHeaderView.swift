//
//  PageHeaderView.swift
//  
//
//  Created by Roberto Oliveira on 13/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class PageHeaderView: UIView {
    
    // MARK: - Objects
    private let backgroundView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(Theme.Color.PageHeaderBackground)
        vw.layer.cornerRadius = 25.0
        vw.clipsToBounds = true
        vw.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return vw
    }()
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.textColor = Theme.color(Theme.Color.PageHeaderText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.3
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 14)
        lbl.textColor = Theme.color(Theme.Color.PageHeaderText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(title:String?, subtitle:String?) {
        self.lblTitle.text = title
        self.lblSubtitle.text = subtitle
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 6.0
        self.layer.shadowOffset = CGSize(width: 0, height: 10.0)
        // background
        self.addSubview(self.backgroundView)
        self.addFullBoundsConstraintsTo(subView: self.backgroundView, constant: 0)
        // Title
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 20, trailing: nil, top: nil, bottom: -65)
        self.addTrailingAlignmentConstraintTo(subView: self.lblTitle, relatedBy: .lessThanOrEqual, constant: -20, priority: 999)
        // Subtitle
        self.addSubview(self.lblSubtitle)
        self.addBoundsConstraintsTo(subView: self.lblSubtitle, leading: 20, trailing: -20, top: nil, bottom: nil)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.lblSubtitle, constant: 2)
        
        if (UIScreen.main.bounds.height < 667) {
            self.lblTitle.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 20)
            self.backgroundView.addHeightConstraint(150)
        } else {
            self.lblTitle.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 46)
            self.backgroundView.addHeightConstraint(210)
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



