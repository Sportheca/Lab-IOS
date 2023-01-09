//
//  HomeBannersView.swift
//
//
//  Created by Roberto Oliveira on 07/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol HomeBannersViewDelegate:AnyObject {
    func didSelectBanner(item:AllNewsItem)
    func didSelectAllBanners()
}

class HomeBannersView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    weak var delegate:HomeBannersViewDelegate?
    var dataSource:[AllNewsItem] = []
    
    
    
    // MARK: - Objects
    private let lblTitle:RootLabel = {
        let lbl = RootLabel()
        lbl.topInset = 4.0
        lbl.bottomInset = 4.0
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Notícias".uppercased()
        return lbl
    }()
    private lazy var btnAll:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Ver Todas", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 13)
        btn.addTarget(self, action: #selector(self.allAction), for: .touchUpInside)
        return btn
    }()
    let loadingView:ContentLoadingView = ContentLoadingView()
    private let pageControl:CustomPageControl = CustomPageControl()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(AllNewsItemCell.self, forCellWithReuseIdentifier: "AllNewsItemCell")
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()
    
    
    
    
    
    
    // MARK: - Content Methods
    func updateContent(items:[AllNewsItem]) {
        self.dataSource.removeAll()
        self.dataSource = items
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.pageControl.updateContent(totalItems: items.count, currentIndex: 0)
            self.pageControl.alpha = items.count > 1 ? 1.0 : 0.0
            
        }
    }
    
    @objc func allAction() {
        self.delegate?.didSelectAllBanners()
    }
    
    
    
    
    
    // MARK: - CollectionView Methods
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectBanner(item: self.dataSource[indexPath.item])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page:CGFloat = (scrollView.bounds.width == 0) ? 0 : scrollView.contentOffset.x / scrollView.bounds.width
        let index = Int(page)
        self.pageControl.updateContent(totalItems: self.dataSource.count, currentIndex: index)
    }
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllNewsItemCell", for: indexPath) as! AllNewsItemCell
        let item = self.dataSource[indexPath.item]
        cell.updateContent(item: item)
        return cell
    }
    
    
    
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Title
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 22, trailing: nil, top: 12, bottom: nil)
        self.lblTitle.setContentCompressionResistancePriority(UILayoutPriority(1000), for: NSLayoutConstraint.Axis.horizontal)
        // See All
        self.addSubview(self.btnAll)
        self.addTrailingAlignmentConstraintTo(subView: self.btnAll, constant: -22)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.btnAll, reference: self.lblTitle, constant: 0)
        // Collection
        self.addSubview(self.collectionView)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.collectionView, constant: 5)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: -10)
        self.addConstraint(NSLayoutConstraint(item: self.collectionView, attribute: .height, relatedBy: .equal, toItem: self.collectionView, attribute: .width, multiplier: 0.56, constant: 120))
        // Page Control
        self.addSubview(self.pageControl)
        self.addCenterXAlignmentConstraintTo(subView: self.pageControl, constant: 0)
        self.addBottomAlignmentConstraintTo(subView: self.pageControl, constant: -130)
        
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


