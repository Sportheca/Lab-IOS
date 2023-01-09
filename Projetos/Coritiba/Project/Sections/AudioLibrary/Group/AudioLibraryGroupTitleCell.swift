//
//  AudioLibraryGroupTitleCell.swift
//  
//
//  Created by Roberto Oliveira on 3/23/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class AudioLibraryGroupTitleCell: UICollectionViewCell {
    
    static let defaultHeight:CGFloat = 50.0
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 16)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    
    
    
    // MARK: - Methods
    func updateContent(title:String) {
        self.lblTitle.text = title
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: nil, trailing: nil, top: 0, bottom: -20)
        self.addCenterXAlignmentConstraintTo(subView: self.backView, constant: 0)
        self.backView.addWidthConstraint(constant: 450, relatedBy: .lessThanOrEqual, priority: 999)
        self.addLeadingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: 20, priority: 750)
        self.addTrailingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: -20, priority: 750)
        // Title
        self.backView.addSubview(self.lblTitle)
        self.backView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 0, trailing: 0, top: nil, bottom: 0)
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


