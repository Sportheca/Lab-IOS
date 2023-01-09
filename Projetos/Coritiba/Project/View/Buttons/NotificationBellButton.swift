//
//  NotificationBellButton.swift
//
//
//  Created by Roberto Oliveira on 26/11/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class NotificationBellButton: CustomButton {
    
    private let badgeView:UIView = {
        let vw = UIView()
        vw.isUserInteractionEnabled = false
        return vw
    }()
    
    func updateContent() {
        let padding:CGFloat = 7.0
        let badgeSize:CGFloat = 10.0
        
        self.highlightedAlpha = 0.7
        self.highlightedScale = 0.95
        self.backgroundColor = UIColor.clear
        self.adjustsImageWhenHighlighted = false
        self.imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        let img = UIImage(named: "icon_bell")?.withRenderingMode(.alwaysTemplate)
        self.setImage(img, for: .normal)
        // colors
        self.badgeView.backgroundColor = Theme.color(Theme.Color.PrimaryAnchor)
        self.tintColor = Theme.color(Theme.Color.PrimaryText)
        self.imageView?.tintColor = Theme.color(Theme.Color.PrimaryText)
        
        let count:Int = ServerManager.shared.user?.badges ?? 0
        if count == 0 {
            self.badgeView.removeFromSuperview()
            return
        } else {
            self.addSubview(self.badgeView)
            self.badgeView.frame = CGRect(x: self.bounds.width-padding-badgeSize, y: padding/2, width: badgeSize, height: badgeSize)
            self.badgeView.layer.cornerRadius = badgeSize/2
        }
    }
    
}
