//
//  AllVideosCell.swift
//
//
//  Created by Roberto Oliveira on 17/02/21.
//  Copyright © 2021 Roberto Oliveira. All rights reserved.
//

import UIKit

class AllVideosCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor(R: 200, G: 200, B: 200)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 14.0
        return vw
    }()
    private let gradientView:CustomGradientView = {
        let vw = CustomGradientView()
        vw.point1 = CGPoint(x: 0, y: 0)
        vw.point2 = CGPoint(x: 1.0, y: 1.0)
        vw.color1 = Theme.color(.PrimaryButtonBackground)//UIColor(R: 74, G: 163, B: 238)
        vw.color2 = Theme.color(.PrimaryButtonBackground)//UIColor(R: 3, G: 90, B: 164)
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: 18)
        lbl.textColor = Theme.color(.PrimaryButtonText)
        lbl.text = "Ver Todos"
        return lbl
    }()
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.containerView)
        self.addBoundsConstraintsTo(subView: self.containerView, leading: 0, trailing: 0, top: 0, bottom: 0)
        self.containerView.addSubview(self.gradientView)
        self.containerView.addFullBoundsConstraintsTo(subView: self.gradientView, constant: 0)
        self.containerView.addSubview(self.lblTitle)
        self.containerView.addFullBoundsConstraintsTo(subView: self.lblTitle, constant: 10)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.prepareElements()
    }
    
}


