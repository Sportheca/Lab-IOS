//
//  SquadSchemeSelectorView.swift
//  
//
//  Created by Roberto Oliveira on 05/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol SquadSchemeSelectorViewDelegate:AnyObject {
    func squadSchemeSelectorView(squadSchemeSelectorView:SquadSchemeSelectorView, didSelectScheme scheme:SquadScheme)
}

class SquadSchemeSelectorView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    weak var delegate:SquadSchemeSelectorViewDelegate?
    private var selectedScheme:SquadScheme = SquadScheme.s343
    private let dataSource:[SquadScheme] = [
        SquadScheme.s343,
        SquadScheme.s352,
        SquadScheme.s4132,
        SquadScheme.s41212,
        SquadScheme.s4141,
        SquadScheme.s4222,
        SquadScheme.s4231,
        SquadScheme.s424,
        SquadScheme.s433,
        SquadScheme.s433falso9,
        SquadScheme.s4411,
        SquadScheme.s442,
        SquadScheme.s451,
//        SquadScheme.s5212,
//        SquadScheme.s523,
//        SquadScheme.s532,
//        SquadScheme.s541,
    ]
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 12)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.text = "Formação"
        return lbl
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(SquadSchemeSelectorCell.self, forCellWithReuseIdentifier: "SquadSchemeSelectorCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    // MARK: - Methods
    func updateContent(selectedScheme:SquadScheme) {
        DispatchQueue.main.async {
            self.selectedScheme = selectedScheme
            self.collectionView.reloadData()
            var selectedIndex:Int?
            for (i,item) in self.dataSource.enumerated() {
                if item == selectedScheme {
                    selectedIndex = i
                }
            }
            if let selected = selectedIndex {
                self.collectionView.scrollToItem(at: IndexPath(item: selected, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.selectedScheme = self.dataSource[indexPath.item]
            for index in self.collectionView.indexPathsForVisibleItems {
                guard let cell = self.collectionView.cellForItem(at: index) as? SquadSchemeSelectorCell else {continue}
                let item = self.dataSource[index.item]
                cell.updateContent(title: item.title(), highlighted: item == self.selectedScheme)
            }
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.delegate?.squadSchemeSelectorView(squadSchemeSelectorView: self, didSelectScheme: self.selectedScheme)
        }
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Medium, size: 14)
        lbl.text = self.dataSource[indexPath.item].title()
        lbl.sizeToFit()
        return CGSize(width: lbl.bounds.width+20, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 10, height: 10)
    }
    
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquadSchemeSelectorCell", for: indexPath) as! SquadSchemeSelectorCell
        let item = self.dataSource[indexPath.item]
        cell.updateContent(title: item.title(), highlighted: item == self.selectedScheme)
        return cell
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 10, trailing: -10, top: 0, bottom: nil)
        self.lblTitle.addHeightConstraint(18)
        self.addSubview(self.collectionView)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.collectionView, constant: 0)
        self.collectionView.addHeightConstraint(30)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: 0)
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










class SquadSchemeSelectorCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.layer.cornerRadius = 11.0
        vw.clipsToBounds = true
        vw.layer.borderWidth = 1.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Medium, size: 14)
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(title:String, highlighted:Bool) {
        self.lblTitle.text = title
        if highlighted {
            self.backView.backgroundColor = Theme.color(.PrimaryCardElements)
            self.backView.layer.borderColor = UIColor.clear.cgColor
            self.lblTitle.textColor = Theme.color(.PrimaryCardBackground)
        } else {
            self.backView.backgroundColor = UIColor.clear
            self.backView.layer.borderColor = Theme.color(.PrimaryCardElements).cgColor
            self.lblTitle.textColor = Theme.color(.PrimaryCardElements)
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.addCenterYAlignmentConstraintTo(subView: self.backView, constant: 0)
        self.backView.addHeightConstraint(24)
        self.addSubview(self.lblTitle)
        self.addFullBoundsConstraintsTo(subView: self.lblTitle, constant: 0)
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
