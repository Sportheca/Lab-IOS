//
//  FullScreenImageView.swift
//
//
//  Created by Roberto Oliveira on 25/05/2018.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit

class FullScreenImageView: ServerImageView, UIViewControllerTransitioningDelegate {
    
    private let transition:FullScreenImageTransition = FullScreenImageTransition()
    var trackEvent:Int?
    var trackValue:Int?
    
    @objc func openFullScreen() {
        DispatchQueue.main.async {
            guard let topVc = UIApplication.topViewController(), let image = self.image else {return}
            ServerManager.shared.setTrack(trackEvent: self.trackEvent, trackValue: self.trackValue)
            let vc = FullScreenImageViewController(image: image, referenceImageView: self)
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .fullScreen
            topVc.present(vc, animated: true, completion: nil)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition.presenting = true
        return self.transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transition.presenting = false
        return self.transition
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openFullScreen)))
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
