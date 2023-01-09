//
//  VideosCategoryViewController.swift
//
//
//  Created by Roberto Oliveira on 17/02/21.
//  Copyright © 2021 Roberto Oliveira. All rights reserved.
//

import UIKit

class VideosCategoryViewController: BaseViewController {
    
    // MARK: - Properties
    var trackEvent:Int?
    var currentGroup:VideosGroup?
    
    
    
    
    // MARK: - Objects
    private let headerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear//Theme.color(.PrimaryBackground)
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
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 21)
        lbl.textColor = UIColor(hexString: "FAD716")
        lbl.text = ""
        return lbl
    }()
    private lazy var contentView:VideosCategoryContentView = {
        let vw = VideosCategoryContentView()
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        vw.paginationDelegate = self
        return vw
    }()
    
    private lazy var ivBackground: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bg_gramado")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    
    // MARK: - Methods
    @objc func close() {
        //ServerManager.shared.setTrack(trackEvent: EventTrack.AllNews.close, trackValue: nil)
        self.dismissAction()
    }
    
    
    
    
    // MARK: - Super Methods
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.lblTitle.text = self.currentGroup?.title
        self.loadContent()
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
//        self.ivDefaultBackground.isHidden = false
        self.view.addSubview(self.ivBackground)
        self.view.addFullBoundsConstraintsTo(subView: self.ivBackground, constant: 0)
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // Title
        self.view.addSubview(self.lblTitle)
        self.view.addVerticalSpacingTo(subView1: self.btnClose, subView2: self.lblTitle, constant: 10)
        self.view.addLeadingAlignmentRelatedConstraintTo(subView: self.lblTitle, reference: self.btnClose, constant: 0)
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
extension VideosCategoryViewController: PaginationContentViewDelegate {
    
    func didPullToReload() {
        self.trackEvent = nil//EventTrack.AllNews.pullToReload
        self.loadContent()
    }
    
    
    func loadNexPage() {
        self.loadContent()
    }
    
    private func loadContent() {
        guard let group = self.currentGroup else {return}
        DispatchQueue.main.async {
            if self.contentView.dataSource.isEmpty {
                self.contentView.loadingView.startAnimating()
                self.contentView.collectionView.isHidden = true
            }
        }
        ServerManager.shared.getAllVideosCategory(group: group, page: self.contentView.currentPage, trackEvent: self.trackEvent) { (objects:[VideoItem]?, limit:Int?, margin:Int?) in
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
        self.trackEvent = nil//EventTrack.AllNews.tryAgain
        self.loadContent()
    }
    
    
}




