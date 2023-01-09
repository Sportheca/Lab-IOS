//
//  ShopGalleryFiltersViewController.swift
//  
//
//  Created by Roberto Oliveira on 07/05/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol ShopGalleryFiltersViewControllerDelegate:AnyObject {
    func shopGalleryFiltersViewController(shopGalleryFiltersViewController:ShopGalleryFiltersViewController, didSelectItem item:BasicInfo)
    func shopGalleryFiltersViewController(shopGalleryFiltersViewController:ShopGalleryFiltersViewController, didLoadItems items:[BasicInfo])
}

class ShopGalleryFiltersViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var trackEvent:Int?
    weak var delegate:ShopGalleryFiltersViewControllerDelegate?
    var dataSource:[BasicInfo] = []
    var selectedID:Int = 0
    
    
    // MARK: - Objects
    private let blurView:UIVisualEffectView = {
        let vw = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        return vw
    }()
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 25.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.text = "CATEGORIAS"
        return lbl
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setImage(UIImage(named: "btn_close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = Theme.color(.PrimaryCardElements).withAlphaComponent(0.7)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.adjustsImageWhenHighlighted = false
        btn.highlightedAlpha = 0.6
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var tableView:UITableView = {
        let tbv = UITableView()
        tbv.register(ShopGalleryFilterItemCell.self, forCellReuseIdentifier: "ShopGalleryFilterItemCell")
        tbv.dataSource = self
        tbv.delegate = self
        tbv.alwaysBounceVertical = true
        tbv.backgroundColor = UIColor.clear
        tbv.separatorStyle = .none
        tbv.showsVerticalScrollIndicator = false
        tbv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        return tbv
    }()
    
    
    
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.ShopGalleryFilters.close, trackValue: nil)
        self.dismissAction()
    }
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.ShopGalleryFilters.tryAgain
        self.loadContent()
    }
    
    private func loadContent() {
        DispatchQueue.main.async {
            self.loadingView.startAnimating()
            self.tableView.isHidden = true
        }
        ServerManager.shared.getShopGalleryFilters(trackEvent: self.trackEvent) { (objects:[BasicInfo]?) in
            self.trackEvent = nil
            DispatchQueue.main.async {
                let items = objects ?? []
                if items.isEmpty {
                    self.loadingView.emptyResults()
                } else {
                    self.loadingView.stopAnimating()
                    self.delegate?.shopGalleryFiltersViewController(shopGalleryFiltersViewController: self, didLoadItems: items)
                    self.dataSource = items
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                }
            }
        }
    }
    
    
    
    
    // MARK: - Table Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.delegate?.shopGalleryFiltersViewController(shopGalleryFiltersViewController: self, didSelectItem: self.dataSource[indexPath.row])
            self.dismissAction()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopGalleryFilterItemCell", for: indexPath) as! ShopGalleryFilterItemCell
        let item = self.dataSource[indexPath.row]
        cell.updateContent(title: item.title, isHighlighted: item.id == self.selectedID)
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
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(self.blurView)
        self.view.addFullBoundsConstraintsTo(subView: self.blurView, constant: 0)
        // container
        self.view.addSubview(self.containerView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.containerView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.containerView, constant: 0)
        if UIScreen.main.bounds.width > 320 {
            self.containerView.addWidthConstraint(335)
        } else {
            self.containerView.addWidthConstraint(310)
        }
        self.containerView.addHeightConstraint(365)
        // Title
        self.containerView.addSubview(self.lblTitle)
        self.containerView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.lblTitle.addHeightConstraint(60)
        // Close
        self.containerView.addSubview(self.btnClose)
        self.containerView.addTrailingAlignmentConstraintTo(subView: self.btnClose, constant: -10)
        self.containerView.addCenterYAlignmentRelatedConstraintTo(subView: self.btnClose, reference: self.lblTitle, constant: 0)
        self.btnClose.addWidthConstraint(40)
        self.btnClose.addHeightConstraint(40)
        // Table
        self.containerView.addSubview(self.tableView)
        self.containerView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.tableView, constant: 0)
        self.containerView.addBoundsConstraintsTo(subView: self.tableView, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Loading
        self.containerView.addSubview(self.loadingView)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.containerView.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
    }
    
}





class ShopGalleryFilterItemCell: UITableViewCell {
    
    // MARK: - Objects
    let separatorView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.MutedText)
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(title:String, isHighlighted:Bool) {
        self.lblTitle.text = title
        self.lblTitle.textColor = isHighlighted ? Theme.color(.PrimaryButtonText) : Theme.color(.PrimaryCardElements)
        self.backgroundColor = isHighlighted ? Theme.color(.PrimaryButtonBackground) : UIColor.clear
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.selectionStyle = .none
        self.addSubview(self.separatorView)
        self.separatorView.addHeightConstraint(1)
        self.addBoundsConstraintsTo(subView: self.separatorView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 20, trailing: -20, top: 0, bottom: 0)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

