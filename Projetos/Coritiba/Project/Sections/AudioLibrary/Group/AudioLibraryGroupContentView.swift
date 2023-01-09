//
//  AudioLibraryGroupContentView.swift
//  
//
//  Created by Roberto Oliveira on 3/23/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol AudioLibraryGroupContentViewDelegate:AnyObject {
    func audioLibraryGroupContentView(audioLibraryGroupContentView:AudioLibraryGroupContentView, didSelectItem item:AudioLibraryGroupItem)
}


class AudioLibraryGroupContentView: PaginationContentView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    weak var delegate:AudioLibraryGroupContentViewDelegate?
    
    // MARK: - Objects
    let loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        return vw
    }()
    
    
    
    // MARK: - Methods
    // Layout
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 && indexPath.item > 0 else {return}
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                collectionView.cellForItem(at: indexPath)?.alpha = 0.7
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 && indexPath.item > 0 else {return}
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                collectionView.cellForItem(at: indexPath)?.alpha = 1.0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = AudioLibraryGroupItemCell.defaultHeight
        if indexPath.item == 0 {
            height = AudioLibraryGroupTitleCell.defaultHeight
        }
        if indexPath.section == 0 && indexPath.item == 1 {
            height = AudioLibraryGroupCoverCell.defaultHeight
        }
        return CGSize(width: collectionView.bounds.width, height: height)
    }
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 && indexPath.item > 0 else {return}
        guard let item = self.dataSource[indexPath.item-1] as? AudioLibraryGroupItem else {return}
        ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibrary.selectItem, trackValue: item.id)
        self.delegate?.audioLibraryGroupContentView(audioLibraryGroupContentView: self, didSelectItem: item)
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.isEmpty ? 0 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1 + self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioLibraryGroupTitleCell", for: indexPath) as! AudioLibraryGroupTitleCell
                cell.updateContent(title: "Último Lançamento")
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioLibraryGroupCoverCell", for: indexPath) as! AudioLibraryGroupCoverCell
                guard let item = self.dataSource.first as? AudioLibraryGroupItem else {return cell}
                cell.updateContent(item: item)
                cell.delegate = self
                return cell
            }
        }
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioLibraryGroupTitleCell", for: indexPath) as! AudioLibraryGroupTitleCell
            cell.updateContent(title: "Áudios")
            return cell
        }
        self.handlePagination(indexPath: IndexPath(item: indexPath.item-1, section: 0))
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioLibraryGroupItemCell", for: indexPath) as! AudioLibraryGroupItemCell
        guard let item = self.dataSource[indexPath.item-1] as? AudioLibraryGroupItem else {return cell}
        let roundTop = indexPath.item == 1
        let roundBottom = indexPath.item == self.dataSource.count
//        if self.dataSource[indexPath.section] == self.dataSource[indexPath.section-1] {
//            cell.separatorView.isHidden = true
//        }
        cell.updateContent(item: item, roundTop: roundTop, roundBottom: roundBottom)
        return cell
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.refreshControl.tintColor = Theme.color(.MutedText)
        self.backgroundColor = UIColor.clear
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(AudioLibraryGroupTitleCell.self, forCellWithReuseIdentifier: "AudioLibraryGroupTitleCell")
        self.collectionView.register(AudioLibraryGroupCoverCell.self, forCellWithReuseIdentifier: "AudioLibraryGroupCoverCell")
        self.collectionView.register(AudioLibraryGroupItemCell.self, forCellWithReuseIdentifier: "AudioLibraryGroupItemCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: -50)
    }
    
}





extension AudioLibraryGroupContentView: AudioLibraryGroupCoverCellDelegate {
    func audioLibraryGroupCoverCell(audioLibraryGroupCoverCell: AudioLibraryGroupCoverCell, didSelectItem item: AudioLibraryGroupItem) {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibrary.selectHighlightedItem, trackValue: item.id)
        self.delegate?.audioLibraryGroupContentView(audioLibraryGroupContentView: self, didSelectItem: item)
    }
}
