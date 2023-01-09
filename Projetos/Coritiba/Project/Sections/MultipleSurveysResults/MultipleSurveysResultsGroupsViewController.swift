//
//  MultipleSurveysResultsGroupsViewController.swift
//  
//
//  Created by Roberto Oliveira on 3/17/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MultipleSurveysResultsGroupsViewController: BaseViewController, PaginationContentViewDelegate {
    
    // MARK: - Properties
    var trackEvent:Int?
    
    
    // MARK: - Objects
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
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 16)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Meus Palpites"
        return lbl
    }()
    private lazy var contentView:MultipleSurveysResultsGroupsContentView = {
        let vw = MultipleSurveysResultsGroupsContentView()
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        vw.paginationDelegate = self
        vw.delegate = self
        return vw
    }()
    
    
    
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.MultipleSurveysResultsGroups.close, trackValue: nil)
        self.dismissAction()
    }
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.MultipleSurveysResultsGroups.tryAgain
        self.loadContent()
    }
    
    func didPullToReload() {
        self.trackEvent = EventTrack.MultipleSurveysResultsGroups.pullToReload
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
        ServerManager.shared.getMultipleSurveysResultsGroups(page: self.contentView.currentPage, trackEvent: self.trackEvent) { (objects:[MultipleSurveysResultsGroup]?, limit:Int?, margin:Int?) in
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.contentView.dataSource.isEmpty {
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
        self.view.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.contentView, constant: 10)
        self.view.addBoundsConstraintsTo(subView: self.contentView, leading: 0, trailing: 0, top: nil, bottom: 0)
    }
    
}






extension MultipleSurveysResultsGroupsViewController: MultipleSurveysResultsGroupsContentViewDelegate {
    
    func multipleSurveysResultsGroupsContentView(multipleSurveysResultsGroupsContentView: MultipleSurveysResultsGroupsContentView, didSelectGroup group: MultipleSurveysResultsGroup) {
        DispatchQueue.main.async {
            let vc = MultipleSurveysResultsGroupViewController()
            vc.trackEvent = EventTrack.MultipleSurveysResultsGroups.selectGroup
            vc.currentGroup = group
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}




