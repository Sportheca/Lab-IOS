//
//  DebugCurrentColorsView.swift
//
//
//  Created by Roberto Oliveira on 27/11/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class DebugCurrentColorsView: UIView {
    
    // MARK: - Properties
    private var dataSource:[Theme.Color] = []
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = UIColor.orange
        return lbl
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.register(DebugCurrentColorCell.self, forCellWithReuseIdentifier: "DebugCurrentColorCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    // MARK: - Methods
    @objc func update() {
        self.dataSource.removeAll()
        for i in DebugManager.shared.colorsDataSource {
            self.dataSource.append(i)
        }
        self.dataSource.sort { (a:Theme.Color, b:Theme.Color) -> Bool in
            return a.title() < b.title()
        }
        
        DispatchQueue.main.async {
            self.lblTitle.text = "Color Debug: \(self.dataSource.count) items found."
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        self.addSubview(self.containerView)
        self.addFullBoundsConstraintsTo(subView: self.containerView, constant: 0)
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 15, trailing: -15, top: 10, bottom: nil)
        self.lblTitle.addHeightConstraint(15)
        self.addSubview(self.collectionView)
        self.collectionView.addHeightConstraint(60)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.collectionView, constant: 0)
        self.addBoundsConstraintsTo(subView: self.collectionView, leading: 0, trailing: 0, top: nil, bottom: -10)
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
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


extension DebugCurrentColorsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard DebugManager.isDebugModeEnabled && DebugManager.shared.isColorFloatingInspectorEnabled else {return}
        DispatchQueue.main.async {
            DebugManager.shared.colorToBeDebugged = self.dataSource[indexPath.item]
            guard let topVc = (UIApplication.topViewController() as? BaseViewController) else {return}
            topVc.dismissAction()
        }
    }
    
    
    // Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: collectionView.bounds.height-10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DebugCurrentColorCell", for: indexPath) as! DebugCurrentColorCell
        cell.updateContent(item: self.dataSource[indexPath.item])
        return cell
    }
    
}




class DebugCurrentColorCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.black
        vw.layer.borderColor = UIColor.orange.cgColor
        vw.layer.borderWidth = 1.0
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private let colorView:UIView = {
        let vw = UIView()
        vw.layer.cornerRadius = 20.0
        vw.layer.borderColor = UIColor.orange.cgColor
        vw.layer.borderWidth = 1.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 10)
        lbl.textColor = UIColor.orange
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(item:Theme.Color) {
        var color = UIColor(hexString: ProjectInfoManager.colorHexStringFrom(item))
        if DebugManager.isDebugModeEnabled {
            if let debugColor = DebugManager.shared.colorToBeDebugged {
                if item == debugColor {
                    color = UIColor.magenta
                } else {
                    color = color.grayScale()
                }
            }
        }
        self.colorView.backgroundColor = color
        self.lblTitle.text = item.title()
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.containerView)
        self.addFullBoundsConstraintsTo(subView: self.containerView, constant: 0)
        self.addSubview(self.colorView)
        self.colorView.addHeightConstraint(40)
        self.colorView.addWidthConstraint(40)
        self.addCenterYAlignmentConstraintTo(subView: self.colorView, constant: 0)
        self.addLeadingAlignmentConstraintTo(subView: self.colorView, constant: 10)
        self.addSubview(self.lblTitle)
        self.addHorizontalSpacingTo(subView1: self.colorView, subView2: self.lblTitle, constant: 10)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: nil, trailing: -10, top: 0, bottom: 0)
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
