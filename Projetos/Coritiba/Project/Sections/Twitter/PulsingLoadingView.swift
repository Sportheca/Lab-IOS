//
//  PulsingLoadingView.swift
//
//
//  Created by Roberto Oliveira on 07/02/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class PulsingLoadingView: UIView {
    
    // MARK: - Properties
    private var animationScale:CGFloat = 1.0
    
    
    // MARK: - Objects
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 16)
        return lbl
    }()
    let ivLogo:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    
    // MARK: - Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Icon
        self.addSubview(self.ivLogo)
        self.addCenterXAlignmentConstraintTo(subView: self.ivLogo, constant: 0)
        self.addTopAlignmentConstraintTo(subView: self.ivLogo, constant: 10)
        self.ivLogo.addWidthConstraint(100)
        self.ivLogo.addHeightConstraint(100)
        // Title
        self.addSubview(self.lblTitle)
        self.addVerticalSpacingTo(subView1: self.ivLogo, subView2: self.lblTitle, constant: 30)
        self.addCenterXAlignmentConstraintTo(subView: self.lblTitle, constant: 0)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 10, trailing: -10, top: nil, bottom: -10)
    }
    
    private func animate() {
        self.animationScale = (self.animationScale == 1.0) ? 1.1 : 1.0
        self.ivLogo.scaleTo(self.animationScale, duration: 1.0, animationOptions: [.curveEaseInOut, .allowUserInteraction])
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.animate()
        }
    }
    
    
    // MARK: - Init Methods
    init(title:String, image:UIImage?, animate:Bool = false) {
        super.init(frame: CGRect.zero)
        self.prepareElements()
        self.ivLogo.image = image
        self.lblTitle.text = title
        if animate {
            self.animate()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}
