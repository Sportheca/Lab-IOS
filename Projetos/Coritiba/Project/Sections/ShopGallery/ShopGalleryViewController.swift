//
//  ShopGalleryViewController.swift
//  
//
//  Created by Roberto Oliveira on 30/04/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class ShopGalleryViewController: BaseViewController {
    
    // MARK: - Properties
    var trackEvent:Int?
    private var searchString:String = ""
    private var filtersDataSource:[BasicInfo] = []
    private var selectedFilterID:Int = 0
    
    
    // MARK: - Objects
    private let headerView:PageHeaderView = {
        let vw = PageHeaderView()
        vw.updateContent(title: ProjectInfoManager.TextInfo.loja_titulo.rawValue, subtitle: ProjectInfoManager.TextInfo.loja_subtitulo.rawValue)
        return vw
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PageHeaderText), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private let coinsView:CoinsView = {
        let vw = CoinsView()
        vw.lblCoins.textColor = Theme.color(.PageHeaderText)
        return vw
    }()
    private lazy var contentView:ShopGalleryContentView = {
        let vw = ShopGalleryContentView()
        vw.paginationDelegate = self
        vw.delegate = self
        vw.searchView.btnFilter.addTarget(self, action: #selector(self.openFilters), for: .touchUpInside)
        return vw
    }()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var footerView:ShopGalleryFooterView = {
        let vw = ShopGalleryFooterView()
        vw.btnClose.addTarget(self, action: #selector(self.dismissFooter), for: .touchUpInside)
        return vw
    }()
    
    
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.ShopGallery.close, trackValue: nil)
        self.dismissAction()
    }
    
    @objc func openFilters() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.ShopGallery.openFilters, trackValue: nil)
        DispatchQueue.main.async {
            let vc = ShopGalleryFiltersViewController()
            vc.dataSource = self.filtersDataSource
            vc.selectedID = self.selectedFilterID
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func dismissFooter() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.ShopGallery.dismissFooter, trackValue: nil)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.footerView.transform = CGAffineTransform(translationX: 0, y: 200)
            }) { (_) in
                self.footerView.removeFromSuperview()
            }
        }
    }
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.coinsView.updateContent()
    }
    
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
        // Coins
        self.view.addSubview(self.coinsView)
        self.view.addTopAlignmentRelatedConstraintTo(subView: self.coinsView, reference: self.btnClose, constant: 0)
        self.view.addTrailingAlignmentConstraintTo(subView: self.coinsView, constant: -20)
        // Header
        self.view.insertSubview(self.headerView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: 0, bottom: nil)
        // Content
        self.view.insertSubview(self.contentView, belowSubview: self.headerView)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.contentView, constant: -25)
        self.view.addBoundsConstraintsTo(subView: self.contentView, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentRelatedConstraintTo(subView: self.loadingView, reference: self.contentView, constant: 0)
        // Footer
        self.view.addSubview(self.footerView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.footerView, constant: 0)
        self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.footerView, constant: -20)
        self.footerView.addWidthConstraint(320)
        self.footerView.alpha = 0.0
    }
    
    override var canBecomeFirstResponder: Bool {return true}
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    
}



extension ShopGalleryViewController: ShopGalleryContentViewDelegate {
    
    func shopGalleryContentView(shopGalleryContentView: ShopGalleryContentView, didSelectItem item: ShopGalleryItem) {
        ServerManager.shared.setTrack(trackEvent: EventTrack.ShopGallery.openProduct, trackValue: item.id)
        DispatchQueue.main.async {
            guard let link = item.link else {return}
            DispatchQueue.main.async {
                BaseWebViewController.open(urlString: link, mode: item.isEmbed)
            }
        }
    }
    
    func shopGalleryContentView(shopGalleryContentView: ShopGalleryContentView, didSelectSearch search: String) {
        self.searchString = search
        self.contentView.currentPage = 1
        self.loadContent()
    }
    
    
}




// MARK: - Badges
extension ShopGalleryViewController: PaginationContentViewDelegate {
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.ShopGallery.tryAgain
        self.loadContent()
    }
    
    func didPullToReload() {
        self.trackEvent = EventTrack.ShopGallery.pullToReload
        self.contentView.currentPage = 1
        self.loadContent()
    }
    
    
    func loadNexPage() {
        self.loadContent()
    }
    
    private func loadContent() {
        DispatchQueue.main.async {
            if self.contentView.currentPage == 1 {
                self.loadingView.startAnimating()
                self.contentView.collectionView.isHidden = true
            }
        }
        ServerManager.shared.getShopGalleryItems(home: false, searchString: self.searchString, page: self.contentView.currentPage, filterID: self.selectedFilterID, trackEvent: self.trackEvent) { (objects:[ShopGalleryItem]?, limit:Int?, margin:Int?) in
            self.trackEvent = nil
            let items = objects ?? []
            DispatchQueue.main.async() {
                if self.contentView.currentPage == 1 {
                    self.footerView.alpha = 1
                    self.contentView.updateContent(items: items, limit: limit, margin: margin)
                    if items.isEmpty {
                        self.loadingView.emptyResults()
                    } else {
                        self.contentView.collectionView.isHidden = false
                        self.loadingView.stopAnimating()
                    }
                } else {
                    self.contentView.addContent(items: items)
                }
            }
        }
    }
    
    
}




// MARK: - Filters Delegate
extension ShopGalleryViewController: ShopGalleryFiltersViewControllerDelegate {
    
    func shopGalleryFiltersViewController(shopGalleryFiltersViewController: ShopGalleryFiltersViewController, didSelectItem item: BasicInfo) {
        self.selectedFilterID = item.id
        self.contentView.currentPage = 1
        ServerManager.shared.setTrack(trackEvent: EventTrack.ShopGalleryFilters.selectFilter, trackValue: item.id)
        self.loadContent()
    }
    
    func shopGalleryFiltersViewController(shopGalleryFiltersViewController: ShopGalleryFiltersViewController, didLoadItems items: [BasicInfo]) {
        self.filtersDataSource = items
    }
    
}
