//
//  DebugColorsView.swift
//
//
//  Created by Roberto Oliveira on 27/11/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class DebugColorsView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    private let dataSource:[Theme.Color] = [
        .PrimaryBackground,
        .PrimaryText,
        .MutedText,
        .TextOverSplashImage,
        .PrimaryButtonBackground,
        .PrimaryButtonText,
        .PrimaryAnchor,
        .TabBarBackground,
        .TabBarSelected,
        .TabBarUnselected,
        .PrimaryCardBackground,
        .PrimaryCardElements,
        .SecondaryCardBackground,
        .SecondaryCardElements,
        .AlternativeCardBackground,
        .AlternativeCardElements,
        .PageHeaderBackground,
        .PageHeaderText,
        .AudioLibraryMainButtonBackground,
        .AudioLibraryMainButtonText,
        .AudioLibrarySecondaryButtonBackground,
        .AudioLibrarySecondaryButtonText,
        .SurveyOptionBackground,
        .SurveyOptionText,
        .SurveyOptionProgress,
        .MembershipCardPrimaryElements,
        .MembershipCardSecondaryElements,
        .ScheduleBackground,
        .ScheduleElements,
        .TwitterCardBackground,
        .TwitterCardPrimaryText,
        .TwitterCardMutedText,
        .TwitterCardAnchor,
    ]
    private let itemSize:CGFloat = 250
    
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 16)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Cores Personalizadas"
        return lbl
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(DebugColorItemCell.self, forCellWithReuseIdentifier: "DebugColorItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    
    
    // MARK: - CollectionView Methods
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard DebugManager.isDebugModeEnabled && DebugManager.shared.isColorDebugEnabled else {return}
        DispatchQueue.main.async {
            UIApplication.topViewController()?.questionAlert(title: "Deseja deixar o projeto inteiro em escala de cinza com detaque apenas nos locais de aplicação dessa cor?", message: "Os lugares onde essa cor é aplicada serão sinalizados com a cor ROSA.\n\nAs imagens coloridas permanecerão coloridas.\n\nO app voltará para a tela inicial para que as alterações visuais sejam aplicadas em todas as telas.", handler: { (answer:Bool) in
                if answer {
                    DispatchQueue.main.async {
                        DebugManager.shared.colorToBeDebugged = self.dataSource[indexPath.item]
                        NotificationCenter.default.post(name: Notification.Name(NotificationName.ForceLogout.rawValue), object: nil)
                    }
                }
            })
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DebugColorItemCell", for: indexPath) as! DebugColorItemCell
        let item = self.dataSource[indexPath.item]
        cell.updateContent(item: item)
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
        
        
        
        // This is a Switch just to force an error if a new Color is added to the project
        guard let first = self.dataSource.first else {return}
        switch first {
            case .PrimaryBackground: break
            case .PrimaryText: break
            case .MutedText: break
            case .TextOverSplashImage: break
            case .PrimaryButtonBackground: break
            case .PrimaryButtonText: break
            case .PrimaryAnchor: break
            case .TabBarBackground: break
            case .TabBarSelected: break
            case .TabBarUnselected: break
            case .PrimaryCardBackground: break
            case .PrimaryCardElements: break
            case .SecondaryCardBackground: break
            case .SecondaryCardElements: break
            case .AlternativeCardBackground: break
            case .AlternativeCardElements: break
            case .PageHeaderBackground: break
            case .PageHeaderText: break
            case .AudioLibraryMainButtonBackground: break
            case .AudioLibraryMainButtonText: break
            case .AudioLibrarySecondaryButtonBackground: break
            case .AudioLibrarySecondaryButtonText: break
            case .SurveyOptionBackground: break
            case .SurveyOptionText: break
            case .SurveyOptionProgress: break
            case .MembershipCardPrimaryElements: break
            case .MembershipCardSecondaryElements: break
            case .ScheduleBackground: break
            case .ScheduleElements: break
            case .TwitterCardBackground: break
            case .TwitterCardPrimaryText: break
            case .TwitterCardMutedText: break
            case .TwitterCardAnchor: break
        }
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









class DebugColorItemCell: UICollectionViewCell {
    
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
    private let marker:UIView = {
        let iv = UIView()
        iv.layer.borderWidth = 2.0
        iv.layer.borderColor = Theme.color(.PrimaryCardBackground).cgColor
        iv.layer.shadowColor = Theme.color(.PrimaryCardElements).cgColor
        iv.layer.shadowOffset = CGSize.zero
        iv.layer.shadowOpacity = 0.3
        iv.layer.shadowRadius = 20.0
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 12)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.backgroundColor = Theme.color(.PrimaryCardBackground)
        return lbl
    }()
    
    // MARK: - Methods
    func updateContent(item:Theme.Color) {
        self.marker.backgroundColor = Theme.color(item)
        self.lblTitle.text = item.title()
    }
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        // Back View
        self.addSubview(self.backView)
        self.addFullBoundsConstraintsTo(subView: self.backView, constant: 5)
        // Title
        self.backView.addSubview(self.lblTitle)
        self.lblTitle.addHeightConstraint(20)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Marker
        self.backView.addSubview(self.marker)
        self.backView.addCenterXAlignmentConstraintTo(subView: self.marker, constant: 0)
        self.addConstraint(NSLayoutConstraint(item: self.marker, attribute: .width, relatedBy: .equal, toItem: self.marker, attribute: .height, multiplier: 1.0, constant: 0))
        let padding:CGFloat = 30.0
        self.backView.addTopAlignmentConstraintTo(subView: self.marker, constant: padding)
        self.backView.addVerticalSpacingTo(subView1: self.marker, subView2: self.lblTitle, constant: padding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.marker.layer.cornerRadius = self.marker.bounds.height/2
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

