//
//  PlayerProfileIconsCell.swift
//
//
//  Created by Roberto Oliveira on 02/07/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

struct PlayerProfileIconItem {
    var title:String
    var iconUrlString:String?
}

class PlayerProfileIconsCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var currentItem:PlayerProfile?
    private var dataSource:[PlayerProfileIconItem] = []
    
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardElements).withAlphaComponent(0.08)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 12)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 10)
        lbl.textColor = Theme.color(.MutedText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(PlayerProfileIconItemCell.self, forCellWithReuseIdentifier: "PlayerProfileIconItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    private let lblEmpty:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        return lbl
    }()
    
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(item:PlayerProfile) {
        self.currentItem = item
        self.dataSource = item.iconsList
        self.lblTitle.text = "TÍTULOS"
        self.lblSubtitle.text = "CONQUISTADOS PELO CLUBE"
        self.lblEmpty.text = "Sem títulos"
        self.lblEmpty.isHidden = !item.iconsList.isEmpty
        self.collectionView.reloadData()
    }
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Back view
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: 15, trailing: -15, top: 15, bottom: -15)
        // title
        self.backView.addSubview(self.lblTitle)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 15, trailing: -15, top: 15, bottom: nil)
        // Subtitle
        self.backView.addSubview(self.lblSubtitle)
        self.backView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.lblSubtitle, constant: 1)
        self.backView.addBoundsConstraintsTo(subView: self.lblSubtitle, leading: 15, trailing: -15, top: nil, bottom: nil)
        // CollectionView
        self.backView.addSubview(self.collectionView)
        self.addVerticalSpacingTo(subView1: self.lblSubtitle, subView2: self.collectionView, constant: 10)
        self.backView.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: -10)
        // Empty
        self.backView.addSubview(self.lblEmpty)
        self.backView.addFullBoundsConstraintsTo(subView: self.lblEmpty, constant: 10)
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




extension PlayerProfileIconsCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // didSelectItemAt
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard !self.dataSource.isEmpty else {return CGSize.zero}
        let maxColumnItems:Int = 6
        var width:CGFloat = collectionView.bounds.width
        var height:CGFloat = min(50, collectionView.bounds.height / CGFloat(self.dataSource.count))
        if self.dataSource.count > maxColumnItems {
            width = collectionView.bounds.width*0.5 // each item half of available area
            height = collectionView.bounds.height / CGFloat(maxColumnItems)
        }
        return CGSize(width: width, height: height)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerProfileIconItemCell", for: indexPath) as! PlayerProfileIconItemCell
        cell.updateContent(item: self.dataSource[indexPath.item])
        return cell
    }
    
}

















class PlayerProfileIconItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 10.0
        return vw
    }()
    private let ivIcon:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 10)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(item:PlayerProfileIconItem) {
        self.lblTitle.text = item.title
        self.ivIcon.setServerImage(urlString: item.iconUrlString)
        self.ivIcon.isHidden = item.iconUrlString == nil
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // icon
        self.addSubview(self.stackView)
        self.addBoundsConstraintsTo(subView: self.stackView, leading: 15, trailing: -5, top: 5, bottom: -5)
        self.stackView.addArrangedSubview(self.ivIcon)
        self.addConstraint(NSLayoutConstraint(item: self.ivIcon, attribute: .width, relatedBy: .equal, toItem: self.ivIcon, attribute: .height, multiplier: 1.0, constant: 0))
        self.stackView.addArrangedSubview(self.lblTitle)
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
