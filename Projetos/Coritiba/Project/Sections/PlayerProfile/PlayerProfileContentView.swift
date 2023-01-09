//
//  PlayerProfileContentView.swift
//  
//
//  Created by Roberto Oliveira on 20/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class PlayerProfileContentView: UIView {
    
    // MARK: - Properties
    private var currentItem:PlayerProfile?
    
    // MARK: - Objects
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.isPlaceholderTintColorEnabled = true
        iv.tintColor = Theme.color(.MutedText)
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let ivHighlighted:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "player_badge_highlighted")
        return iv
    }()
    private let lblInfos:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .right
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 10.0
        return vw
    }()
    private let footerContainerView:UIImageView = {
        let vw = UIImageView()
        vw.backgroundColor = Theme.color(.AlternativeCardBackground)
        vw.contentMode = .scaleAspectFill
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        vw.isUserInteractionEnabled = true
        return vw
    }()
    private let footerStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .fill
        return vw
    }()
    private let lblFooter:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 9)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.text = "Deslize para os lados para ver mais dados"
        return lbl
    }()
    private let ivArrowRight:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_arrow_right")
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private let ivArrowLeft:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_arrow_right")
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        return iv
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(PlayerProfileChartCell.self, forCellWithReuseIdentifier: "PlayerProfileChartCell")
        cv.register(PlayerProfileInfosCell.self, forCellWithReuseIdentifier: "PlayerProfileInfosCell")
        cv.register(PlayerProfileIconsCell.self, forCellWithReuseIdentifier: "PlayerProfileIconsCell")
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()
    
    
    
    
    
    // MARK: - Methods
    func updateContent(item:PlayerProfile) {
        self.currentItem = item
        self.collectionView.reloadData()
        self.ivHighlighted.isHidden = !item.isHighlighted
        self.ivCover.setServerImage(urlString: item.imageUrl, placeholderImageName: "player_placeholder")
        let attributed = NSMutableAttributedString()
        // Posicao
        attributed.append(NSAttributedString(string: item.positionDescription ?? "", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Black, size: 16),
            NSAttributedString.Key.foregroundColor : Theme.color(.PrimaryAnchor)
        ]))
        if let value = item.shirtNumber {
            attributed.append(NSAttributedString(string: " "+value, attributes: [
                NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Black, size: 22),
                NSAttributedString.Key.foregroundColor : Theme.color(.MutedText)
            ]))
        }
        attributed.append(NSAttributedString(string: "\n"))
        let fontSize:CGFloat = UIScreen.main.bounds.width <= 375 ? 20 : 31
        attributed.append(NSAttributedString(string: item.title?.uppercased() ?? "", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Black, size: fontSize),
            NSAttributedString.Key.foregroundColor : Theme.color(.PrimaryText)
        ]))
        self.lblInfos.attributedText = attributed
        
        for info in item.infos {
            self.stackView.addArrangedSubview(self.attributedLabel(title: info.title, info: info.info))
        }
    }
    
    func attributedLabel(title:String, info:String) -> UILabel {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .right
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        
        let attributed = NSMutableAttributedString()
        attributed.append(NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Black, size: 10),
            NSAttributedString.Key.foregroundColor : Theme.color(.MutedText)
        ]))
        attributed.append(NSAttributedString(string: "\n"+info, attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Black, size: 12),
            NSAttributedString.Key.foregroundColor : Theme.color(.PrimaryText)
        ]))
        
        lbl.attributedText = attributed
        return lbl
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.ivCover)
        self.addBoundsConstraintsTo(subView: self.ivCover, leading: 10, trailing: nil, top: 0, bottom: nil)
        self.addWidthRelatedConstraintTo(subView: self.ivCover, reference: self, relatedBy: .equal, multiplier: 0.5, constant: -10, priority: 999)
        self.addSubview(self.ivHighlighted)
        self.addBoundsConstraintsTo(subView: self.ivHighlighted, leading: 10, trailing: nil, top: 10, bottom: nil)
        var highlightedSize:CGFloat = 35.0
        if UIScreen.main.bounds.width > 320 {
            highlightedSize = 55
        }
        self.ivHighlighted.addHeightConstraint(highlightedSize)
        self.ivHighlighted.addWidthConstraint(highlightedSize)
        self.addSubview(self.lblInfos)
        self.addHorizontalSpacingTo(subView1: self.ivCover, subView2: self.lblInfos, constant: -25)
        self.addBoundsConstraintsTo(subView: self.lblInfos, leading: nil, trailing: 0, top: -10, bottom: nil)
        self.addSubview(self.footerContainerView)
        self.addVerticalSpacingTo(subView1: self.ivCover, subView2: self.footerContainerView, constant: 0)
        self.addBoundsConstraintsTo(subView: self.footerContainerView, leading: 0, trailing: 0, top: nil, bottom: 0)
        let heightConstraint = NSLayoutConstraint(item: self.footerContainerView, attribute: .height, relatedBy: .equal, toItem: self.footerContainerView, attribute: .width, multiplier: 1.0, constant: 0)
        heightConstraint.priority = UILayoutPriority(750)
        self.addConstraint(heightConstraint)
        self.footerContainerView.addHeightConstraint(constant: 400, relatedBy: .lessThanOrEqual, priority: 999)
        self.addSubview(self.stackView)
        self.addHorizontalSpacingTo(subView1: self.ivCover, subView2: self.stackView, constant: 0)
        self.addVerticalSpacingTo(subView1: self.lblInfos, subView2: self.stackView, constant: 10)
        self.addTrailingAlignmentConstraintTo(subView: self.stackView, constant: 0)
        // Footer
//        self.footerContainerView.addSubview(self.footerStackView)
//        self.footerContainerView.addBoundsConstraintsTo(subView: self.footerStackView, leading: 15, trailing: -15, top: nil, bottom: -8)
//        self.footerStackView.addArrangedSubview(self.ivArrowLeft)
//        self.footerStackView.addArrangedSubview(self.lblFooter)
//        self.footerStackView.addArrangedSubview(self.ivArrowRight)
        // Pages
        self.footerContainerView.addSubview(self.collectionView)
//        self.footerContainerView.addVerticalSpacingTo(subView1: self.collectionView, subView2: self.footerStackView, constant: 10)
        self.footerContainerView.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: 0, bottom: -20)
        //
        self.footerContainerView.addSubview(self.lblFooter)
        self.footerContainerView.addBoundsConstraintsTo(subView: self.lblFooter, leading: 0, trailing: 0, top: nil, bottom: -5)
        
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











extension PlayerProfileContentView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // didSelectItemAt
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
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
        guard let item = self.currentItem else {return 0}
        return item.iconsList.isEmpty ? 2 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerProfileChartCell", for: indexPath) as! PlayerProfileChartCell
            guard let item = self.currentItem else {return cell}
            cell.updateContent(item: item)
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerProfileInfosCell", for: indexPath) as! PlayerProfileInfosCell
            guard let item = self.currentItem else {return cell}
            cell.updateContent(item: item)
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerProfileIconsCell", for: indexPath) as! PlayerProfileIconsCell
            guard let item = self.currentItem else {return cell}
            cell.updateContent(item: item)
            return cell

        default: return collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        }
    }
    
}
