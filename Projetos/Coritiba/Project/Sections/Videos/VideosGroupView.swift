//
//  VideosGroupView.swift
//
//
//  Created by Roberto Oliveira on 17/02/21.
//  Copyright © 2021 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol VideosGroupViewDelegate:AnyObject {
    func videosGroupView(videosGroupView:VideosGroupView, didSelectItem item:VideoItem)
    func videosGroupView(videosGroupView:VideosGroupView, didSelectAllItemsInGroup group:VideosGroup)
}

class VideosGroupView: UIView {
    
    // MARK: - Properties
    weak var delegate:VideosGroupViewDelegate?
    private var currentItem:VideosGroup?
    
    
    
    // MARK: - Objects
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 21)
        lbl.textColor = UIColor(hexString: "FAD716")
        return lbl
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(VideoItemCell.self, forCellWithReuseIdentifier: "VideoItemCell")
        cv.register(AllVideosCell.self, forCellWithReuseIdentifier: "AllVideosCell")
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    
    
    // MARK: - Methods
    func updateContent(item:VideosGroup, title:String?) {
        self.currentItem = item
        self.lblTitle.text = title
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 10, trailing: -10, top: nil, bottom: nil)
        self.addTopAlignmentConstraintFromSafeAreaTo(subView: self.lblTitle, constant: 0)
        self.addSubview(self.collectionView)
        self.collectionView.addHeightConstraint(300)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.collectionView, constant: 8)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: -10)
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


extension VideosGroupView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let group = self.currentItem else {return}
        if indexPath.item < group.items.count {
            let item = group.items[indexPath.item]
            self.delegate?.videosGroupView(videosGroupView: self, didSelectItem: item)
        } else {
            self.delegate?.videosGroupView(videosGroupView: self, didSelectAllItemsInGroup: group)
        }
    }
    
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
        return CGSize(width: 162, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let group = self.currentItem else {return 0}
        if group.id == 0 {
            return group.items.count // recommended
        }
        return group.items.count == 0 ? 0 : group.items.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let group = self.currentItem else {return collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)}
        if indexPath.item < group.items.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoItemCell", for: indexPath) as! VideoItemCell
            let item = group.items[indexPath.item]
            cell.updateContent(item: item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllVideosCell", for: indexPath) as! AllVideosCell
            return cell
        }
    }
    
    
}
