//
//  PaddingLabel.swift
//
//
//  Created by Roberto Oliveira on 26/11/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {
    
    // MARK: - Options
    var rounded:Bool = true
    var topInset: CGFloat = 1.0
    var bottomInset: CGFloat = 2.0
    var leftInset: CGFloat = 3.0
    var rightInset: CGFloat = 3.0
    
    // MARK: - Methods
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.rounded ? self.frame.height/2 : 0
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}




