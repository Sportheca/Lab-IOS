//
//  ImageCache.swift
//
//
//  Created by Roberto Oliveira on 06/12/16.
//  Copyright © 2016 Roberto Oliveira. All rights reserved.
//

import UIKit

// MARK: - Cache Images
let imageCache = NSCache<AnyObject, AnyObject>()

enum ServerImageViewFilter {
    case None
    case BlackAndWhite
}

class ServerImageView: UIImageView {
    
    var filter:ServerImageViewFilter = .None
    var isPlaceholderTintColorEnabled:Bool = false
    
    // MARK: - Current urlString (to avoid messy)
    var imageUrlString:String?
    
    func setServerImage(urlString:String?) {
        self.setServerImage(urlString: urlString, placeholderImageName: nil)
    }
    
    func setServerImage(urlString:String?, placeholderImageName:String?) {
        self.setServerImage(urlString: urlString, placeholderImageName: placeholderImageName, completion: nil)
    }
    
    func setServerImage(urlString:String?, placeholderImageName:String?, completion: (()->Void)?) {
        DispatchQueue.main.async {
            if let imgName = placeholderImageName {
                let img = self.isPlaceholderTintColorEnabled ? UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate) : UIImage(named: imgName)
                self.applyImage(img)
            } else {
                self.applyImage(nil)
            }
        }
        
        guard let urlString = urlString else {return}
        self.imageUrlString = urlString
        // Check Cash for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            if self.imageUrlString == urlString {
                DispatchQueue.main.async {
                    self.applyImage(cachedImage)
                }
                completion?()
            }
            return
        }
        
        // Download the image
        ServerManager.shared.downloadImage(urlSufix: urlString) { (imageObj:UIImage?) in
            if let img = imageObj {
                imageCache.setObject(img, forKey: urlString as AnyObject)
                if self.imageUrlString == urlString {
                    DispatchQueue.main.async {
                        self.applyImage(img)
                    }
                    completion?()
                }
            }
        }
    }
    
    
    
    private func applyImage(_ img:UIImage?) {
        guard let imageObject = img else {
            self.image = nil
            return
        }
        switch self.filter {
        case .None:
            self.image = imageObject
            return
        case .BlackAndWhite:
            self.image = imageObject.withBlackAndWhiteFilter()
            return
        }
    }
    
    
    
}


