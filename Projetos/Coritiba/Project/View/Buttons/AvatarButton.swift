//
//  AvatarButton.swift
//
//
//  Created by Roberto Oliveira on 26/11/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class AvatarButton: CustomButton {
    
    var isCircle:Bool = true
    var customTintColor:UIColor?
    
    func updateContent(imgUrl:String?) {
        self.backgroundColor = UIColor.clear
        self.isPlaceholderTintColorEnabled = true
        self.highlightedAlpha = 1.0
        self.imageView?.contentMode = .scaleAspectFill
        self.imageView?.tintColor = self.customTintColor ?? Theme.color(Theme.Color.PrimaryText)
        let placeholderImageName:String = "avatar_placeholder"
        
        if let avatarUrl = imgUrl {
            self.setServerImage(urlString: avatarUrl, placeholderImageName: placeholderImageName)
        } else {
            let img = UIImage(named: placeholderImageName)?.withRenderingMode(.alwaysTemplate)
            self.setImage(img, for: .normal)
        }
    }
    
    func updateWithCurrentUserImage() {
        guard let user = ServerManager.shared.user else {
            self.updateContent(imgUrl: nil)
            return
        }
        if let img = ServerManager.shared.userImage {
            self.setImage(img, for: .normal)
        } else {
            self.updateContent(imgUrl: user.imageUrl)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.cornerRadius = self.isCircle ? self.bounds.height/2 : 0
    }
    
}
