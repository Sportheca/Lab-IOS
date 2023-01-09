//
//  CloseButton.swift
//  
//
//  Created by Roberto Oliveira on 23/06/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

open class CloseButton: UIButton {
    
    // MARK: - Properties
    private let shape:CAShapeLayer = CAShapeLayer()
    private let shapeView = UIView()
    
    // MARK: - Options
    // Border
    var borderColor:UIColor?
    var borderWidth:CGFloat = 0.0
    var circle:Bool = false
    var cornerRadius:CGFloat = 0.0
    
    // Icon
    open var iconLineWidth:CGFloat = 3.0
    open var iconPathInset:CGFloat = 13.0
    open var iconPathRound:Bool = true
    
    // Colors
    open var color:UIColor = UIColor.white
    var notEnabledColor:UIColor = UIColor.lightGray
    
    // Shadow
    var shadow:Bool = true
    var shadowColor:UIColor = UIColor.black
    var shadowOffSet:CGSize = CGSize(width: 2.0, height: 2.0)
    var shadowOpacity:Float = 0.4
    var shadowRadius:CGFloat = 3.0
    
    
    func setColor(color:UIColor) {
        self.color = color
        self.layoutSubviews()
    }
    
    
    // MARK - Layout Methods
    open override var isHighlighted: Bool {
        didSet {
            self.alpha = (self.isHighlighted) ? 0.5 : 1.0
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // Corner Radius
        self.layer.masksToBounds = !self.shadow
        self.layer.cornerRadius = (self.circle == true) ? self.frame.size.height/2 : self.cornerRadius
        
        
        // Border
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = (self.isEnabled) ? self.borderColor?.cgColor : self.notEnabledColor.cgColor
        
        
        // Icon
        self.shapeView.frame = self.bounds
        self.shapeView.backgroundColor = self.color
        self.shape.path = self.closePath().cgPath
        self.shape.frame = self.bounds
        self.shape.strokeColor = self.color.cgColor
        self.shape.fillColor = UIColor.clear.cgColor
        self.shape.lineCap = convertToCAShapeLayerLineCap((self.iconPathRound == true) ? "round" : "butt")
        self.shape.lineWidth = self.iconLineWidth
        self.shapeView.layer.mask = self.shape
        
        
        // Shadow
        if self.shadow == true {
            self.addShadow(shadowColor: self.shadowColor, shadowOffset: self.shadowOffSet, shadowOpacity: self.shadowOpacity, shadowRadius: self.shadowRadius)
        } else {
            self.addShadow(shadowColor: UIColor.clear, shadowOffset: CGSize.zero, shadowOpacity: 0, shadowRadius: 0)
        }
        
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.shapeView.isUserInteractionEnabled = false
        self.addSubview(self.shapeView)
    }
    
    // MARK: - Path Method
    private func closePath() -> UIBezierPath {
        let rect:CGRect = self.bounds
        let path = UIBezierPath()
        let pathInset:CGFloat = self.iconPathInset
        path.move(to: CGPoint(x: pathInset, y: pathInset))
        path.addLine(to: CGPoint(x: (rect.size.width-pathInset), y: (rect.size.height-pathInset)))
        path.move(to: CGPoint(x: pathInset, y: (rect.size.height-pathInset)))
        path.addLine(to: CGPoint(x: (rect.size.width-pathInset), y: pathInset))
        return path
    }
    
}







// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineCap(_ input: String) -> CAShapeLayerLineCap {
	return CAShapeLayerLineCap(rawValue: input)
}
