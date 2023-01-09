
//
//  ClubHomeNextMatchesView.swift
//  
//
//  Created by Roberto Oliveira on 13/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class ClubHomeNextMatchesView: UIView, HorizontalSectionsViewDelegate {
    
    // MARK: - Properties
    var dataSource:[ScheduleMatchesGroup] = []
    var ticketTrackEvent:Int?
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Próximos jogos".uppercased()
        return lbl
    }()
    let loadingView:ContentLoadingView = ContentLoadingView()
    private let shadowView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        vw.layer.shadowOpacity = 0.2
        vw.layer.shadowRadius = 5.0
        vw.layer.shadowOffset = CGSize(width: 0, height: 4)
        return vw
    }()
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.ScheduleBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 20.0
        return vw
    }()
    private let footerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryButtonBackground)
        vw.layer.cornerRadius = 20.0
        vw.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return vw
    }()
    lazy var btnFooter:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("VER AGENDA COMPLETA", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Knockout.Regular, size: 22)
        return btn
    }()
    private var contentHeightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private lazy var contentView:HorizontalSectionsView = {
        let vw = HorizontalSectionsView()
        vw.delegate = self
        vw.menuBar.titleFont = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 12)
        vw.menuBar.backgroundColor = UIColor.clear
        vw.menuBar.activeColor = UIColor(hexString: "FAD716")
        vw.menuBar.inactiveColor = Theme.color(.MutedText)
        vw.menuBar.horizontalBarColor = Theme.color(.PrimaryAnchor)
        vw.clipsToBounds = true
        return vw
    }()
    
    
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(items:[ScheduleMatchesGroup]) {
        self.dataSource.removeAll()
        self.dataSource = items
        
        var menuItems:[HorizontalSelectorItem] = []
        var pages:[UIView] = []
        
        for item in self.dataSource {
            guard let matchItem = item.items.first else {continue}
            menuItems.append(HorizontalSelectorItem(title: item.title, font: FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 12)))
            let vw = ClubHomeNextMatchesGroupView()
            vw.itemView.ticketTrackEvent = self.ticketTrackEvent
            vw.updateContent(item: matchItem)
            pages.append(vw)
        }
        
        self.contentView.updateContent(menuDataSource: menuItems, sectionsDataSource: pages, fixAtBottom: false)
        if self.dataSource.count > 0 {
            self.didSelectTab(at: 0)
        }
        
        self.btnFooter.isHidden = items.isEmpty
    }
    
    func didSelectTab(at index: Int) {
        DispatchQueue.main.async {
            guard index < self.dataSource.count else {return}
            let item = self.dataSource[index]
            self.contentHeightConstraint.constant = CGFloat(item.items.count) * ScheduleMatchItemView.defaultHeight
            UIView.animate(withDuration: 0.25) {
                UIApplication.topViewController()?.view.layoutIfNeeded()
            }
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 20, trailing: -20, top: 12, bottom: nil)
        // Content
        self.addSubview(self.contentView)
        self.addBoundsConstraintsTo(subView: self.contentView, leading: 10, trailing: -10, top: nil, bottom: nil)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.contentView, constant: 5)
        self.contentHeightConstraint = NSLayoutConstraint(item: self.contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: ScheduleMatchItemView.defaultHeight)
        self.contentHeightConstraint.priority = UILayoutPriority(999)
        self.addConstraint(self.contentHeightConstraint)
        // Footer
        self.addSubview(self.footerView)
        self.addCenterXAlignmentRelatedConstraintTo(subView: self.footerView, reference: self.contentView, constant: 0)
        self.addWidthRelatedConstraintTo(subView: self.footerView, reference: self.contentView)
        self.addVerticalSpacingTo(subView1: self.contentView, subView2: self.footerView, constant: 0)
        self.addBottomAlignmentConstraintTo(subView: self.footerView, constant: -20)
        self.footerView.addHeightConstraint(50)
        // Footer Action
        self.footerView.addSubview(self.btnFooter)
        self.footerView.addCenterXAlignmentConstraintTo(subView: self.btnFooter, constant: 0)
        self.footerView.addCenterYAlignmentConstraintTo(subView: self.btnFooter, constant: 0)
        self.btnFooter.addHeightConstraint(40)
        // Back View
        self.insertSubview(self.shadowView, belowSubview: self.contentView)
        self.shadowView.addSubview(self.containerView)
        self.addTopAlignmentRelatedConstraintTo(subView: self.containerView, reference: self.contentView, constant: 0)
        self.addBottomAlignmentRelatedConstraintTo(subView: self.containerView, reference: self.footerView, constant: 0)
        self.addLeadingAlignmentRelatedConstraintTo(subView: self.containerView, reference: self.contentView, constant: 0)
        self.addTrailingAlignmentRelatedConstraintTo(subView: self.containerView, reference: self.contentView, constant: 0)
        // Loading
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addTopAlignmentRelatedConstraintTo(subView: self.loadingView, reference: self.contentView, constant: 70)
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







class ClubHomeNextMatchesGroupView: UIView {
    
    // MARK: - Objects
    let itemView:ScheduleMatchItemView = ScheduleMatchItemView()
    
    
    // MARK: - Methods
    func updateContent(item:ScheduleMatchItem) {
        self.itemView.updateContent(item: item)
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.itemView)
        self.addBoundsConstraintsTo(subView: self.itemView, leading: 10, trailing: -10, top: 0, bottom: 0)
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

