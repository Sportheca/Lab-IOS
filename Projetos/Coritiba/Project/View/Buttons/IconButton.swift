//
//  IconButton.swift
//
//
//  Created by Roberto Oliveira on 08/11/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class IconButton: CustomButton {
    
    // MARK - Properties
    var iconLeading:CGFloat = 20.0
    var iconTop:CGFloat = 10.0
    var iconBottom:CGFloat = 10.0
    var horizontalSpacing:CGFloat = 10.0
    var titleTrailing:CGFloat = 20.0
    var titleTop:CGFloat = 0.0
    var titleBottom:CGFloat = 0.0
    
    // MARK: - Objects
    let ivIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Normal, size: 12)
        lbl.textColor = UIColor(R: 50, G: 50, B: 50)
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(icon:UIImage?, title:String?) {
        self.ivIcon.image = icon
        self.lblTitle.text = title
    }
    
    func prepareElements() {
        self.addSubview(self.ivIcon)
        self.addBoundsConstraintsTo(subView: self.ivIcon, leading: abs(self.iconLeading), trailing: nil, top: abs(self.iconTop), bottom: -abs(self.iconBottom))
        self.addConstraint(NSLayoutConstraint(item: self.ivIcon, attribute: .width, relatedBy: .equal, toItem: self.ivIcon, attribute: .height, multiplier: 1.0, constant: 0))
        self.addSubview(self.lblTitle)
        self.addHorizontalSpacingTo(subView1: self.ivIcon, subView2: self.lblTitle, constant: abs(self.horizontalSpacing))
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: nil, trailing: -abs(self.titleTrailing), top: abs(self.titleTop), bottom: abs(self.titleBottom))
    }
    
    init(iconLeading:CGFloat, iconTop:CGFloat, iconBottom:CGFloat, horizontalSpacing:CGFloat, titleTrailing:CGFloat, titleTop:CGFloat, titleBottom:CGFloat) {
        super.init(frame: CGRect.zero)
        self.iconLeading = iconLeading
        self.iconTop = iconTop
        self.iconBottom = iconBottom
        self.horizontalSpacing = horizontalSpacing
        self.titleTrailing = titleTrailing
        self.titleTop = titleTop
        self.titleBottom = titleBottom
        self.prepareElements()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

