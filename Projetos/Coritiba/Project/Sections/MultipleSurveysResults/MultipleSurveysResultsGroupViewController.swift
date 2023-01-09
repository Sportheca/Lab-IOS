//
//  MultipleSurveysResultsGroupViewController.swift
//  
//
//  Created by Roberto Oliveira on 3/17/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MultipleSurveysResultsGroupViewController: BaseViewController {
    
    // MARK: - Properties
    var trackEvent:Int?
    var currentGroup:MultipleSurveysResultsGroup?
    var dataSource:[MultipleSurveysResultsGroupAnswerItem] = []
    
    
    // MARK: - Objects
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryCardElements), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private let headerView:MultipleSurveysResultsGroupHeaderView = MultipleSurveysResultsGroupHeaderView()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var tableView:UITableView = {
        let tbv = UITableView()
        tbv.separatorStyle = .none
        tbv.dataSource = self
        tbv.delegate = self
        tbv.alwaysBounceVertical = true
        tbv.register(MultipleSurveysResultsGroupAnswerItemCell.self, forCellReuseIdentifier: "MultipleSurveysResultsGroupAnswerItemCell")
        tbv.showsVerticalScrollIndicator = false
        tbv.backgroundColor = UIColor.clear
        tbv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tbv.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        return tbv
    }()
    
    
    
    
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.MultipleSurveysResultsGroup.close, trackValue: nil)
        self.dismissAction()
    }
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.MultipleSurveysResultsGroup.tryAgain
        self.loadContent()
    }
    
    private func loadContent() {
        guard let group = self.currentGroup else {return}
        DispatchQueue.main.async {
            self.headerView.updateContent(group: group, items: self.dataSource, animated: false)
            self.loadingView.startAnimating()
        }
        ServerManager.shared.getMultipleSurveysResultsGroup(id: group.id, trackEvent: self.trackEvent) { (objects:[MultipleSurveysResultsGroupAnswerItem]?) in
            self.trackEvent = nil
            DispatchQueue.main.async {
                self.dataSource = objects ?? []
                if self.dataSource.isEmpty {
                    self.loadingView.emptyResults()
                } else {
                    self.loadingView.stopAnimating()
                }
                self.headerView.updateContent(group: group, items: self.dataSource, animated: true)
                self.tableView.reloadData()
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
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 20)
        // Header
        self.view.insertSubview(self.headerView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.view.addCenterYAlignmentRelatedConstraintTo(subView: self.headerView.lblX, reference: self.btnClose, constant: 0)
        // Content
        self.view.insertSubview(self.tableView, belowSubview: self.headerView)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.tableView, constant: -50)
        self.view.addBoundsConstraintsTo(subView: self.tableView, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
    }
    
}





extension MultipleSurveysResultsGroupViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleSurveysResultsGroupAnswerItemCell", for: indexPath) as! MultipleSurveysResultsGroupAnswerItemCell
        let item = self.dataSource[indexPath.row]
        let headerTitle = "Pergunta \(indexPath.row+1)/\(self.dataSource.count)"
        cell.updateContent(item: item, headerTitle: headerTitle)
        return cell
    }
    
}
