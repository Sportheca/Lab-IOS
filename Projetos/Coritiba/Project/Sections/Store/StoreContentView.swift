//
//  StoreContentView.swift
//
//
//  Created by Roberto Oliveira on 13/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol StoreContentViewDelegate:AnyObject {
    func storeContentView(storeContentView:StoreContentView, didSelectItem item:StoreItem)
    func storeContentView(storeContentView:StoreContentView, didSelectSearch search:String)
}

class StoreContentView: UIView, StoreGroupCellDelegate, StoreSearchHeaderViewDelegate {
    
    // MARK: - Properties
    weak var delegate:StoreContentViewDelegate?
    private var dataSource:[StoreGroup] = []
    
    // MARK: - Objects
    private lazy var searchView:StoreSearchHeaderView = {
        let vw = StoreSearchHeaderView()
        vw.delegate = self
        return vw
    }()
    private lazy var tableView:UITableView = {
        let tbv = UITableView()
        tbv.register(StoreGroupCell.self, forCellReuseIdentifier: "StoreGroupCell")
        tbv.dataSource = self
        tbv.delegate = self
        tbv.separatorStyle = .none
        tbv.showsVerticalScrollIndicator = false
        tbv.backgroundColor = UIColor.clear
        tbv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        return tbv
    }()
    
    
    // MARK: - Methods
    func updateContent(items:[StoreGroup]) {
        self.dataSource.removeAll()
        self.dataSource = items
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func storeSearchHeaderView(storeSearchHeaderView: StoreSearchHeaderView, didSelectSearch search: String) {
        self.delegate?.storeContentView(storeContentView: self, didSelectSearch: search)
    }
    
    func storeGroupCell(storeGroupCell: StoreGroupCell, didSelectItem item: StoreItem) {
        self.delegate?.storeContentView(storeContentView: self, didSelectItem: item)
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.tableView)
        self.addFullBoundsConstraintsTo(subView: self.tableView, constant: 0)
        self.searchView.frame = CGRect(x: 0, y: 0, width: 0, height: 120)
        self.tableView.tableHeaderView = self.searchView
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




extension StoreContentView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreGroupCell", for: indexPath) as! StoreGroupCell
        cell.updateContent(item: self.dataSource[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    
}







protocol StoreSearchHeaderViewDelegate:AnyObject {
    func storeSearchHeaderView(storeSearchHeaderView:StoreSearchHeaderView, didSelectSearch search:String)
}

class StoreSearchHeaderView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    weak var delegate:StoreSearchHeaderViewDelegate?
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.clipsToBounds = true
        vw.backgroundColor = UIColor.clear
        vw.layer.cornerRadius = 15.0
        vw.layer.borderWidth = 1.0
        vw.layer.borderColor = UIColor(hexString: "FFFFFF").cgColor
        return vw
    }()
    private lazy var btnSearch:CustomButton = {
        let btn = CustomButton()
        btn.setImage(UIImage(named: "icon_search")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.highlightedAlpha = 0.6
        btn.highlightedScale = 1.0
        btn.backgroundColor = UIColor.clear
        btn.adjustsImageWhenHighlighted = false
        btn.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        btn.addTarget(self, action: #selector(self.actionMethod), for: .touchUpInside)
        return btn
    }()
    lazy var textfield:CustomTextField = {
        let txf = CustomTextField()
        txf.delegate = self
        txf.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
        txf.placeholderColor = Theme.color(.MutedText)
        txf.textColor = UIColor(hexString: "9EA0A2")
        txf.backgroundColor = UIColor.clear
        txf.returnKeyType = .search
        txf.placeholder = "Procurando por algo específico?"
        txf.keyboardAppearance = .dark
        txf.addTarget(self, action: #selector(self.changed), for: .editingChanged)
        return txf
    }()
    
    
    // MARK: - Methods
    @objc func actionMethod() {
        self.confirm()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.confirm()
        return true
    }
    
    @objc func changed() {
        self.updateSearchButton()
    }
    
    private func confirm() {
        let txt = self.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.textfield.resignFirstResponder()
        self.delegate?.storeSearchHeaderView(storeSearchHeaderView: self, didSelectSearch: txt)
    }
    
    private func updateSearchButton() {
        let txt = self.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if txt == "" {
            self.btnSearch.backgroundColor = UIColor.clear
            self.btnSearch.tintColor = Theme.color(.MutedText)
        } else {
            self.btnSearch.backgroundColor = UIColor.clear
            self.btnSearch.tintColor = Theme.color(.PrimaryButtonText)
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Container
        self.addSubview(self.containerView)
        self.addBoundsConstraintsTo(subView: self.containerView, leading: 20, trailing: -20, top: nil, bottom: -10)
        self.containerView.addHeightConstraint(50)
        // icon
        self.containerView.addSubview(self.btnSearch)
        self.containerView.addBoundsConstraintsTo(subView: btnSearch, leading: nil, trailing: 0, top: 0, bottom: 0)
        self.addConstraint(NSLayoutConstraint(item: self.btnSearch, attribute: .width, relatedBy: .equal, toItem: self.btnSearch, attribute: .height, multiplier: 1.0, constant: 0))
        // textfield
        self.containerView.addSubview(self.textfield)
        self.containerView.addBoundsConstraintsTo(subView: self.textfield, leading: 15, trailing: nil, top: 0, bottom: 0)
        self.containerView.addHorizontalSpacingTo(subView1: self.textfield, subView2: self.btnSearch, constant: 5)
        self.textfield.addDefaultAccessory()
        self.updateSearchButton()
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
