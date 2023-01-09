//
//  InsetsLabel.swift
//
//
//  Created by Roberto Oliveira on 13/06/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class InsetsLabel: UILabel {
    
    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += self.topInset + self.bottomInset
        intrinsicSuperViewContentSize.width += self.leftInset + self.rightInset
        return intrinsicSuperViewContentSize
    }
}
