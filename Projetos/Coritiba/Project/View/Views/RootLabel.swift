//
// RootLabel.swift
// 
//
// Created by Roberto Oliveira on 13/01/22.
// Copyright © 2022 Sportheca. All rights reserved.
//


import UIKit

class RootLabel: UILabel {
    
    // MARK: - Properties
    var spaceBetweenLines:CGFloat?
    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0
    
    
    
    // MARK: - Line Space Methods (after text set)
    override var text: String? {
        didSet {
            if let space = self.spaceBetweenLines {
                self.setSpaceBetweenLines(space: space)
            }
        }
    }
    
    
    // MARK: - Insets Draw Method
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
