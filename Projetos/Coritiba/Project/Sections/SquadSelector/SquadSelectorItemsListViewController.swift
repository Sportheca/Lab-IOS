//
//  SquadSelectorItemsListViewController.swift
//  
//
//  Created by Roberto Oliveira on 05/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol SquadSelectorItemsListViewControllerDelegate:AnyObject {
    func squadSelectorItemsListViewController(squadSelectorItemsListViewController:SquadSelectorItemsListViewController, didSelectItem item:SquadSelectorListItem)
    func squadSelectorItemsListViewController(squadSelectorItemsListViewController:SquadSelectorItemsListViewController, didFinishLoadItems items:[SquadSelectorListItem])
}

class SquadSelectorItemsListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    weak var delegate:SquadSelectorItemsListViewControllerDelegate?
    var dataSource:[SquadSelectorListItem] = []
    var selectedIds:[Int] = []
    var referenceID:Int?
    var trackEvent:Int?
    var trackValue:Int?
    
    var closeTrackEvent:Int? = EventTrack.SquadSelectorList.close
    var tryAgainTrackEvent:Int? = EventTrack.SquadSelectorList.tryAgain
    var selecteItemTrackEvent:Int? = EventTrack.SquadSelectorList.selectItem
    var closeAndTryAgainTrackValue:Int?
    
    // MARK: - Objects
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 15)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var tableView:UITableView = {
        let tbv = UITableView()
        tbv.register(SquadSelectorListItemCell.self, forCellReuseIdentifier: "SquadSelectorListItemCell")
        tbv.dataSource = self
        tbv.delegate = self
        tbv.separatorStyle = .none
        tbv.showsVerticalScrollIndicator = false
        tbv.backgroundColor = Theme.color(.AlternativeCardBackground)
        tbv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return tbv
    }()
    
    
    
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: self.closeTrackEvent, trackValue: self.closeAndTryAgainTrackValue ?? self.referenceID)
        self.dismissAction()
    }
    
    @objc func tryAgain() {
        self.trackEvent = self.tryAgainTrackEvent
        self.trackValue = self.closeAndTryAgainTrackValue
        self.loadContent()
    }
    
    private func loadContent() {
        self.dataSource.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.loadingView.startAnimating()
        }
        ServerManager.shared.getSquadSelectorItemsList(referenceID: self.referenceID, trackEvent: self.trackEvent, trackValue: self.trackValue) { (objects:[SquadSelectorListItem]?) in
            self.trackEvent = nil
            self.trackValue = nil
            DispatchQueue.main.async {
                self.dataSource = objects ?? []
                self.delegate?.squadSelectorItemsListViewController(squadSelectorItemsListViewController: self, didFinishLoadItems: self.dataSource)
                if self.dataSource.isEmpty {
                    self.loadingView.emptyResults()
                } else {
                    self.loadingView.stopAnimating()
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.dataSource[indexPath.row]
        ServerManager.shared.setTrack(trackEvent: self.selecteItemTrackEvent, trackValue: item.id)
        DispatchQueue.main.async {
            self.delegate?.squadSelectorItemsListViewController(squadSelectorItemsListViewController: self, didSelectItem: item)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                tableView.cellForRow(at: indexPath)?.alpha = 0.6
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                tableView.cellForRow(at: indexPath)?.alpha = 1.0
            }
        }
    }
    
    // layout
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SquadSelectorListItemCell", for: indexPath) as! SquadSelectorListItemCell
        let item = self.dataSource[indexPath.row]
        cell.updateContent(item: item, highlighted: self.selectedIds.contains(item.id))
        cell.separatorView.isHidden = indexPath.item == 0
        return cell
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
        self.view.backgroundColor = Theme.color(.PrimaryCardBackground)
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.btnClose, leading: 20, trailing: nil, top: 20, bottom: nil)
        // Header
        self.view.addSubview(self.lblHeader)
        self.view.addBoundsConstraintsTo(subView: self.lblHeader, leading: 10, trailing: -10, top: 50, bottom: nil)
        self.lblHeader.addHeightConstraint(23)
        // Content
        self.view.addSubview(self.tableView)
        self.view.addVerticalSpacingTo(subView1: self.lblHeader, subView2: self.tableView, constant: 15)
        self.view.addBoundsConstraintsTo(subView: self.tableView, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
    }
    
    
}






class SquadSelectorListItemCell: UITableViewCell {
    
    // MARK: - Objects
    let separatorView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardElements).withAlphaComponent(0.5)
        return vw
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 5.0
        return vw
    }()
    private let lblInfo0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 22)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblInfo1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 16)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblInfo2:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 22)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(item:SquadSelectorListItem, highlighted:Bool) {
        self.lblInfo0.text = item.title
        self.lblInfo1.text = item.subtitle
        self.lblInfo2.text = item.shirtNumber
        
        if highlighted {
            self.backgroundColor = Theme.color(.SecondaryCardBackground)
            self.lblInfo0.textColor = Theme.color(.SecondaryCardElements)
            self.lblInfo1.textColor = Theme.color(.SecondaryCardElements)
            self.lblInfo2.textColor = Theme.color(.SecondaryCardElements)
        } else {
            self.backgroundColor = Theme.color(.AlternativeCardBackground)
            self.lblInfo0.textColor = Theme.color(.AlternativeCardElements)
            self.lblInfo1.textColor = Theme.color(.PrimaryAnchor)
            self.lblInfo2.textColor = Theme.color(.AlternativeCardElements)
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.selectionStyle = .none
        self.addSubview(self.separatorView)
        self.separatorView.addHeightConstraint(1)
        self.addBoundsConstraintsTo(subView: self.separatorView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.addSubview(self.stackView)
        self.addBoundsConstraintsTo(subView: self.stackView, leading: 15, trailing: -10, top: 0, bottom: 0)
        self.stackView.addArrangedSubview(self.lblInfo0)
        self.stackView.addArrangedSubview(self.lblInfo1)
        self.stackView.addArrangedSubview(self.lblInfo2)
        self.lblInfo1.addWidthConstraint(80)
        self.lblInfo2.addWidthConstraint(35)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}
