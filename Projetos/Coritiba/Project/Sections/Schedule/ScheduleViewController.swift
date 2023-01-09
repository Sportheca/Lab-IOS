//
//  ScheduleViewController.swift
//
//
//  Created by Roberto Oliveira on 05/11/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class ScheduleViewController: BaseViewController {
    
    // MARK: - Properties
    var trackEvent:Int?
    var scrollToItemID:Int?
    var dataSource:[ScheduleMatchesGroup] = []
    
    
    
    // MARK: - Objects
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.dismissAction), for: .touchUpInside)
        return btn
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 16)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Próximos jogos"
        return lbl
    }()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var contentView:HorizontalSectionsView = {
        let vw = HorizontalSectionsView()
        vw.backgroundColor = Theme.color(.ScheduleBackground)
        //vw.delegate = self
        vw.menuBar.titleFont = FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 12)
        vw.menuBar.backgroundColor = UIColor.clear
        vw.menuBar.activeColor = Theme.color(.PrimaryAnchor)
        vw.menuBar.inactiveColor = Theme.color(.MutedText)
        vw.menuBar.horizontalBarColor = Theme.color(.PrimaryAnchor)
        vw.clipsToBounds = true
        return vw
    }()
    
    
    
    
    // MARK: - Methods
    @objc func tryAgain() {
        self.trackEvent = EventTrack.Schedule.tryAgain
        self.loadContent()
    }
    
    private func loadContent() {
        DispatchQueue.main.async {
            self.loadingView.startAnimating()
            self.contentView.isHidden = true
        }
        ServerManager.shared.getSchedule(home: false, trackEvent: self.trackEvent) { (objects:[ScheduleMatchesGroup]?, message:String?) in
            self.trackEvent = nil
            DispatchQueue.main.async {
                self.dataSource.removeAll()
                self.dataSource = objects ?? []
                
                if self.dataSource.isEmpty {
                    self.loadingView.emptyResults(title: message ?? "")
                    return
                }
                self.loadingView.stopAnimating()
                self.contentView.isHidden = false
                
                
                var scrollToPageIndex:Int?
                var menuItems:[HorizontalSelectorItem] = []
                var pages:[UIView] = []
                
                for (page, item) in self.dataSource.enumerated() {
                    menuItems.append(HorizontalSelectorItem(title: item.title, font: FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 12)))
                    let vw = ScheduleMatchesGroupView()
                    vw.ticketTrackEvent = EventTrack.Schedule.buyScheduleTickets
                    vw.updateContent(item: item)
                    pages.append(vw)
                    if let i = self.scrollToItemID {
                        for groupItem in item.items {
                            if groupItem.id == i {
                                scrollToPageIndex = page
                            }
                        }
                    }
                }
                
                
                self.contentView.updateContent(menuDataSource: menuItems, sectionsDataSource: pages, fixAtBottom: true)
                // scroll to page if needed
                if let selectedPage = scrollToPageIndex {
                    self.contentView.didSelectItem(with: self.contentView.menuBar, at: IndexPath(item: selectedPage, section: 0))
                    self.contentView.menuBar.collectionView.selectItem(at: IndexPath(item: selectedPage, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                    self.contentView.menuBar.selectedIndexPath = IndexPath(item: selectedPage, section: 0)
                }
                
            }
        }
    }
    
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.dataSource.isEmpty {
            self.loadContent()
        }
    }
    
    
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // Title
        self.view.addSubview(self.lblTitle)
        self.view.addLeadingAlignmentRelatedConstraintTo(subView: self.lblTitle, reference: self.btnClose, constant: 0)
        self.view.addVerticalSpacingTo(subView1: self.btnClose, subView2: self.lblTitle, constant: 5)
        self.lblTitle.addHeightConstraint(25)
        // Content
        self.view.addSubview(self.contentView)
        self.view.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.contentView, constant: 20)
        self.view.addBoundsConstraintsTo(subView: self.contentView, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        
    }
    
}




