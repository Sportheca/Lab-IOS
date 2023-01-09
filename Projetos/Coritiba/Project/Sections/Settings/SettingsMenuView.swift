//
//  SettingsMenuView.swift
//  
//
//  Created by Roberto Oliveira on 27/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol SettingsMenuViewDelegate:AnyObject {
    func settingsMenuView(settingsMenuView:SettingsMenuView, didSelectItem item:BasicInfo)
}

class SettingsMenuView: UIView {
    
    // MARK: - Properties
    weak var delegate:SettingsMenuViewDelegate?
    var dataSource:[BasicInfo] = []
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 25.0
        return vw
    }()
    let loadingView:ContentLoadingView = ContentLoadingView()
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
    func updateContent(items:[BasicInfo]) {
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
        self.addFullBoundsConstraintsTo(subView: self.containerView, constant: 10)
        self.heightConstraint = NSLayoutConstraint(item: self.containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200)
        self.heightConstraint.priority = UILayoutPriority(999)
        self.containerView.addConstraint(self.heightConstraint)
        self.containerView.addSubview(self.collectionView)
        self.containerView.addFullBoundsConstraintsTo(subView: self.collectionView, constant: 0)
        // Loading
        self.containerView.addSubview(self.loadingView)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.containerView.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
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

extension SettingsMenuView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.settingsMenuView(settingsMenuView: self, didSelectItem: self.dataSource[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1) {
                collectionView.cellForItem(at: indexPath)?.alpha = 0.5
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1) {
                collectionView.cellForItem(at: indexPath)?.alpha = 1.0
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
        cell.lblTitle.text = self.dataSource[indexPath.item].title
        cell.separatorView.isHidden = indexPath.item == 0
        return cell
    }
    
}


class SettingsMenuItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    let separatorView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.MutedText)
        return vw
    }()
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 12)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        return lbl
    }()
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.separatorView)
        self.separatorView.addHeightConstraint(1)
        self.addBoundsConstraintsTo(subView: self.separatorView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 25, trailing: -25, top: 0, bottom: 0)
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
