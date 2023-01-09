//
//  CircularProgressView.swift
//
//
//  Created by Roberto Oliveira on 15/01/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
    
    // MARK: - Options
    private var textColor:UIColor = UIColor.black
    private var trackColor:UIColor = UIColor.lightGray
    private var progressColor:UIColor = UIColor.black
    var lineWidth:CGFloat = 5.0
    var lineCap:String = convertFromCAShapeLayerLineCap(CAShapeLayerLineCap.round)
    
    
    
    // MARK: - Objects
    private var trackLayer:CAShapeLayer = CAShapeLayer()
    var progressLayer:CAShapeLayer = CAShapeLayer()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        return lbl
    }()
    
    
    
    // MARK: - Methods
    func setProgress(_ value:Float) {
        self.lblTitle.text = "\(Int(value*100))%"
        self.progressLayer.strokeEnd = CGFloat(value)
    }
    
    func updateColors(track:UIColor, progress:UIColor, text:UIColor) {
        self.trackColor = track
        self.progressColor = progress
        self.textColor = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Always setup size and styles
        // Track
        self.trackLayer.path = UIBezierPath(ovalIn: self.bounds.insetBy(dx: self.lineWidth/2, dy: self.lineWidth/2)).cgPath
        self.trackLayer.fillColor = UIColor.clear.cgColor
        self.trackLayer.lineWidth = self.lineWidth
        self.trackLayer.strokeColor = self.trackColor.cgColor
        self.trackLayer.frame = self.bounds
        // Progress
        self.progressLayer.path = UIBezierPath(ovalIn: self.bounds.insetBy(dx: self.lineWidth/2, dy: self.lineWidth/2)).cgPath
        self.progressLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        self.progressLayer.fillColor = UIColor.clear.cgColor
        self.progressLayer.lineWidth = self.lineWidth
        self.progressLayer.strokeColor = self.progressColor.cgColor
        self.progressLayer.frame = self.bounds
        self.progressLayer.lineCap = convertToCAShapeLayerLineCap(self.lineCap)
        // Title
        self.lblTitle.textColor = self.textColor
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        // Track
        self.layer.addSublayer(self.trackLayer)
        // Progress
        self.layer.addSublayer(self.progressLayer)
        // Title
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: self.lineWidth+2, trailing: -self.lineWidth+2, top: nil, bottom: nil)
        self.addCenterYAlignmentConstraintTo(subView: self.lblTitle, constant: 0)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCAShapeLayerLineCap(_ input: CAShapeLayerLineCap) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineCap(_ input: String) -> CAShapeLayerLineCap {
	return CAShapeLayerLineCap(rawValue: input)
}
