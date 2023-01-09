//
//  ScheduleMatchesGroupView.swift
//  
//
//  Created by Roberto Oliveira on 04/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class ScheduleMatchesGroupView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    private var currentItem:ScheduleMatchesGroup?
    var ticketTrackEvent:Int?
    
    // MARK: - Objects
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(ScheduleMatchesGroupCell.self, forCellWithReuseIdentifier: "ScheduleMatchesGroupCell")
        cv.dataSource = self
        cv.delegate = self
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    
    // MARK: - Methods
    func updateContent(item:ScheduleMatchesGroup) {
        DispatchQueue.main.async {
            self.currentItem = item
            self.collectionView.reloadData()
        }
    }
    
    
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: ScheduleMatchItemView.defaultHeight)
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
        return CGSize(width: 100, height: 100)
    }
    
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentItem?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleMatchesGroupCell", for: indexPath) as! ScheduleMatchesGroupCell
        guard let object = self.currentItem else {return cell}
        let item = object.items[indexPath.item]
        cell.itemView.updateContent(item: item)
        cell.itemView.ticketTrackEvent = self.ticketTrackEvent
        cell.updateColors(background: Theme.color(.ScheduleBackground), elements: Theme.color(.ScheduleElements))
        return cell
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.collectionView)
        self.addFullBoundsConstraintsTo(subView: self.collectionView, constant: 0)
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









class ScheduleMatchesGroupCell: UICollectionViewCell {
    
    // MARK: - Objects
    let itemView:ScheduleMatchItemView = ScheduleMatchItemView()
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = Theme.color(.ScheduleBackground)
        self.addSubview(self.itemView)
        self.addBoundsConstraintsTo(subView: self.itemView, leading: 25, trailing: -25, top: 0, bottom: 0)
    }
    
    func updateColors(background:UIColor, elements:UIColor) {
        self.backgroundColor = background
        self.itemView.lblTitle.textColor = elements
        self.itemView.lblDetails.textColor = elements
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
