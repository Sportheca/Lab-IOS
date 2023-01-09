//
//  AllNewsContentView.swift
//  
//
//  Created by Roberto Oliveira on 02/04/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class AllNewsContentView: PaginationContentView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        let width = collectionView.bounds.width
        let height = (width*0.56)+120
        return CGSize(width: width, height: height)
    }
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource[indexPath.item] as? AllNewsItem else {return}
        ServerManager.shared.setTrack(trackEvent: EventTrack.AllNews.openNews, trackValue: item.id)
        DispatchQueue.main.async {
            if let link = item.urlString {
                guard let url = URL(string: link) else {return}
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let vc = NewsViewController(id: item.id)
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllNewsItemCell", for: indexPath) as! AllNewsItemCell
        guard let item = self.dataSource[indexPath.item] as? AllNewsItem else {return cell}
        cell.updateContent(item: item)
        return cell
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.refreshControl.tintColor = Theme.color(.PrimaryAnchor)
        self.backgroundColor = UIColor.clear
        self.collectionView.register(AllNewsItemCell.self, forCellWithReuseIdentifier: "AllNewsItemCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 15)
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
    }
    
}



