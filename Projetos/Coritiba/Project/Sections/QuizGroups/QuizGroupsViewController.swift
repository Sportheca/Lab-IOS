//
//  QuizGroupsViewController.swift
//  
//
//  Created by Roberto Oliveira on 07/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class QuizGroupsViewController: BaseViewController {
    
    // MARK: - Properties
    private var trackEvent:Int?
    
    
    
    // MARK: - Objects
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var contentView:QuizGroupsContentView = {
        let vw = QuizGroupsContentView()
        vw.delegate = self
        vw.paginationDelegate = self
        return vw
    }()
    
    
    // MARK: - Methods
    @objc func tryAgain() {
        self.trackEvent = EventTrack.QuizGroups.tryAgain
        self.loadContent()
    }
    
    private func loadContent() {
        DispatchQueue.main.async {
            if self.contentView.dataSource.isEmpty {
                self.contentView.isHidden = true
                self.loadingView.startAnimating()
            }
        }
        ServerManager.shared.getQuizGroups(referenceId: nil, page: self.contentView.currentPage, trackEvent: self.trackEvent) { (items:[QuizGroup]?, limit:Int?, margin:Int?) in
            self.trackEvent = nil
            DispatchQueue.main.async {
                if self.contentView.dataSource.isEmpty {
                    self.contentView.updateContent(items: items ?? [], limit: limit, margin: margin)
                    if (items ?? []).isEmpty {
                        self.loadingView.emptyResults()
                    } else {
                        self.contentView.isHidden = false
                        self.loadingView.stopAnimating()
                    }
                } else {
                    self.contentView.addContent(items: items ?? [])
                }
            }
        }
    }
    
    private func showDetailsAt(group:QuizGroup, colorScheme:ColorScheme, isLoadingCompleted:Bool = true) {
        ServerManager.shared.setTrack(trackEvent: EventTrack.QuizGroups.selectGroup, trackValue: group.id)
        DispatchQueue.main.async {
            let vc = QuizGroupViewController()
            vc.colorScheme = colorScheme
            vc.loadingStatus = isLoadingCompleted ? .Completed : .NotRequested
            vc.currentItem = group
            // present
            vc.extendedLayoutIncludesOpaqueBars = true
            vc.edgesForExtendedLayout = [.all]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func showGroupWithID(_ id:Int) {
        let items = self.contentView.dataSource as? [QuizGroup] ?? []
        for (index, item) in items.enumerated() {
            if item.id == id {
                self.showDetailsAt(group: item, colorScheme: ColorScheme.schemeAt(index: index), isLoadingCompleted: true)
                return
            }
        }
        let group = QuizGroup(id: id)
        self.showDetailsAt(group: group, colorScheme: ColorScheme.schemeAt(index: 0), isLoadingCompleted: false)
    }
    
    
    
    
    
    
    // MARK: - Super Methods
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.loadContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentView.collectionView.reloadData()
    }
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.view.backgroundColor = Theme.color(.PrimaryCardBackground)
        // Content
        self.view.addSubview(self.contentView)
        self.view.addFullBoundsConstraintsTo(subView: self.contentView, constant: 0)
        // loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
    }
    
}



extension QuizGroupsViewController: PaginationContentViewDelegate, QuizGroupsContentViewDelegate {
    func didPullToReload() {
        self.trackEvent = EventTrack.QuizGroups.pullToReload
        self.loadContent()
    }
    
    
    func quizGroupsContentView(quizGroupsContentView: QuizGroupsContentView, didSelectGroup group: QuizGroup, atIndexPath indexPath: IndexPath) {
        self.showDetailsAt(group: group, colorScheme: ColorScheme.schemeAt(index: indexPath.item))
    }
    
    
    func loadNexPage() {
        self.loadContent()
    }
    
}
