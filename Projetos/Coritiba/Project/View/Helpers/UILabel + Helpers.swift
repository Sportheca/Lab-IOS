//
//  UILabel + Helpers.swift
//
//
//  Created by Roberto Oliveira on 29/08/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

// MARK: - LAYOUT helpers
extension UILabel {
    // contentHeight() return the UILabel needed height for current text
    func contentHeight() -> CGFloat {
        self.sizeToFit()
        return self.frame.height
    }
    
    func setSpaceBetweenLines(space: CGFloat) {
        if let text = self.text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.alignment = self.textAlignment
            style.lineSpacing = space
            style.lineBreakMode = .byTruncatingTail
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, Array(text).count))
            self.attributedText = attributeString
        }
    }
}





extension UILabel {
    var isTruncated: Bool {
        guard let labelText = text else {
            return false
        }
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font as Any],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
}

