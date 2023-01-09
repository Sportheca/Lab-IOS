//
//  ShopGalleryContentView.swift
//  
//
//  Created by Roberto Oliveira on 30/04/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol ShopGalleryContentViewDelegate:AnyObject {
    func shopGalleryContentView(shopGalleryContentView:ShopGalleryContentView, didSelectItem item:ShopGalleryItem)
    func shopGalleryContentView(shopGalleryContentView:ShopGalleryContentView, didSelectSearch search:String)
}

class ShopGalleryContentView: PaginationContentView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ShopGalleryHeaderViewDelegate {
    
    // MARK: - Properties
    weak var delegate:ShopGalleryContentViewDelegate?
    
    
    
    // MARK: - Objects
    lazy var searchView:ShopGalleryHeaderView = {
        let vw = ShopGalleryHeaderView()
        vw.delegate = self
        return vw
    }()
    
    
    
    // MARK: - Methods
    // Layout
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                collectionView.cellForItem(at: indexPath)?.alpha = 0.4
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                collectionView.cellForItem(at: indexPath)?.alpha = 1.0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowItems:Int = max(2, Int(collectionView.bounds.width/187))
        let itemWidth:CGFloat = collectionView.bounds.width/CGFloat(rowItems)
        let imageHeight = itemWidth*0.85
        return CGSize(width: itemWidth, height: imageHeight + 140)
    }
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard let item = self.dataSource[indexPath.item] as? ShopGalleryItem else {return}
            self.delegate?.shopGalleryContentView(shopGalleryContentView: self, didSelectItem: item)
        }
    }
    
    func shopGalleryHeaderView(shopGalleryHeaderView: ShopGalleryHeaderView, didSelectSearch search: String) {
        self.delegate?.shopGalleryContentView(shopGalleryContentView: self, didSelectSearch: search)
    }
    
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.handlePagination(indexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopGalleryItemCell", for: indexPath) as! ShopGalleryItemCell
        guard let item = self.dataSource[indexPath.item] as? ShopGalleryItem else {return cell}
        cell.updateContent(item: item)
        return cell
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Header
        self.addSubview(self.searchView)
        self.addBoundsConstraintsTo(subView: self.searchView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.searchView.addHeightConstraint(100)
        // Collections
        self.addSubview(self.collectionView)
        self.addVerticalSpacingTo(subView1: self.searchView, subView2: self.collectionView, constant: 0)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: 0)
        self.collectionView.register(ShopGalleryItemCell.self, forCellWithReuseIdentifier: "ShopGalleryItemCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // refresh control
        self.collectionView.addSubview(self.refreshControl)
        self.refreshControl.tintColor = Theme.color(.PrimaryAnchor)
        
    }
    
    
    
}









protocol ShopGalleryHeaderViewDelegate:AnyObject {
    func shopGalleryHeaderView(shopGalleryHeaderView:ShopGalleryHeaderView, didSelectSearch search:String)
}

class ShopGalleryHeaderView: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    weak var delegate:ShopGalleryHeaderViewDelegate?
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.clipsToBounds = true
        vw.backgroundColor = UIColor.clear
        vw.layer.cornerRadius = 15.0
        vw.layer.borderWidth = 1.0
        vw.layer.borderColor = Theme.color(.PrimaryText).cgColor
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
        txf.textColor = Theme.color(.PrimaryText)
        txf.backgroundColor = UIColor.clear
        txf.returnKeyType = .search
        txf.placeholder = "Procurando por algo específico?"
        txf.addTarget(self, action: #selector(self.changed), for: .editingChanged)
        return txf
    }()
    lazy var btnFilter:CustomButton = {
        let btn = CustomButton()
        btn.setImage(UIImage(named: "btn_all_news_filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageView?.tintColor = Theme.color(.PrimaryText)
        btn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn.adjustsImageWhenHighlighted = false
        btn.highlightedAlpha = 0.6
        btn.highlightedScale = 0.95
        return btn
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
        self.delegate?.shopGalleryHeaderView(shopGalleryHeaderView: self, didSelectSearch: txt)
    }
    
    private func updateSearchButton() {
        let txt = self.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if txt == "" {
            self.btnSearch.backgroundColor = UIColor.clear
            self.btnSearch.tintColor = Theme.color(.MutedText)
        } else {
            self.btnSearch.backgroundColor = Theme.color(.PrimaryButtonBackground)
            self.btnSearch.tintColor = Theme.color(.PrimaryButtonText)
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.btnFilter)
        self.btnFilter.addHeightConstraint(40)
        self.btnFilter.addWidthConstraint(40)
        // Container
        self.addSubview(self.containerView)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.btnFilter, reference: self.containerView, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.containerView, subView2: self.btnFilter, constant: 10)
        self.addBoundsConstraintsTo(subView: self.containerView, leading: 20, trailing: -60, top: nil, bottom: -10)
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
