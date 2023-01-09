//
//  HomeShopGalleryView.swift
//  
//
//  Created by Roberto Oliveira on 07/05/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol HomeShopGalleryViewDelegate:AnyObject {
    func didSelectShopGalleryItem(item:ShopGalleryItem)
    func didSelectAllShopGallery()
}

class HomeShopGalleryView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    weak var delegate:HomeShopGalleryViewDelegate?
    var dataSource:[ShopGalleryItem] = []
    private let itemWidth:CGFloat = 188
    
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = ProjectInfoManager.TextInfo.loja_titulo.rawValue.uppercased()
        return lbl
    }()
    private lazy var btnAll:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Ver Todos", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 13)
        btn.addTarget(self, action: #selector(self.allAction), for: .touchUpInside)
        return btn
    }()
    let loadingView:ContentLoadingView = ContentLoadingView()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(ShopGalleryItemCell.self, forCellWithReuseIdentifier: "ShopGalleryItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    
    
    
    // MARK: - Content Methods
    func updateContent(items:[ShopGalleryItem]) {
        self.dataSource.removeAll()
        self.dataSource = items
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc func allAction() {
        self.delegate?.didSelectAllShopGallery()
    }
    
    
    
    
    
    // MARK: - CollectionView Methods
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectShopGalleryItem(item: self.dataSource[indexPath.item])
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.itemWidth, height: (self.itemWidth*0.85) + 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 15, height: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 15, height: 15)
    }
    
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopGalleryItemCell", for: indexPath) as! ShopGalleryItemCell
        let item = self.dataSource[indexPath.item]
        cell.updateContent(item: item)
        return cell
    }
    
    
    
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Title
        self.addSubview(self.lblTitle)
        self.lblTitle.addHeightConstraint(25)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 22, trailing: nil, top: 12, bottom: nil)
        self.lblTitle.setContentCompressionResistancePriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        // See All
        self.addSubview(self.btnAll)
        self.addTrailingAlignmentConstraintTo(subView: self.btnAll, constant: -22)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.btnAll, reference: self.lblTitle, constant: 0)
        // Collection
        self.addSubview(self.collectionView)
        self.collectionView.addHeightConstraint((self.itemWidth*0.85) + 140 + 10)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.collectionView, constant: 5)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: -10)
        // Loading
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.loadingView, reference: self.collectionView, constant: 0)
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

