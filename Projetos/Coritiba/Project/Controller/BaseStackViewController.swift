//
//  BaseStackViewController.swift
//
//
//  Created by Roberto Oliveira on 30/08/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

class BaseStackViewController: BaseViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    private var refreshRequired:Bool = false
    private var isDragging:Bool = false {
        didSet {
            if self.refreshRequired {
                self.didPullToRefresh()
                self.refreshRequired = false
            }
        }
    }
    
    
    
    // MARK: - Objects
    var bottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
    lazy var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.delegate = self
        return sv
    }()
    let contentView:UIView = {
        let vw = UIView()
        return vw
    }()
    let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = NSLayoutConstraint.Axis.vertical
        vw.alignment = UIStackView.Alignment.center
        vw.distribution = UIStackView.Distribution.fill
        vw.spacing = 10
        return vw
    }()
    lazy var refreshControl:CustomRefreshControl = {
        let vw = CustomRefreshControl()
        vw.addTarget(self, action: #selector(self.requestRefresh), for: .valueChanged)
        return vw
    }()
    
    
    
    // MARK: - Refresh Control Methods
    @objc func requestRefresh() {
        self.refreshRequired = true
    }
    
    @objc func didPullToRefresh() {
        // override this method in subclasses
    }
    
    
    
    
    
    
    // MARK: - Methods
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isDragging = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDragging = true
    }
    
    func addFullWidthStackSubview(_ subView: UIView) {
        self.addFullWidthStackSubview(subView, constant: 0)
    }
    
    func addFullWidthStackSubview(_ subView: UIView, constant: CGFloat) {
        self.stackView.addArrangedSubview(subView)
        let const = NSLayoutConstraint(item: subView, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: 1.0, constant: constant)
        const.priority = UILayoutPriority(rawValue: 1000)
        self.contentView.addConstraint(const)
    }
    
    func addStackSpaceView(height: CGFloat) {
        // Add fake view to create space on stack view
        let vw = UIView()
        vw.backgroundColor = .clear
        vw.addHeightConstraint(height)
        self.addFullWidthStackSubview(vw)
    }
    
    
    
    
    
    
    // MARK: - Super Methods
    override func prepareElements() {
        super.prepareElements()
        
        // Scroll View
        self.view.addSubview(self.scrollView)
        self.view.addBoundsConstraintsTo(subView: self.scrollView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.bottomConstraint = NSLayoutConstraint(item: self.view as Any, attribute: .bottom, relatedBy: .equal, toItem: self.scrollView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(self.bottomConstraint)
        
        // Add Refresh Control
//                self.scrollView.addSubview(self.refreshControl)
        
        
        // Content View
        self.scrollView.addSubview(self.contentView)
        // Top and bottom with 10 space each
        self.scrollView.addTopAlignmentConstraintTo(subView: self.contentView, constant: 0)
        self.scrollView.addBottomAlignmentConstraintTo(subView: self.contentView, constant: 0)
        // Left and Right min space
        self.scrollView.addCenterXAlignmentConstraintTo(subView: self.contentView, constant: 0)
        self.scrollView.addTrailingAlignmentConstraintTo(subView: self.contentView, relatedBy: .lessThanOrEqual, constant: 0, priority: 1000)
        self.scrollView.addLeadingAlignmentConstraintTo(subView: self.contentView, relatedBy: .greaterThanOrEqual, constant: 0, priority: 1000)
        
        // Content Max Width
        self.contentView.addWidthConstraint(constant: UIScreen.main.bounds.size.width, relatedBy: .equal, priority: 998)
        
        // Stack View
        self.contentView.addSubview(self.stackView)
        self.contentView.addFullBoundsConstraintsTo(subView: self.stackView, constant: 0)
    }
    
    
    
    
    // MARK: - KEYBOARD OBSERVER STACK
    // MARK: - keyboard Methods (override this methods on YourViewController)
    override func keyboardWillDisappear(duration: TimeInterval) {
        DispatchQueue.main.async {
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    override func keyboardWillAppear(height: CGFloat, duration: TimeInterval) {
        DispatchQueue.main.async {
            if let tabHeight = self.tabBarController?.tabBar.frame.height {
                self.bottomConstraint.constant = height - tabHeight
            } else {
                self.bottomConstraint.constant = height
            }
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    
    
}











