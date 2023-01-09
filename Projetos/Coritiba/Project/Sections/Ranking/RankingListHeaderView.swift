//
//  RankingListHeaderView.swift
//  
//
//  Created by Roberto Oliveira on 13/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class RankingListHeaderView: UIView {
    
    static let defaultHeight:CGFloat = 120.0
    
    // MARK: - Objects
    let itemView:RankingItemView = RankingItemView()
    let separatorView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.MutedText)
        return vw
    }()
    private let lblInfo0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        lbl.text = "#"
        return lbl
    }()
    private let lblInfo1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        lbl.text = "Torcedor"
        return lbl
    }()
    private let lblInfo2:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        lbl.text = "Moedas"
        return lbl
    }()
    
    
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // separator
        self.addSubview(self.separatorView)
        self.separatorView.addHeightConstraint(1)
        self.addBoundsConstraintsTo(subView: self.separatorView, leading: 20, trailing: -20, top: nil, bottom: 0)
        // item
        self.addSubview(self.itemView)
        self.itemView.addHeightConstraint(RankingItemView.defaultHeight)
        self.addBoundsConstraintsTo(subView: self.itemView, leading: 0, trailing: 0, top: nil, bottom: -5)
        // info 0
        self.addSubview(self.lblInfo0)
        self.addCenterXAlignmentRelatedConstraintTo(subView: self.lblInfo0, reference: self.itemView.lblPosition, constant: 0)
        self.addVerticalSpacingTo(subView1: self.lblInfo0, subView2: self.itemView, constant: 0)
        // info 1
        self.addSubview(self.lblInfo1)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.lblInfo1, reference: self.lblInfo0, constant: 0)
        self.addLeadingAlignmentRelatedConstraintTo(subView: self.lblInfo1, reference: self.itemView.lblTitle, constant: 0)
        // info 2
        self.addSubview(self.lblInfo2)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.lblInfo2, reference: self.lblInfo0, constant: 0)
        self.addCenterXAlignmentRelatedConstraintTo(subView: self.lblInfo2, reference: self.itemView.lblScore, constant: 0)
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
