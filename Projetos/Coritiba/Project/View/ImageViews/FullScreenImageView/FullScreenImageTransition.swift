//
//  FullScreenImageTransition.swift
//
//
//  Created by Roberto Oliveira on 25/05/2018.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit

class FullScreenImageTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Properties
    private let transitionDuration:TimeInterval = 0.25
    var presenting:Bool = true
    
    
    // MARK: - Methods
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.presenting {
            guard let toVc = transitionContext.viewController(forKey: .to) as? FullScreenImageViewController else {return}
            guard let referenceImageView = toVc.referenceImageView else {return}
            let containerView = transitionContext.containerView
            
            containerView.addSubview(toVc.view)
            toVc.view.alpha = 0.0
            
            let initialFrame = UIApplication.shared.keyWindow?.convert(referenceImageView.frame, from: referenceImageView.superview) ?? CGRect.zero
            toVc.referenceFrame = initialFrame
            let finalFrame = toVc.imageView.frame
            
            let transitionImageView = UIImageView()
            transitionImageView.frame = initialFrame
            transitionImageView.contentMode = .scaleAspectFill
            transitionImageView.clipsToBounds = true
            transitionImageView.layer.cornerRadius = referenceImageView.layer.cornerRadius
            transitionImageView.image = toVc.image
            containerView.addSubview(transitionImageView)
            toVc.referenceImageView?.alpha = 0.0
            toVc.imageView.alpha = 0.0
            
            UIView.animate(withDuration: self.transitionDuration, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                transitionImageView.frame = finalFrame
                transitionImageView.layer.cornerRadius = 0
                toVc.view.alpha = 1.0
            }) { (_) in
                toVc.imageView.alpha = 1.0
                transitionImageView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
            
        } else {
            guard let fromVc = transitionContext.viewController(forKey: .from) as? FullScreenImageViewController else {return}
            guard let referenceImageView = fromVc.referenceImageView else {return}
            guard let toVc = transitionContext.viewController(forKey: .to) else {return}
            let containerView = transitionContext.containerView
            
            let initialFrame = UIApplication.shared.keyWindow?.convert(fromVc.imageView.frame, from: fromVc.imageView.superview) ?? CGRect.zero
            let originalFrame = fromVc.referenceFrame
            
            let transitionImageView = UIImageView()
            transitionImageView.frame = initialFrame
            transitionImageView.contentMode = .scaleAspectFill
            transitionImageView.layer.cornerRadius = 0
            transitionImageView.clipsToBounds = true
            transitionImageView.image = fromVc.image
            
            containerView.addSubview(toVc.view)
            containerView.addSubview(fromVc.view)
            containerView.addSubview(transitionImageView)
            fromVc.imageView.alpha = 0.0
            fromVc.referenceImageView?.alpha = 0.0
            
            
            UIView.animate(withDuration: self.transitionDuration, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                transitionImageView.frame = originalFrame
                transitionImageView.layer.cornerRadius = referenceImageView.layer.cornerRadius
                fromVc.view.alpha = 0.0
            }) { (_) in
                fromVc.referenceImageView?.alpha = 1.0
                transitionImageView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
            
        }
        
    }
    
}







