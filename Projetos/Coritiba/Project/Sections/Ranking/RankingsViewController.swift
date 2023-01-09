//
//  RankingsViewController.swift
//  
//
//  Created by Roberto Oliveira on 13/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class RankingsViewController: BaseViewController, RankingsGroupsViewDelegate {
    
    // MARK: - Properties
    private var loadingStatus:LoadingStatus = .NotRequested
    private var userInfo:RankingItem?
    private var dataSource:[RankingItem] = []
    private var groupsDataSource:[RankingGroup] = []
    private var selectedGroupItem:RankingGroup?
    var trackEvent:Int?
    
    // MARK: - Pagination
    var itemsBeforeNextPage = 30
    var pageInterval:Int = 100
    var currentPage:Int = 1
    
    
    // MARK: - Objects
    let headerView:PageHeaderView = {
        let vw = PageHeaderView()
        vw.updateContent(title: "Ranking", subtitle: "Selecione a categoria do ranking que deseja ver.")
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
    private lazy var groupsView:RankingsGroupsView = {
        let vw = RankingsGroupsView()
        vw.delegate = self
        return vw
    }()
    private lazy var tableView:UITableView = {
        let tbv = UITableView()
        tbv.register(RankingItemTableViewCell.self, forCellReuseIdentifier: "RankingItemTableViewCell")
        tbv.dataSource = self
        tbv.delegate = self
        tbv.separatorStyle = .none
        tbv.showsVerticalScrollIndicator = false
        tbv.backgroundColor = UIColor.clear
        tbv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        return tbv
    }()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var btnHelp:CustomButton = {
        let btn = CustomButton()
        btn.setImage(UIImage(named: "icon_info")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = UIColor.white
        btn.imageView?.contentMode = .scaleAspectFit
        btn.adjustsImageWhenHighlighted = false
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.addTarget(self, action: #selector(self.openHelp), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    
    // MARK: - Methods
    private func updateHelpButton() {
        DispatchQueue.main.async {
            let message = self.selectedGroupItem?.helpMessage ?? ""
            self.btnHelp.isHidden = message == ""
        }
    }
    
    @objc func openHelp() {
        let message = self.selectedGroupItem?.helpMessage ?? ""
        guard message != "" else {return}
        DispatchQueue.main.async {
            self.titleAlert(title: "", message: message, handler: nil)
        }
    }
    
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Rankings.close, trackValue: nil)
        self.dismissAction()
    }
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.Rankings.tryAgain
        self.loadContent()
    }
    
    private func loadContent() {
        if self.groupsDataSource.isEmpty {
            // Load Ranking Groups
            DispatchQueue.main.async {
                self.loadingView.startAnimating()
                self.tableView.isHidden = true
            }
            self.loadingStatus = .Loading
            ServerManager.shared.getRankingGroups(trackEvent: self.trackEvent) { (items:[RankingGroup]?) in
                self.trackEvent = nil
                self.groupsDataSource = items ?? []
                if self.groupsDataSource.count > 0 {
                    if self.selectedGroupItem == nil {
                        self.selectedGroupItem = self.groupsDataSource.first
                    }
                    self.updateHelpButton()
                    self.groupsView.updateContent(items: self.groupsDataSource, selectedId: self.selectedGroupItem?.id)
                    self.loadContent()
                } else {
                    DispatchQueue.main.async {
                        self.loadingView.emptyResults()
                    }
                }
            }
            return
        }
        // Load Ranking Items
        guard let selected = self.selectedGroupItem else {return}
        if self.loadingStatus != .Loading && self.currentPage == 1 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.loadingView.startAnimating()
            }
        }
        self.loadingStatus = .Loading
        ServerManager.shared.getRanking(id: selected.id, page: self.currentPage, trackEvent: nil) { (items:[RankingItem]?, userItem:RankingItem?, limit:Int?, margin:Int?) in
            self.loadingStatus = .Completed
            self.pageInterval = limit ?? self.pageInterval
            self.itemsBeforeNextPage = margin ?? self.itemsBeforeNextPage
            self.userInfo = userItem ?? self.userInfo
            
            let objects = items ?? []
            if self.currentPage == 1 {
                self.dataSource = objects
            } else {
                self.dataSource.append(contentsOf: objects)
            }
            
            DispatchQueue.main.async {
                if self.dataSource.isEmpty {
                    self.loadingView.emptyResults()
                } else {
                    self.loadingView.stopAnimating()
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                }
            }
        }
        
    }
    
    func rankingsGroupsView(rankingsGroupsView: RankingsGroupsView, didSelectItem item: RankingGroup) {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Rankings.selectGroup, trackValue: item.id)
        if item.id != self.selectedGroupItem?.id {
            self.selectedGroupItem = item
            self.updateHelpButton()
            self.dataSource.removeAll()
            self.userInfo = nil
            self.currentPage = 1
            self.loadContent()
        }
    }
    
    
    private func handlePagination(indexPath:IndexPath) {
        let i = (((self.currentPage*self.pageInterval)-self.itemsBeforeNextPage)-1)
        if indexPath.item == i {
            // If it is x items from the end, load next pagination block
            self.currentPage += 1
            self.loadContent()
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
        // Header
        self.view.insertSubview(self.headerView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: 0, bottom: nil)
        // Table
        self.view.insertSubview(self.tableView, belowSubview: self.headerView)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.tableView, constant: -25)
        self.view.addBoundsConstraintsTo(subView: self.tableView, leading: 0, trailing: 0, top: nil, bottom: 0)
        // groups
        self.groupsView.frame = CGRect(x: 0, y: 0, width: 0, height: RankingsGroupsView.defaultHeight)
        self.tableView.tableHeaderView = self.groupsView
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.loadingView, constant: 200)
        // help
        self.headerView.addSubview(self.btnHelp)
        self.headerView.addTopAlignmentRelatedConstraintTo(subView: self.btnHelp, reference: self.headerView.lblTitle, constant: 0)
        self.headerView.addHorizontalSpacingTo(subView1: self.headerView.lblTitle, subView2: self.btnHelp, constant: 0)
        self.btnHelp.addHeightConstraint(40)
        self.btnHelp.addWidthConstraint(40)
        self.btnHelp.isHidden = true
    }
    
}




extension RankingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    // header
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard !self.dataSource.isEmpty else {return 0}
        return RankingListHeaderView.defaultHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard !self.dataSource.isEmpty else {return 0}
        return RankingListHeaderView.defaultHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !self.dataSource.isEmpty else {return nil}
        let vw = RankingListHeaderView()
        vw.backgroundColor = self.view.backgroundColor
        vw.itemView.updateContent(item: self.userInfo, isHighlighted: true)
        vw.itemView.alpha = self.userInfo == nil ? 0 : 1
        return vw
    }
    
    
    
    // cells
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return RankingItemView.defaultHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.handlePagination(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingItemTableViewCell", for: indexPath) as! RankingItemTableViewCell
        let item = self.dataSource[indexPath.item]
        cell.itemView.updateContent(item: item, isHighlighted: item.id == ServerManager.shared.user?.id)
        return cell
    }
    
}
