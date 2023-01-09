//
//  HorizontalSelectorBar.swift
//
//
//  Created by Roberto Oliveira on 26/09/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

// MARK: - HorizontalSelector
class HorizontalSelectorItem {
    var title:String
    var width:CGFloat
    
    init(title:String, font:UIFont) {
        self.title = title
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        lbl.textAlignment = .center
        lbl.text = title
        lbl.font = font
        self.width = lbl.intrinsicContentSize.width+10+30
    }
}

protocol HorizontalSelectorDelegate {
    func didSelectItem(with:HorizontalSelectorBar, at indexPath: IndexPath)
}

class HorizontalSelectorBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    // MARK: - Options
    var activeColor:UIColor = Theme.color(.PrimaryAnchor)
    var horizontalBarColor:UIColor = Theme.color(.PrimaryAnchor) {
        didSet {
            self.horizontalBar.backgroundColor = self.horizontalBarColor
            self.ivRight.tintColor = self.horizontalBarColor
            self.ivLeft.tintColor = self.horizontalBarColor
        }
    }
    var inactiveColor:UIColor = UIColor(R: 255, G: 255, B: 255, A: 1)
    var titleFont:UIFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
    
    
    // MARK: - Properties
    private var dataSource:[HorizontalSelectorItem] = []
    private var delegate:HorizontalSelectorDelegate?
    var selectedIndexPath:IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            DispatchQueue.main.async {
                for index in self.collectionView.indexPathsForVisibleItems {
                    let isSelected = index == self.selectedIndexPath
                    guard let cell = self.collectionView.cellForItem(at: index) as? HorizontalSelectorCell else {continue}
                    cell.updateHighlighted(isActive: isSelected)
                }
                self.updateHorizontalBar()
            }
        }
    }
    
    
    
    // MARK: - Objects
    private var horizontalBarWidthConstraint:NSLayoutConstraint = NSLayoutConstraint()
    var horizontalLeftConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private lazy var horizontalBar:UIView = {
        let vw = UIView()
        vw.backgroundColor = self.horizontalBarColor
        return vw
    }()
    private lazy var ivRight:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "horizontal_selector_right")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = self.horizontalBarColor
        return iv
    }()
    private lazy var ivLeft:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "horizontal_selector_left")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = self.horizontalBarColor
        return iv
    }()
    
    
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.allowsMultipleSelection = false
        cv.register(HorizontalSelectorCell.self, forCellWithReuseIdentifier: "HorizontalSelectorCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    // MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.delegate?.didSelectItem(with: self, at: indexPath)
            self.selectedIndexPath = indexPath
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalSelectorCell", for: indexPath) as! HorizontalSelectorCell
        let item = self.dataSource[indexPath.row]
        let isSelected = indexPath == self.selectedIndexPath
        cell.updateContent(title: item.title, activeColor: self.activeColor, inactiveColor: self.inactiveColor, font: self.titleFont, isHighlighted: isSelected)
        return cell
    }
    
    
    // MARK: - UICollectionView Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.dataSource[indexPath.item]
        return CGSize(width: item.width, height: self.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            self.updateHorizontalBar()
        }
    }
    
    func updateHorizontalBar() {
        var itemOffSet:CGFloat = 0
        for (index, item) in self.dataSource.enumerated() {
            guard index < self.selectedIndexPath.item else {continue}
            itemOffSet += item.width
        }
        let width:CGFloat = self.dataSource.isEmpty ? 0 : self.dataSource[self.selectedIndexPath.item].width
//        self.horizontalBarWidthConstraint.constant = max(0, width-20)
        self.horizontalLeftConstraint.constant = (itemOffSet-self.collectionView.contentOffset.x)+10
        self.horizontalBarWidthConstraint.constant = max(0, width)
        self.horizontalLeftConstraint.constant = (itemOffSet-self.collectionView.contentOffset.x)
        DispatchQueue.main.async {
            self.layoutSubviews()
        }
    }
    
    
    
    // MARK: - Setup Methods
    func setDataSource(items:[HorizontalSelectorItem], delegate:HorizontalSelectorDelegate?) {
        self.dataSource.removeAll()
        self.delegate = delegate
        self.dataSource = items
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.updateHorizontalBar()
            self.layoutIfNeeded()
        }
    }
    
    func setColors(activeColor:UIColor, inactiveColor:UIColor) {
        self.horizontalBar.backgroundColor = activeColor
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
    }
    
    private func prepareElements() {
        self.backgroundColor = UIColor.white
        self.addSubview(self.collectionView)
        self.addFullBoundsConstraintsTo(subView: self.collectionView, constant: 0)
        self.insertSubview(self.horizontalBar, belowSubview: self.collectionView)
        self.addBottomAlignmentConstraintTo(subView: self.horizontalBar, constant: 0)
        self.horizontalBarWidthConstraint = NSLayoutConstraint(item: self.horizontalBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
        self.addConstraint(self.horizontalBarWidthConstraint)
        self.horizontalBar.addHeightConstraint(1)
//        self.addTopAlignmentConstraintTo(subView: self.horizontalBar, constant: 0)
        self.horizontalLeftConstraint = NSLayoutConstraint(item: self.horizontalBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        self.addConstraint(self.horizontalLeftConstraint)
        // Right Image
//        self.insertSubview(self.ivRight, belowSubview: self.horizontalBar)
//        self.addHorizontalSpacingTo(subView1: self.horizontalBar, subView2: self.ivRight, constant: 0)
//        self.addCenterYAlignmentRelatedConstraintTo(subView: self.ivRight, reference: self.horizontalBar, constant: 0)
//        self.addHeightRelatedConstraintTo(subView: self.ivRight, reference: self.horizontalBar)
//        self.ivRight.addWidthConstraint(30)
        // Left Image
//        self.insertSubview(self.ivLeft, belowSubview: self.horizontalBar)
//        self.addHorizontalSpacingTo(subView1: self.ivLeft, subView2: self.horizontalBar, constant: 0)
//        self.addCenterYAlignmentRelatedConstraintTo(subView: self.ivLeft, reference: self.horizontalBar, constant: 0)
//        self.addHeightRelatedConstraintTo(subView: self.ivLeft, reference: self.horizontalBar)
//        self.ivLeft.addWidthConstraint(30)
    }
    
    
    
    
    // MARK: - Init Methods
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}















// MARK: - HorizontalSelectorCell
class HorizontalSelectorCell: UICollectionViewCell {
    
    
    // MARK: - Options
    private var activeColor:UIColor = UIColor.clear
    private var inactiveColor:UIColor = UIColor.clear
    
    
    // MARK: - Objects
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    
    
    
    // MARK: - Methods
    func updateContent(title:String, activeColor:UIColor, inactiveColor:UIColor, font: UIFont, isHighlighted:Bool) {
        self.lblTitle.text = title
        self.lblTitle.font = font
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.updateHighlighted(isActive: isHighlighted)
    }
    
    func updateHighlighted(isActive:Bool) {
        self.lblTitle.textColor = (isActive) ? self.activeColor : self.inactiveColor
        self.lblTitle.font = isActive ? FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 12) : FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
    }
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.lblTitle)
        self.addFullBoundsConstraintsTo(subView: self.lblTitle, constant: 5)
    }
    
    
    
    // MARK: - Super Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
}


