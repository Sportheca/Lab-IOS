//
//  AllNewsViewController.swift
//  
//
//  Created by Roberto Oliveira on 02/04/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class AllNewsViewController: BaseViewController {
    
    // MARK: - Properties
    var trackEvent:Int?
    private var filtersDataSource:[BasicInfo] = []
    private var selectedFilterID:Int = 0
    
    
    
    // MARK: - Objects
    private let headerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryBackground)
        return vw
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Destaques".uppercased()
        return lbl
    }()
    private lazy var contentView:AllNewsContentView = {
        let vw = AllNewsContentView()
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        vw.paginationDelegate = self
        return vw
    }()
    private lazy var btnFilter:CustomButton = {
        let btn = CustomButton()
        btn.setImage(UIImage(named: "btn_all_news_filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = Theme.color(.PrimaryText)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.adjustsImageWhenHighlighted = false
        btn.highlightedAlpha = 0.6
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.openFilters), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AllNews.close, trackValue: nil)
        self.dismissAction()
    }
    
    @objc func openFilters() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AllNews.openFilters, trackValue: nil)
        DispatchQueue.main.async {
            let vc = AllNewsFiltersViewController()
            vc.dataSource = self.filtersDataSource
            vc.selectedID = self.selectedFilterID
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - Super Methods
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.loadContent()
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
        self.view.addVerticalSpacingTo(subView1: self.btnClose, subView2: self.lblTitle, constant: 10)
        self.view.addLeadingAlignmentRelatedConstraintTo(subView: self.lblTitle, reference: self.btnClose, constant: 0)
        // Filters
        self.view.addSubview(self.btnFilter)
        self.view.addTopAlignmentRelatedConstraintTo(subView: self.btnFilter, reference: self.btnClose, constant: 0)
        self.view.addTrailingAlignmentConstraintTo(subView: self.btnFilter, constant: -10)
        self.btnFilter.addWidthConstraint(40)
        self.btnFilter.addHeightConstraint(40)
        // Header
        self.view.insertSubview(self.headerView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.view.addBottomAlignmentRelatedConstraintTo(subView: self.headerView, reference: self.lblTitle, constant: 10)
        // Content
        self.view.addSubview(self.contentView)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.contentView, constant: 0)
        self.view.addBoundsConstraintsTo(subView: self.contentView, leading: 0, trailing: 0, top: nil, bottom: 0)
    }
    
}





// MARK: - Badges
extension AllNewsViewController: PaginationContentViewDelegate {
    
    func didPullToReload() {
        self.trackEvent = EventTrack.AllNews.pullToReload
        self.loadContent()
    }
    
    
    func loadNexPage() {
        self.loadContent()
    }
    
    private func loadContent() {
        DispatchQueue.main.async {
            if self.contentView.dataSource.isEmpty {
                self.contentView.loadingView.startAnimating()
                self.contentView.collectionView.isHidden = true
            }
        }
        ServerManager.shared.getAllNews(filterID: self.selectedFilterID, page: self.contentView.currentPage, trackEvent: self.trackEvent) { (objects:[AllNewsItem]?, limit:Int?, margin:Int?) in
            self.trackEvent = nil
            let items = objects ?? []
            DispatchQueue.main.async() {
                if self.contentView.currentPage == 1 {
                    self.contentView.updateContent(items: items, limit: limit, margin: margin)
                    if items.isEmpty {
                        self.contentView.loadingView.emptyResults()
                    } else {
                        self.contentView.collectionView.isHidden = false
                        self.contentView.loadingView.stopAnimating()
                    }
                } else {
                    self.contentView.addContent(items: items)
                }
            }
        }
    }
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.AllNews.tryAgain
        self.loadContent()
    }
    
    
}




// MARK: - Filters Delegate
extension AllNewsViewController: AllNewsFiltersViewControllerDelegate {
    
    func allNewsFiltersViewController(allNewsFiltersViewController: AllNewsFiltersViewController, didSelectItem item: BasicInfo) {
        self.selectedFilterID = item.id
        self.contentView.currentPage = 1
        ServerManager.shared.setTrack(trackEvent: EventTrack.AllNewsFilters.selectFilter, trackValue: item.id)
        self.loadContent()
    }
    
    func allNewsFiltersViewController(allNewsFiltersViewController: AllNewsFiltersViewController, didLoadItems items: [BasicInfo]) {
        self.filtersDataSource = items
    }
    
}
