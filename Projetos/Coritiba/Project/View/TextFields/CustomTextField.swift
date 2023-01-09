//
//  CustomTextField.swift
//
//
//  Created by Roberto Oliveira on 20/06/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    // MARK: - Options
    open var placeholderColor:UIColor?
    open var bottomLineColor:UIColor?
    open var bottomLineHeight:CGFloat = 0.0
    open var borderColor:UIColor?
    open var borderWidth:CGFloat = 0.0
    open var cornerRadius:CGFloat = 0.0
    open var contentInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    
    
    // MARK: - Objects
    private var bottomLine:CALayer = CALayer()
    
    
    
    // MARK: - Methods
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Placeholder custom color
        if self.placeholder != nil && self.placeholderColor != nil {
            self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [
                NSAttributedString.Key.foregroundColor: placeholderColor!,
                NSAttributedString.Key.font : self.font ?? UIFont.systemFont(ofSize: 16)
                ])
        }
        
        // Bottom Line
        self.bottomLine.frame = CGRect(x: 0, y: frame.height - bottomLineHeight, width: frame.width, height: bottomLineHeight)
        self.bottomLine.backgroundColor = self.bottomLineColor?.cgColor
        self.layer.addSublayer(self.bottomLine)
        
        // Border
        self.layer.borderColor = self.borderColor?.cgColor
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderWidth = self.borderWidth
        self.clipsToBounds = true
    }
    
    func setPlaceholder(color:UIColor) {
        self.placeholderColor = color
        DispatchQueue.main.async {
            if self.placeholder != nil && self.placeholderColor != nil {
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: self.placeholderColor!])
            }
        }
    }
    
    
    // MARK: - Custom Insets
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.contentInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.contentInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.contentInsets)
    }
    
}


