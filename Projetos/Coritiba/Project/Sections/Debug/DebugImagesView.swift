//
//  DebugImagesView.swift
//
//
//  Created by Roberto Oliveira on 27/11/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class DebugImagesView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    private let dataSource:[(title:String, imgName:String)] = [
        (title: "Ícone do App", imgName: Bundle.main.iconName),
        (title: "Logo", imgName: "logo"),
        (title: "Moeda", imgName: "icon_coin"),
        (title: "Carteirinha", imgName: "membership_card_bg"),
        (title: "Jogador da Base", imgName: "player_badge_highlighted"),
        (title: "Splash", imgName: "splash_background"),
        (title: "Menu Inferior", imgName: "tab_icon_club_home"),
    ]
    private let itemSize:CGFloat = 250
    
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 16)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Imagens Personalizadas"
        return lbl
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(DebugImageItemCell.self, forCellWithReuseIdentifier: "DebugImageItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    
    
    // MARK: - CollectionView Methods
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // --
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.itemSize, height: self.itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 15, height: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 15, height: 15)
    }
    
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DebugImageItemCell", for: indexPath) as! DebugImageItemCell
        let item = self.dataSource[indexPath.item]
        cell.updateContent(imageName: item.imgName, title: item.title)
        return cell
    }
    
    
    
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Title
        self.addSubview(self.lblTitle)
        self.lblTitle.addHeightConstraint(25)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 22, trailing: nil, top: 12, bottom: nil)
        // Collection
        self.addSubview(self.collectionView)
        self.collectionView.addHeightConstraint(self.itemSize)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.collectionView, constant: 5)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: -10)
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









class DebugImageItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        vw.layer.borderWidth = 2.0
        vw.layer.borderColor = Theme.color(.PrimaryCardBackground).cgColor
        return vw
    }()
    private let ivCover:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.backgroundColor = Theme.color(.PrimaryCardBackground)
        return lbl
    }()
    
    // MARK: - Methods
    func updateContent(imageName:String, title:String) {
        var img = UIImage(named: imageName)
        img = img?.resizeWithWidth(width: min((img?.size.width ?? 0), 210))
        self.ivCover.image = img
        self.ivCover.contentMode = .center
        self.lblTitle.text = title
    }
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        // Back View
        self.addSubview(self.backView)
        self.addFullBoundsConstraintsTo(subView: self.backView, constant: 5)
        // Title
        self.backView.addSubview(self.lblTitle)
        self.lblTitle.addHeightConstraint(25)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Cover
        self.backView.addSubview(self.ivCover)
        self.backView.addBoundsConstraintsTo(subView: self.ivCover, leading: 20, trailing: -20, top: 20, bottom: nil)
        self.backView.addVerticalSpacingTo(subView1: self.ivCover, subView2: self.lblTitle, constant: 20)
    }
    
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}



extension Bundle {
    public var iconName: String {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return lastIcon
        }
        return ""
    }
}
