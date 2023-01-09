//
//  NotificationCentralContentView.swift
//  
//
//  Created by Roberto Oliveira on 07/04/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol NotificationCentralContentViewDelegate:AnyObject {
    func notificationCentralContentView(notificationCentralContentView:NotificationCentralContentView, didSelectItem item:NotificationsCentralItem)
}

class NotificationCentralContentView: PaginationContentView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Objects
    weak var delegate:NotificationCentralContentViewDelegate?
    let loadingView:ContentLoadingView = ContentLoadingView()
    
    
    
    // MARK: - Methods
    // Layout
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                collectionView.cellForItem(at: indexPath)?.alpha = 0.4
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                collectionView.cellForItem(at: indexPath)?.alpha = 1.0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        guard let item = self.dataSource[indexPath.item] as? NotificationsCentralItem else {return CGSize.zero}
        let height = NotificationCentralItemCell.requiredHeight(item: item, width: width)
        return CGSize(width: width, height: height)
    }
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard let item = self.dataSource[indexPath.item] as? NotificationsCentralItem else {return}
            item.read = true
            self.delegate?.notificationCentralContentView(notificationCentralContentView: self, didSelectItem: item)
            self.collectionView.reloadData()
        }
    }
    
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
        self.handlePagination(indexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationCentralItemCell", for: indexPath) as! NotificationCentralItemCell
        guard let item = self.dataSource[indexPath.item] as? NotificationsCentralItem else {return cell}
        cell.updateContent(item: item)
        return cell
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.refreshControl.tintColor = Theme.color(.MutedText)
        self.backgroundColor = UIColor.clear
        self.collectionView.register(NotificationCentralItemCell.self, forCellWithReuseIdentifier: "NotificationCentralItemCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        (self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
        self.addSubview(self.loadingView)
        self.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
    }
    
}





class NotificationCentralItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let separator:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.MutedText)
        return vw
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 0.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        return lbl
    }()
    private let lblMessage:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        return lbl
    }()
    
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(item:NotificationsCentralItem) {
        // texts
        self.lblTitle.text = item.title
        self.lblMessage.text = item.message
        // appearance
        self.lblTitle.textColor = item.read ? Theme.color(.MutedText) : Theme.color(.PrimaryText)
        self.lblMessage.textColor = item.read ? Theme.color(.MutedText) : Theme.color(.PrimaryText)
    }
    
    
    static func requiredHeight(item:NotificationsCentralItem, width:CGFloat) -> CGFloat {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: width-50, height: 10))
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.text = item.title
        let lbl2 = UILabel(frame: CGRect(x: 0, y: 0, width: width-50, height: 10))
        lbl2.numberOfLines = 0
        lbl2.textAlignment = .left
        lbl2.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.text = item.message
        return lbl.contentHeight() + lbl2.contentHeight() + 30
    }
    
    
    
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Content
        self.addSubview(self.stackView)
        self.addBoundsConstraintsTo(subView: self.stackView, leading: 25, trailing: -25, top: nil, bottom: nil)
        self.addCenterYAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.lblMessage)
        // Separator
        self.addSubview(self.separator)
        self.addBoundsConstraintsTo(subView: self.separator, leading: 20, trailing: -20, top: nil, bottom: 0)
        self.separator.addHeightConstraint(1)
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


