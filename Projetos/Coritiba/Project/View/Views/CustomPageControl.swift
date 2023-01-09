//
//  CustomPageControl.swift
//
//
//  Created by Roberto Oliveira on 12/07/21.
//  Copyright © 2021 Sportheca. All rights reserved.
//

import UIKit

class CustomPageControl: UIView {
    
    // MARK: - Properties
    private var totalItems:Int = 4
    private var currentItem:Int = 0
    
    
    // MARK: - Objects
    private var horizontalConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(CustomPageControlItemCell.self, forCellWithReuseIdentifier: "CustomPageControlItemCell")
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.alwaysBounceVertical = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    // MARK: - Methods
    func updateContent(totalItems:Int, currentIndex:Int) {
        self.totalItems = totalItems
        self.currentItem = currentIndex
        let itemWidth:CGFloat = 2 + 30 + 2
        self.horizontalConstraint.constant = min(310, CGFloat(totalItems)*itemWidth)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.collectionView)
        self.addFullBoundsConstraintsTo(subView: self.collectionView, constant: 0)
        self.collectionView.addHeightConstraint(CustomPageControlItemCell.markerHeight)
        self.horizontalConstraint = NSLayoutConstraint(item: self.collectionView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        self.horizontalConstraint.priority = UILayoutPriority(999)
        self.addConstraint(self.horizontalConstraint)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepareElements()
    }
    
}



extension CustomPageControl: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // --
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(self.totalItems)
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.totalItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomPageControlItemCell", for: indexPath) as! CustomPageControlItemCell
        let isHighlighted = indexPath.item == self.currentItem
        cell.updateContent(isHighlighted: isHighlighted)
        return cell
    }
    
}



















class CustomPageControlItemCell: UICollectionViewCell {
    
    static let markerHeight:CGFloat = 4.0
    
    // MARK: - Objects
    private let markerView:UIView = UIView()
    
    
    
    // MARK: - Methods
    func updateContent(isHighlighted:Bool) {
        //self.markerView.layer.borderWidth = 0.0
        //self.markerView.layer.borderColor = UIColor(R: 118, G: 118, B: 118).cgColor
        self.markerView.backgroundColor = isHighlighted ? UIColor(hexString: "FAD716") : UIColor.lightGray.withAlphaComponent(0.5)
        //self.markerView.alpha = isHighlighted ? 1.0 : 0.5
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.markerView)
        self.addBoundsConstraintsTo(subView: self.markerView, leading: 2, trailing: -2, top: nil, bottom: nil)
        self.addCenterYAlignmentConstraintTo(subView: self.markerView, constant: 0)
        self.markerView.addHeightConstraint(CustomPageControlItemCell.markerHeight)
        self.markerView.layer.cornerRadius = CustomPageControlItemCell.markerHeight/2
        self.markerView.clipsToBounds = true
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepareElements()
    }
    
}
