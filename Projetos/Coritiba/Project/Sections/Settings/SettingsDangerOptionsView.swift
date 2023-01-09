//
// SettingsDangerOptionsView.swift
// 
//
// Created by Roberto Oliveira on 17/03/22.
// Copyright © 2022 Sportheca. All rights reserved.
//


import UIKit

protocol SettingsDangerOptionsViewDelegate:AnyObject {
    func settingsDangerOptionsView(settingsDangerOptionsView:SettingsDangerOptionsView, didSelectItem item:SettingsDangerOptionItem)
}

enum SettingsDangerOptionItem:String {
    case DeleteAccount = "Excluir Conta"
}

class SettingsDangerOptionsView: UIView {
    
    // MARK: - Properties
    weak var delegate:SettingsDangerOptionsViewDelegate?
    var dataSource:[SettingsDangerOptionItem] = []
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private var heightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(SettingsMenuItemCell.self, forCellWithReuseIdentifier: "SettingsMenuItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    // MARK: - Methods
    func updateContent(items:[SettingsDangerOptionItem]) {
        DispatchQueue.main.async {
            self.dataSource.removeAll()
            self.dataSource = items
            self.collectionView.reloadData()
            let height:CGFloat = items.isEmpty ? 200 : 70*CGFloat(self.dataSource.count)
            self.heightConstraint.constant = height
            UIApplication.topViewController()?.view.layoutIfNeeded()
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.containerView)
        self.addBoundsConstraintsTo(subView: self.containerView, leading: 17, trailing: -17, top: 10, bottom: -10)
        self.heightConstraint = NSLayoutConstraint(item: self.containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200)
        self.heightConstraint.priority = UILayoutPriority(999)
        self.containerView.addConstraint(self.heightConstraint)
        self.containerView.addSubview(self.collectionView)
        self.containerView.addFullBoundsConstraintsTo(subView: self.collectionView, constant: 0)
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

extension SettingsDangerOptionsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataSource[indexPath.item]
        self.delegate?.settingsDangerOptionsView(settingsDangerOptionsView: self, didSelectItem: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1) {
                guard let cell = collectionView.cellForItem(at: indexPath) as? SettingsMenuItemCell else {return}
                cell.lblTitle.alpha = 0.5
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1) {
                guard let cell = collectionView.cellForItem(at: indexPath) as? SettingsMenuItemCell else {return}
                cell.lblTitle.alpha = 1.0
            }
        }
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 70)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsMenuItemCell", for: indexPath) as! SettingsMenuItemCell
        cell.lblTitle.text = self.dataSource[indexPath.item].rawValue
        cell.separatorView.isHidden = indexPath.item == 0
        return cell
    }
    
}
