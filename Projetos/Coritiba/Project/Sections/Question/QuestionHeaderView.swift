//
//  QuestionHeaderView.swift
//  
//
//  Created by Roberto Oliveira on 11/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class QuestionHeaderView: UIView {
    
    // MARK: - Objects
    private let ivCover:OverlayImageView = OverlayImageView()
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
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 24)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let adsView:AdsView = AdsView()
    
    
    // MARK: - Methods
    func updateContent(item:QuizGroup) {
        self.ivCover.backgroundColor = Theme.color(Theme.Color.PrimaryCardBackground)
        self.ivCover.updateColor(Theme.color(Theme.Color.PrimaryCardBackground))
        self.lblTitle.textColor = Theme.color(.PrimaryText)
        
        self.ivCover.setServerImage(urlString: item.imageUrlString)
        self.lblTitle.text = item.title
        self.adsView.updateContent(position: AdsPosition.QuizInterna)
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.addSubview(self.ivCover)
        self.ivCover.addHeightConstraint(100)
        self.addFullBoundsConstraintsTo(subView: self.ivCover, constant: 0)
        self.addSubview(self.stackView)
        self.addCenterYAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.addBoundsConstraintsTo(subView: self.stackView, leading: 10, trailing: -10, top: nil, bottom: nil)
        self.stackView.addArrangedSubview(self.lblTitle)
//        self.stackView.addArrangedSubview(self.adsView)
//        self.adsView.addHeightConstraint(50)
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
