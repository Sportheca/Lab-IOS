//
//  RankingsGroupsView.swift
//  
//
//  Created by Roberto Oliveira on 13/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol RankingsGroupsViewDelegate:AnyObject {
    func rankingsGroupsView(rankingsGroupsView:RankingsGroupsView, didSelectItem item:RankingGroup)
}

class RankingsGroupsView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    static let defaultHeight:CGFloat = 120.0
    // MARK: - Properties
    weak var delegate:RankingsGroupsViewDelegate?
    private var dataSource:[RankingGroup] = []
    private var selectedId:Int?
    
    
    // MARK: - Objects
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(RankingsGroupItemCell.self, forCellWithReuseIdentifier: "RankingsGroupItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    // MARK: - Methods
    func updateContent(items:[RankingGroup], selectedId:Int?) {
        DispatchQueue.main.async {
            self.dataSource.removeAll()
            self.dataSource = items
            self.selectedId = selectedId
            self.collectionView.reloadData()
        }
    }
    
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataSource[indexPath.item]
        self.selectedId = item.id
        self.delegate?.rankingsGroupsView(rankingsGroupsView: self, didSelectItem: item)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                collectionView.cellForItem(at: indexPath)?.scaleTo(0.95)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                collectionView.cellForItem(at: indexPath)?.scaleTo(nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankingsGroupItemCell", for: indexPath) as! RankingsGroupItemCell
        let item = self.dataSource[indexPath.item]
        cell.backView.backgroundColor = (item.id == self.selectedId) ? Theme.color(.PrimaryButtonBackground) : Theme.color(.PrimaryCardBackground)
        cell.lblTitle.textColor = (item.id == self.selectedId) ? Theme.color(.PrimaryButtonText) : Theme.color(.PrimaryCardElements)
        cell.lblTitle.text = item.title
        return cell
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.collectionView)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: 0)
        self.collectionView.addHeightConstraint(70)
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












class RankingsGroupItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    let backView:UIView = {
        let vw = UIView()
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.backView)
        self.addFullBoundsConstraintsTo(subView: self.backView, constant: 0)
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 10, trailing: -10, top: 0, bottom: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}
