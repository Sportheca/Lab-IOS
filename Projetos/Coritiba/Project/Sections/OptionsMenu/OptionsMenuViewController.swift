//
//  OptionsMenuViewController.swift
//  
//
//  Created by Roberto Oliveira on 13/04/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol OptionsMenuViewControllerDelegate:AnyObject {
    func optionsMenuViewController(optionsMenuViewController:OptionsMenuViewController, didSelectItem item:BasicInfo)
}

class OptionsMenuViewController: BaseViewController {
    
    // MARK: - Options
    var isLeftSideFixed:Bool = true
    var topSpace:CGFloat = 0.0
    var sideSpace:CGFloat = 0.0
    private let itemHeight:CGFloat = 57.0
    
    
    // MARK: - Properties
    weak var delegate:OptionsMenuViewControllerDelegate?
    private var dataSource:[BasicInfo] = []
    
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(Theme.Color.PrimaryCardBackground)
        vw.layer.cornerRadius = 15.0
        vw.layer.shadowOpacity = 0.2
        vw.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        vw.layer.shadowRadius = 15.0
        return vw
    }()
    private var widthConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private var heightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(OptionsMenuItemCell.self, forCellWithReuseIdentifier: "OptionsMenuItemCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        self.heightConstraint.constant = self.itemHeight * CGFloat(self.dataSource.count)
        var maxWidth:CGFloat = 0.0
        for item in self.dataSource {
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
            lbl.numberOfLines = 1
            lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
            lbl.text = item.title
            lbl.sizeToFit()
            maxWidth = max(maxWidth, lbl.bounds.width)
        }
        self.widthConstraint.constant = maxWidth + 30
        if self.isLeftSideFixed {
            self.view.addBoundsConstraintsTo(subView: self.backView, leading: self.sideSpace, trailing: nil, top: self.topSpace, bottom: nil)
        } else {
            self.view.addBoundsConstraintsTo(subView: self.backView, leading: nil, trailing: -self.sideSpace, top: self.topSpace, bottom: nil)
        }
    }
    
    
    @objc func tap(_ sender: UITapGestureRecognizer){
        if let indexPath = self.collectionView.indexPathForItem(at: sender.location(in: self.collectionView)) {
            self.collectionView.delegate?.collectionView?(self.collectionView, didSelectItemAt: indexPath)
        } else {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func prepareElements() {
        super.prepareElements()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap(_:))))
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        self.view.addSubview(self.backView)
        self.backView.isUserInteractionEnabled = true
        self.backView.addSubview(self.collectionView)
        self.backView.addFullBoundsConstraintsTo(subView: self.collectionView, constant: 0)
        // Height
        self.heightConstraint = NSLayoutConstraint(item: self.backView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.itemHeight)
        self.heightConstraint.priority = UILayoutPriority(999)
        self.view.addConstraint(self.heightConstraint)
        // Width
        self.widthConstraint = NSLayoutConstraint(item: self.backView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 10)
        self.widthConstraint.priority = UILayoutPriority(999)
        self.view.addConstraint(self.widthConstraint)
    }
    
    
    init(items:[BasicInfo], isLeftSideFixed:Bool, topSpace:CGFloat, sideSpace:CGFloat) {
        super.init()
        self.dataSource = items
        self.isLeftSideFixed = isLeftSideFixed
        self.topSpace = topSpace
        self.sideSpace = sideSpace
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}









extension OptionsMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let item = self.dataSource[indexPath.item]
            self.delegate?.optionsMenuViewController(optionsMenuViewController: self, didSelectItem: item)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: self.itemHeight)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsMenuItemCell", for: indexPath) as! OptionsMenuItemCell
        cell.updateContent(title: self.dataSource[indexPath.item].title, isLeftSide: self.isLeftSideFixed)
        cell.separator.isHidden = indexPath.item == 0
        return cell
    }
    
}












class OptionsMenuItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    let separator:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.MutedText).withAlphaComponent(0.5)
        return vw
    }()
    
    
    // MARK: - Methods
    func updateContent(title:String, isLeftSide:Bool) {
        self.lblTitle.text = title
        self.lblTitle.textAlignment = isLeftSide ? .left : .right
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.separator)
        self.separator.addHeightConstraint(1)
        self.addBoundsConstraintsTo(subView: self.separator, leading: 20, trailing: -20, top: 0, bottom: nil)
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 15, trailing: -15, top: 0, bottom: 0)
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
