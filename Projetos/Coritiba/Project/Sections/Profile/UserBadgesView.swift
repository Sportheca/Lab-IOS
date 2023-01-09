//
//  UserBadgesView.swift
//  
//
//  Created by Roberto Oliveira on 08/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class UserBadgesView: PaginationContentView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Objects
    let loadingView:ContentLoadingView = ContentLoadingView()
    
    
    
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
        let width = (collectionView.bounds.width-30)/4
        return CGSize(width: width, height: width)
    }
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource[indexPath.item] as? BadgeItem else {return}
        ServerManager.shared.setTrack(trackEvent: EventTrack.Profile.selectBadge, trackValue: item.id)
        DispatchQueue.main.async {
            BadgeDetailsViewController.showBadge(item: item)
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserBadgesItemCell", for: indexPath) as! UserBadgesItemCell
        guard let item = self.dataSource[indexPath.item] as? BadgeItem else {return cell}
        cell.updateContent(item: item)
        return cell
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.refreshControl.tintColor = Theme.color(.MutedText)
        self.backgroundColor = UIColor.clear
        self.collectionView.register(UserBadgesItemCell.self, forCellWithReuseIdentifier: "UserBadgesItemCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 15)
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
    }
    
}





class UserBadgesItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    // MARK: - Methods
    func updateContent(item:BadgeItem) {
        self.ivCover.filter = item.isActive ? .None : .BlackAndWhite
        self.ivCover.setServerImage(urlString: item.imageUrl, placeholderImageName: item.imageUrl)
        self.ivCover.alpha = item.isActive ? 1.0 : 0.5
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.ivCover)
        self.addFullBoundsConstraintsTo(subView: self.ivCover, constant: 5)
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
