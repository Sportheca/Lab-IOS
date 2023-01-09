//
//  ClubHomeSquadView.swift
//  
//
//  Created by Roberto Oliveira on 17/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

struct ClubHomeSquadGroup {
    var title:String
    var items:[ClubHomeSquadItem]
}

struct ClubHomeSquadItem {
    var id:Int
    var imageUrl:String?
}

class ClubHomeSquadView: UIView {
    
    // MARK: - Properties
    var selectedGroupIndex:Int = 0
    var dataSource:[ClubHomeSquadGroup] = []
    
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 24)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Elenco atual".uppercased()
        return lbl
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(ClubHomeSquadViewItemCell.self, forCellWithReuseIdentifier: "ClubHomeSquadViewItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    private lazy var groupsCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(ClubHomeSquadGroupCell.self, forCellWithReuseIdentifier: "ClubHomeSquadGroupCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    let loadingView:ContentLoadingView = ContentLoadingView()
    
    
    
    // MARK: - Methods
    func updateContent(items:[ClubHomeSquadGroup]) {
        self.selectedGroupIndex = 0
        self.dataSource.removeAll()
        self.dataSource = items
        self.collectionView.reloadData()
        self.groupsCollectionView.reloadData()
        
        if items.isEmpty {
            self.collectionView.alpha = 0.0
            self.groupsCollectionView.alpha = 0.0
        } else {
            self.collectionView.alpha = 1.0
            self.groupsCollectionView.alpha = 1.0
        }
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 20, trailing: -20, top: 10, bottom: nil)
        self.addSubview(self.collectionView)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.collectionView, constant: 5)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.collectionView.addHeightConstraint(250)
        // Groups
        self.addSubview(self.groupsCollectionView)
        self.addVerticalSpacingTo(subView1: self.collectionView, subView2: self.groupsCollectionView, constant: 5)
        self.groupsCollectionView.addHeightConstraint(40)
        self.addBoundsConstraintsTo(subView: self.groupsCollectionView, leading: 0, trailing: 0, top: nil, bottom: -20)
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
    private let defaultPadding:CGFloat = 20.0
    private let defaultItemWidth:CGFloat = 200.0
}

extension ClubHomeSquadView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if collectionView == self.groupsCollectionView {
                self.selectedGroupIndex = indexPath.item
                self.groupsCollectionView.reloadData()
                var paddingX:CGFloat = self.defaultPadding
                for (i, group) in self.dataSource.enumerated() {
                    guard i < indexPath.item else {continue}
                    paddingX += CGFloat(group.items.count) * self.defaultItemWidth
                }
                self.collectionView.setContentOffset(CGPoint(x: paddingX, y: 0), animated: true)
            } else {
                let item = self.dataSource[indexPath.section].items[indexPath.item]
                PlayerProfileViewController.showPlayer(id: item.id, trackEvent: EventTrack.ClubHome.squadSelectItem)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            if scrollView == self.collectionView {
                let screenWidth = scrollView.bounds.width
                let offSet = scrollView.contentOffset.x
                guard let index = self.collectionView.indexPathForItem(at: CGPoint(x: (offSet)+(screenWidth/2), y: 0)) else {return}
                if index.section != self.selectedGroupIndex {
                    self.selectedGroupIndex = index.section
                    self.groupsCollectionView.reloadData()
                }
            }
        }
    }
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.groupsCollectionView {
            let width = self.dataSource.count == 0 ? 0 : collectionView.bounds.width / CGFloat(self.dataSource.count)
            return CGSize(width: width, height: collectionView.bounds.height)
        }
        return CGSize(width: self.defaultItemWidth, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == self.groupsCollectionView {
            return CGSize.zero
        }
        let padding:CGFloat = section == 0 ? self.defaultPadding : 0
        return CGSize(width: padding, height: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == self.groupsCollectionView {
            return CGSize.zero
        }
        let padding:CGFloat = section == self.dataSource.count-1 ? self.defaultPadding : 0
        return CGSize(width: padding, height: padding)
    }
    
    
    // DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.groupsCollectionView {
            return 1
        }
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.groupsCollectionView {
            return self.dataSource.count
        }
        return self.dataSource[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.groupsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClubHomeSquadGroupCell", for: indexPath) as! ClubHomeSquadGroupCell
            let group = self.dataSource[indexPath.item]
            cell.updateContent(title: group.title, active: indexPath.item == self.selectedGroupIndex)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClubHomeSquadViewItemCell", for: indexPath) as! ClubHomeSquadViewItemCell
        let group = self.dataSource[indexPath.section]
        let item = group.items[indexPath.item]
        cell.updateContent(item: item)
        return cell
    }
    
}



class ClubHomeSquadViewItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.layer.cornerRadius = 25
        vw.layer.shadowOpacity = 0.07
        vw.layer.shadowOffset = CGSize(width: 0, height: 15)
        vw.layer.shadowRadius = 25
        return vw
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.tintColor = Theme.color(.PrimaryCardElements)
        iv.isPlaceholderTintColorEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor.clear
        iv.clipsToBounds = true
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        return iv
    }()
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(item:ClubHomeSquadItem) {
        self.ivCover.setServerImage(urlString: item.imageUrl, placeholderImageName: "player_placeholder")
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: 10, trailing: -10, top: 40, bottom: 0)
        self.addSubview(self.ivCover)
        self.addBoundsConstraintsTo(subView: self.ivCover, leading: 20, trailing: -20, top: 0, bottom: 0)
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




class ClubHomeSquadGroupCell: UICollectionViewCell {
    
    // MARK: - Objects
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 12)
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(title:String, active:Bool) {
        self.lblTitle.text = title.uppercased()
        self.lblTitle.textColor = active ? Theme.color(.PrimaryAnchor) : Theme.color(.MutedText)
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 5, trailing: -5, top: 0, bottom: 0)
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
