//
//  RoundShadowView.swift
//
//
//  Created by Roberto Oliveira on 27/06/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

class RoundShadowView: UIView {
    
    // MARK: - Options
    var enableImageView:Bool = false
    // Round
    var circle:Bool = false
    var radius:CGFloat = 0.0
    var borderColor:UIColor = UIColor.clear
    var borderWidth:CGFloat = 0.0
    // Shadow
    var shadow:Bool = false
    var shadowColor:UIColor = UIColor.black
    var xOffSet:CGFloat = 0.0
    var yOffSet:CGFloat = 2.0
    var shadowOpacity:Float = 0.4
    var shadowRadius:CGFloat = 3.0
    
    // MARK: - Objects
    lazy var imageView:FullScreenImageView = {
        let iv = FullScreenImageView()
        iv.backgroundColor = UIColor.clear
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        self.addSubview(iv)
        self.addFullBoundsConstraintsTo(subView: iv, constant: 0)
        return iv
    }()
    
    
    // MARK: - Layout Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = !self.shadow
        self.layer.cornerRadius = (self.circle == true) ? self.frame.size.height/2 : self.radius
        
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = self.borderWidth
        
        if self.shadow == true {
            self.addShadow(shadowColor: self.shadowColor, shadowOffset: CGSize(width: self.xOffSet, height: self.yOffSet), shadowOpacity: self.shadowOpacity, shadowRadius: self.shadowRadius)
        } else {
            self.addShadow(shadowColor: UIColor.clear, shadowOffset: CGSize.zero, shadowOpacity: 0, shadowRadius: 0)
        }
        
        // Image Corner Radius
        if self.enableImageView == true {
            self.imageView.layer.cornerRadius = (self.circle == true) ? self.frame.size.height/2 : self.radius
        }
    }
    
}





