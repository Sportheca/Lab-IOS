//
//  BaseKeyboardViewController.swift
//
//
//  Created by Roberto Oliveira on 07/12/2017.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

class BaseKeyboardViewController: BaseViewController {
    
    // MARK: - Options
    var verticalConstraintMultipliers:(keyboardVisible:CGFloat, keyboardHidden:CGFloat) = (keyboardVisible: 1.0, keyboardHidden: 1.0)
    
    // MARK: - Objects
    var centerYConstraint:NSLayoutConstraint = NSLayoutConstraint()
    var bottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
    let scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    let contentContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    
    
    // MARK: - Super Methods
    override func prepareElements() {
        super.prepareElements()
        // Scroll View
        self.view.addSubview(self.scrollView)
        self.view.addBoundsConstraintsTo(subView: self.scrollView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.bottomConstraint = NSLayoutConstraint(item: self.view as Any, attribute: .bottom, relatedBy: .equal, toItem: self.scrollView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(self.bottomConstraint)
        // Content Container View
        self.scrollView.addSubview(self.contentContainerView)
        self.scrollView.addCenterXAlignmentConstraintTo(subView: self.contentContainerView, constant: 0)
        self.contentContainerView.addWidthConstraint(UIScreen.main.bounds.size.width)
        self.scrollView.addTopAlignmentConstraintTo(subView: self.contentContainerView, relatedBy: .greaterThanOrEqual, constant: 0, priority: 995)
        self.scrollView.addBottomAlignmentConstraintTo(subView: self.contentContainerView, relatedBy: .lessThanOrEqual, constant: 0, priority: 995)
        self.scrollView.addBoundsConstraintsTo(subView: self.contentContainerView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.centerYConstraint = NSLayoutConstraint(item: self.contentContainerView, attribute: .centerY, relatedBy: .equal, toItem: self.scrollView, attribute: .centerY, multiplier: self.verticalConstraintMultipliers.keyboardHidden, constant: 0)
        self.centerYConstraint.priority = UILayoutPriority(750)
        self.view.addConstraint(self.centerYConstraint)
    }
    
    
    
    
    // MARK: - KEYBOARD OBSERVER STACK
    // MARK: - keyboard Methods (override this methods on YourViewController)
    override func keyboardWillDisappear(duration: TimeInterval) {
        DispatchQueue.main.async {
            self.updateVerticalConstraint(multiplier: self.verticalConstraintMultipliers.keyboardHidden)
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    override func keyboardWillAppear(height: CGFloat, duration: TimeInterval) {
        DispatchQueue.main.async {
            self.updateVerticalConstraint(multiplier: self.verticalConstraintMultipliers.keyboardVisible)
            self.bottomConstraint.constant = height
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func updateVerticalConstraint(multiplier:CGFloat) {
        self.view.removeConstraint(self.centerYConstraint)
        self.centerYConstraint = NSLayoutConstraint(item: self.contentContainerView, attribute: .centerY, relatedBy: .equal, toItem: self.scrollView, attribute: .centerY, multiplier: multiplier, constant: 0)
        self.centerYConstraint.priority = UILayoutPriority(750)
        self.view.addConstraint(self.centerYConstraint)
    }
    
}

