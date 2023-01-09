//
//  UIView + Helpers.swift
//
//
//  Created by Roberto Oliveira on 31/08/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

extension UIView {
    
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        
        return nil
    }
    
    func addShadow(shadowColor:UIColor, shadowOffset:CGSize, shadowOpacity:Float, shadowRadius:CGFloat) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
    
    func scaleTo(_ value:CGFloat?, duration:TimeInterval = 0.2, animationOptions:UIView.AnimationOptions = .curveEaseOut) {
        UIView.animate(withDuration: duration, delay: 0.0, options: animationOptions, animations: {
            if let scale = value {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            } else {
                self.transform = CGAffineTransform.identity
            }
        }, completion: nil)
    }
    
    
    func bounceAnimation(duration:TimeInterval = 0.5, values:[CGFloat] = [1.0 ,1.2, 0.95, 1.05, 0.97, 1.01, 1.0]) {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = values
        bounceAnimation.duration = duration
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        self.layer.add(bounceAnimation, forKey: nil)
    }
    
}


