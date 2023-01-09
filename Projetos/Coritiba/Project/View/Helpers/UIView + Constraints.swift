//
//  UIView + Constraints.swift
//
//
//  Created by Roberto Oliveira on 29/03/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

extension UIView {
    
    
    
    // MARK: - Width & Height
    func addWidthConstraint(_ constant:CGFloat) {
        self.addWidthConstraint(constant: constant, relatedBy: .equal, priority: 1000)
    }
    
    func addHeightConstraint(_ constant:CGFloat) {
        self.addHeightConstraint(constant: constant, relatedBy: .equal, priority: 1000)
    }
    
    func addWidthConstraint(constant: CGFloat, relatedBy: NSLayoutConstraint.Relation, priority: Float) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relatedBy, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addHeightConstraint(constant: CGFloat, relatedBy: NSLayoutConstraint.Relation, priority: Float) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: relatedBy, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    
    
    // MARK: - Related Width & Height
    func addWidthRelatedConstraintTo(subView:UIView, reference:UIView) {
        self.addWidthRelatedConstraintTo(subView: subView, reference: reference, relatedBy: .equal, multiplier: 1.0, constant: 0, priority: 1000)
    }
    
    func addHeightRelatedConstraintTo(subView:UIView, reference:UIView) {
        self.addHeightRelatedConstraintTo(subView: subView, reference: reference, relatedBy: .equal, multiplier: 1.0, constant: 0, priority: 1000)
    }
    
    func addWidthRelatedConstraintTo(subView:UIView, reference:UIView, relatedBy: NSLayoutConstraint.Relation, multiplier: CGFloat, constant: CGFloat, priority: Float) {
        reference.translatesAutoresizingMaskIntoConstraints = false
        subView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .width, relatedBy: relatedBy, toItem: reference, attribute: .width, multiplier: multiplier, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addHeightRelatedConstraintTo(subView:UIView, reference:UIView, relatedBy: NSLayoutConstraint.Relation, multiplier: CGFloat, constant: CGFloat, priority: Float) {
        reference.translatesAutoresizingMaskIntoConstraints = false
        subView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .height, relatedBy: relatedBy, toItem: reference, attribute: .height, multiplier: multiplier, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    
    
    // MARK: - Spacing
    func addHorizontalSpacingTo(subView1:UIView, subView2:UIView, constant:CGFloat) {
        self.addHorizontalSpacingTo(subView1: subView1, subView2: subView2, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addVerticalSpacingTo(subView1:UIView, subView2:UIView, constant:CGFloat) {
        self.addVerticalSpacingTo(subView1: subView1, subView2: subView2, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addHorizontalSpacingTo(subView1:UIView, subView2:UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView1.translatesAutoresizingMaskIntoConstraints = false
        subView2.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView2, attribute: .leading, relatedBy: relatedBy, toItem: subView1, attribute: .trailing, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addVerticalSpacingTo(subView1:UIView, subView2:UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView1.translatesAutoresizingMaskIntoConstraints = false
        subView2.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView2, attribute: .top, relatedBy: relatedBy, toItem: subView1, attribute: .bottom, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    
    
    // MARK: - Alignment
    func addCenterXAlignmentConstraintTo(subView:UIView, constant:CGFloat) {
        self.addCenterXAlignmentConstraintTo(subView: subView, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addCenterYAlignmentConstraintTo(subView:UIView, constant:CGFloat) {
        self.addCenterYAlignmentConstraintTo(subView: subView, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addLeadingAlignmentConstraintTo(subView:UIView, constant:CGFloat) {
        self.addLeadingAlignmentConstraintTo(subView: subView, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addTrailingAlignmentConstraintTo(subView:UIView, constant:CGFloat) {
        self.addTrailingAlignmentConstraintTo(subView: subView, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addTopAlignmentConstraintTo(subView:UIView, constant:CGFloat) {
        self.addTopAlignmentConstraintTo(subView: subView, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addBottomAlignmentConstraintTo(subView:UIView, constant:CGFloat) {
        self.addBottomAlignmentConstraintTo(subView: subView, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addCenterXAlignmentConstraintTo(subView:UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .centerX, relatedBy: relatedBy, toItem: self, attribute: .centerX, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addCenterYAlignmentConstraintTo(subView:UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .centerY, relatedBy: relatedBy, toItem: self, attribute: .centerY, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addLeadingAlignmentConstraintTo(subView:UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .leading, relatedBy: relatedBy, toItem: self, attribute: .leading, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addTrailingAlignmentConstraintTo(subView:UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .trailing, relatedBy: relatedBy, toItem: self, attribute: .trailing, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addTopAlignmentConstraintTo(subView:UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .top, relatedBy: relatedBy, toItem: self, attribute: .top, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addBottomAlignmentConstraintTo(subView:UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: relatedBy, toItem: self, attribute: .bottom, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    // Safe Area
    func addTopAlignmentConstraintFromSafeAreaTo(subView:UIView, constant:CGFloat, priority:Float = 1000, relatedBy: NSLayoutConstraint.Relation = .equal) {
        let constraint = NSLayoutConstraint(item: subView, attribute: .top, relatedBy: relatedBy, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addBottomAlignmentConstraintFromSafeAreaTo(subView:UIView, constant:CGFloat, priority:Float = 1000, relatedBy: NSLayoutConstraint.Relation = .equal) {
        let constraint = NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: relatedBy, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    
    
    // MARK: - Related Alignment
    func addCenterXAlignmentRelatedConstraintTo(subView:UIView, reference:UIView, constant: CGFloat) {
        self.addCenterXAlignmentRelatedConstraintTo(subView: subView, reference: reference, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addCenterYAlignmentRelatedConstraintTo(subView:UIView, reference:UIView, constant: CGFloat) {
        self.addCenterYAlignmentRelatedConstraintTo(subView: subView, reference: reference, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addLeadingAlignmentRelatedConstraintTo(subView:UIView, reference:UIView, constant: CGFloat) {
        self.addLeadingAlignmentRelatedConstraintTo(subView: subView, reference: reference, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addTrailingAlignmentRelatedConstraintTo(subView:UIView, reference:UIView, constant: CGFloat) {
        self.addTrailingAlignmentRelatedConstraintTo(subView: subView, reference: reference, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addTopAlignmentRelatedConstraintTo(subView:UIView, reference:UIView, constant: CGFloat) {
        self.addTopAlignmentRelatedConstraintTo(subView: subView, reference: reference, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addBottomAlignmentRelatedConstraintTo(subView:UIView, reference:UIView, constant: CGFloat) {
        self.addBottomAlignmentRelatedConstraintTo(subView: subView, reference: reference, relatedBy: .equal, constant: constant, priority: 1000)
    }
    
    func addCenterXAlignmentRelatedConstraintTo(subView:UIView, reference:UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        reference.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .centerX, relatedBy: relatedBy, toItem: reference, attribute: .centerX, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addCenterYAlignmentRelatedConstraintTo(subView: UIView, reference: UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        reference.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .centerY, relatedBy: relatedBy, toItem: reference, attribute: .centerY, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addLeadingAlignmentRelatedConstraintTo(subView: UIView, reference: UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        reference.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .leading, relatedBy: relatedBy, toItem: reference, attribute: .leading, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addTrailingAlignmentRelatedConstraintTo(subView: UIView, reference: UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        reference.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .trailing, relatedBy: relatedBy, toItem: reference, attribute: .trailing, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addTopAlignmentRelatedConstraintTo(subView:UIView, reference:UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        reference.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .top, relatedBy: relatedBy, toItem: reference, attribute: .top, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    func addBottomAlignmentRelatedConstraintTo(subView:UIView, reference:UIView, relatedBy: NSLayoutConstraint.Relation, constant: CGFloat, priority: Float) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        reference.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: relatedBy, toItem: reference, attribute: .bottom, multiplier: 1.0, constant: constant)
        constraint.priority = UILayoutPriority(priority)
        self.addConstraint(constraint)
    }
    
    
    
    // MARK: - Full Bounds
    func addFullBoundsConstraintsTo(subView: UIView, constant: CGFloat) {
        self.addBoundsConstraintsTo(subView: subView, leading: constant, trailing: -constant, top: constant, bottom: -constant)
    }
    
    func addBoundsConstraintsTo(subView:UIView, leading:CGFloat?, trailing:CGFloat?, top:CGFloat?, bottom:CGFloat?) {
        if let leadingValue = leading {
            self.addLeadingAlignmentConstraintTo(subView: subView, constant: leadingValue)
        }
        if let trailingValue = trailing {
            self.addTrailingAlignmentConstraintTo(subView: subView, constant: trailingValue)
        }
        if let topValue = top {
            self.addTopAlignmentConstraintTo(subView: subView, constant: topValue)
        }
        if let bottomValue = bottom {
            self.addBottomAlignmentConstraintTo(subView: subView, constant: bottomValue)
        }
    }
    
    


    // MARK: - SquareSize
    func addSquareSizeConstraint(_ constant:CGFloat) {
            self.addWidthConstraint(constant: constant, relatedBy: .equal, priority: 999)
            self.addHeightConstraint(constant: constant, relatedBy: .equal, priority: 999)
        }

    
}













