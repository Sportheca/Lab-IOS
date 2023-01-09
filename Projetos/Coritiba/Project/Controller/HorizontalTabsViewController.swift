//
//  HorizontalTabsViewController.swift
//  
//
//  Created by Roberto Oliveira on 06/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class HorizontalTabsViewController: BaseViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    var selectedTabIndex:Int = 0
    
    
    // MARK: - Objects
    private let tabSelectorView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let menuStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 20.0
        return vw
    }()
    var bottomConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private lazy var scrollView:UIScrollView = {
        let vw = UIScrollView()
        vw.delegate = self
        vw.showsVerticalScrollIndicator = false
        vw.showsHorizontalScrollIndicator = false
        vw.alwaysBounceVertical = false
        vw.alwaysBounceHorizontal = false
        vw.bounces = true
        vw.isPagingEnabled = true
        return vw
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fillEqually
        vw.spacing = 0.0
        return vw
    }()
    
    
    
    // MARK: - Methods
    func numberOfTabs() -> Int {return 0}
    func titleForTabAt(index:Int) -> String {return ""}
    func viewForTabAt(index:Int) -> UIView {return UIView()}
    func didSelectTabAt(index:Int) {}
    
    
    
    
    
    
    // MARK: - Super Methods
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        let total = self.numberOfTabs()
        guard total > 0 else {return}
        for i in 0..<total {
            let btn = CustomButton()
            btn.tag = i
            btn.setTitle(self.titleForTabAt(index: i), for: .normal)
            btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
            btn.addWidthConstraint(100)
            btn.highlightedAlpha = 0.6
            btn.highlightedScale = 0.95
            btn.addTarget(self, action: #selector(self.tap(_:)), for: .touchUpInside)
            self.menuStackView.addArrangedSubview(btn)
            
            let vw = self.viewForTabAt(index: i)
            self.stackView.addArrangedSubview(vw)
            self.view.addConstraint(NSLayoutConstraint(item: vw, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0))
        }
        self.updateMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollToSelectedTab()
    }
    
    func updateMenu() {
        for vw in self.menuStackView.arrangedSubviews {
            guard let btn = vw as? CustomButton else {continue}
            let color = btn.tag == self.selectedTabIndex ? Theme.color(.PrimaryText) : Theme.color(.MutedText)
            btn.setTitleColor(color, for: .normal)
        }
    }
    
    @objc func tap(_ sender:UIButton) {
        self.setCurrentTab(index: sender.tag)
    }
    
    func setCurrentTab(index:Int) {
        DispatchQueue.main.async {
            self.selectedTabIndex = index
            self.scrollToSelectedTab()
            self.updateMenu()
        }
    }
    
    private func scrollToSelectedTab() {
        self.scrollView.setContentOffset(CGPoint(x: CGFloat(self.selectedTabIndex) * self.scrollView.bounds.width, y: 0), animated: true)
    }
    
    
    
    // MARK: - Delegate Methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.selectedTabIndex = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
            self.updateMenu()
        }
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Tab Selector
        self.view.addSubview(self.tabSelectorView)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.tabSelectorView, constant: 10)
        self.view.addBoundsConstraintsTo(subView: self.tabSelectorView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.tabSelectorView.addHeightConstraint(50)
        // menu
        self.tabSelectorView.addSubview(self.menuStackView)
        self.tabSelectorView.addCenterXAlignmentConstraintTo(subView: self.menuStackView, constant: 0)
        self.tabSelectorView.addBoundsConstraintsTo(subView: self.menuStackView, leading: nil, trailing: nil, top: 0, bottom: 0)
        // ScrollView
        self.view.addSubview(self.scrollView)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.scrollView, constant: 60)
        self.view.addBoundsConstraintsTo(subView: self.scrollView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.bottomConstraint = NSLayoutConstraint(item: self.view as Any, attribute: .bottom, relatedBy: .equal, toItem: self.scrollView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraint(self.bottomConstraint)
        // Stack
        self.scrollView.addSubview(self.stackView)
        self.scrollView.addFullBoundsConstraintsTo(subView: self.stackView, constant: 0)
//        self.stackView.addHeightConstraint(500)
        
        let referenceView:UIView = UIView()
        referenceView.backgroundColor = UIColor.clear
        self.view.insertSubview(referenceView, belowSubview: self.tabSelectorView)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: referenceView, constant: 60)
        self.view.addBottomAlignmentConstraintTo(subView: referenceView, constant: 0)
        
        self.view.addHeightRelatedConstraintTo(subView: self.stackView, reference: referenceView)
    }
    
    
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
            if let tab = UIApplication.topViewController()?.tabBarController?.tabBar {
                self.bottomConstraint.constant = height-tab.frame.height
            } else {
                self.bottomConstraint.constant = height
            }
            UIView.animate(withDuration: duration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    
}


