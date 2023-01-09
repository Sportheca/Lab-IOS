//
//  CALayer + Helpers.swift
//
//
//  Created by Roberto Oliveira on 16/01/2018.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit

enum AnimationKeyPath:String {
    case Position = "position"
    case Scale = "transform.scale"
    case Rotation = "transform.rotation"
    case Path = "path"
}

enum AxisKeyPath:String {
    case x = "x"
    case y = "y"
    case z = "z"
}


// MARK: - CALayer Animations
extension CALayer {
    func addAnimation(_ animation:CABasicAnimation, from:Any?, to: Any?, duration:TimeInterval, curve:String, delay:TimeInterval = 0.0) {
        // Animation values
        animation.fromValue = from
        animation.toValue = to
        // Animation Time
        animation.duration = CFTimeInterval(duration)
        animation.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        // Curve
        animation.timingFunction = CAMediaTimingFunction(name: convertToCAMediaTimingFunctionName(curve))
        // Does not go back to initial state after completion
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        self.add(animation, forKey: nil)
    }
    
    func animatePosition(to point:CGPoint, duration:TimeInterval, delay:TimeInterval = 0, curve:String = convertFromCAMediaTimingFunctionName(CAMediaTimingFunctionName.default)) {
        self.addAnimation(CABasicAnimation(keyPath: AnimationKeyPath.Position.rawValue), from: self.position, to: point, duration: duration, curve: curve, delay:delay)
    }
    
    func animateRotation(angle:CGFloat, duration:TimeInterval, delay:TimeInterval = 0, axis:AxisKeyPath = .z, curve:String = convertFromCAMediaTimingFunctionName(CAMediaTimingFunctionName.default)) {
        let keyPath = "\(AnimationKeyPath.Rotation.rawValue).\(axis.rawValue)"
        self.addAnimation(CABasicAnimation(keyPath: keyPath), from: 0, to: CGFloat.pi/180*angle, duration: duration, curve: curve, delay:delay)
    }
    
    func animateScale(multiplier:CGFloat, duration:TimeInterval, delay:TimeInterval = 0, axis:AxisKeyPath, curve:String = convertFromCAMediaTimingFunctionName(CAMediaTimingFunctionName.default)) {
        let keyPath = "\(AnimationKeyPath.Scale.rawValue).\(axis.rawValue)"
        self.addAnimation(CABasicAnimation(keyPath: keyPath), from: nil, to: multiplier, duration: duration, curve: curve, delay:delay)
    }
    
    func animateAlongPath(path:CGPath, duration:TimeInterval, curve:String = convertFromCAMediaTimingFunctionName(CAMediaTimingFunctionName.default)) {
        let animation = CAKeyframeAnimation(keyPath: AnimationKeyPath.Position.rawValue)
        animation.path = path
        // Animation Time
        animation.duration = CFTimeInterval(duration)
        // Curve
        animation.timingFunction = CAMediaTimingFunction(name: convertToCAMediaTimingFunctionName(curve))
        // Does not go back to initial state after completion
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        self.add(animation, forKey: nil)
    }
    
}



// MARK: - CAShapeLayer Animations
extension CAShapeLayer {
    func animatePathChange(newPath:CGPath, duration:TimeInterval, curve:String = convertFromCAMediaTimingFunctionName(CAMediaTimingFunctionName.default)) {
        self.addAnimation(CABasicAnimation(keyPath: AnimationKeyPath.Path.rawValue), from: self.path, to: newPath, duration: duration, curve: curve)
    }
}



// MARK: - CALayer Transforms
extension CALayer {
    
    func addTransformation(transform:CATransform3D) {
        self.transform = CATransform3DConcat(self.transform, transform)
    }
    
    func rotate(degrees:CGFloat, x:CGFloat, y:CGFloat, z:CGFloat) {
        self.addTransformation(transform: CATransform3DMakeRotation(CGFloat.pi/180*degrees, x, y, z))
    }
    
    func scale(x:CGFloat, y:CGFloat) {
        self.addTransformation(transform: CATransform3DMakeScale(x, y, 0))
    }
    
    func move(x:CGFloat, y:CGFloat) {
        self.addTransformation(transform: CATransform3DMakeTranslation(x, y, 0))
    }
    
}












// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAMediaTimingFunctionName(_ input: String) -> CAMediaTimingFunctionName {
	return CAMediaTimingFunctionName(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCAMediaTimingFunctionName(_ input: CAMediaTimingFunctionName) -> String {
	return input.rawValue
}

