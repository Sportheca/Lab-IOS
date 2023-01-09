//
//  CustomButton.swift
//
//
//  Created by Roberto Oliveira on 20/06/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    // MARK: - Options
    var adjustsAlphaWhenHighlighted:Bool = true
    var highlightedAlpha:CGFloat = 0.5
    var highlightedScale:CGFloat = 1.0
    var isPlaceholderTintColorEnabled:Bool = false
    
    
    
    // MARK: - Server Image Method
    private var imageUrlString:String?
    
    func setServerImage(urlString:String?) {
        self.setServerImage(urlString: urlString, placeholderImageName: "")
    }
    
    func setServerImage(urlString:String?, placeholderImageName:String) {
        DispatchQueue.main.async {
            let img = self.isPlaceholderTintColorEnabled ? UIImage(named: placeholderImageName)?.withRenderingMode(.alwaysTemplate) : UIImage(named: placeholderImageName)
            self.setImage(img, for: .normal)
        }
        
        guard let urlString = urlString else {return}
        self.imageUrlString = urlString
        // Check Cash for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                self.setImage(cachedImage, for: .normal)
                //                self.imageView?.contentMode = self.imageContentMode
            }
            return
        }
        
        // Download the image
        ServerManager.shared.downloadImage(urlSufix: urlString) { (imageObj:UIImage?) in
            if let img = imageObj {
                imageCache.setObject(img, forKey: urlString as AnyObject)
                if self.imageUrlString == urlString {
                    DispatchQueue.main.async {
                        self.setImage(img, for: .normal)
                        //                        self.imageView?.contentMode = self.imageContentMode
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - Super Methods
    open override var isHighlighted: Bool {
        didSet {
            if self.adjustsAlphaWhenHighlighted {
                self.alpha = (self.isHighlighted) ? self.highlightedAlpha : 1.0
            }
            self.scaleTo((self.isHighlighted) ? self.highlightedScale : nil)
        }
    }
    
    
}



