//
//  MatchDetailsStatsView.swift
//  
//
//  Created by Roberto Oliveira on 3/16/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MatchDetailsStatsView: UIView {
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardBackground)
        return vw
    }()
    private let adsView:AdsView = {
        let vw = AdsView()
        vw.lblTitle.textColor = Theme.color(.AlternativeCardElements)
        return vw
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 20.0
        return vw
    }()
    
    
    
    
    // MARK: - Methods
    func updateContent(item:MatchDetails) {
        for sub in self.stackView.arrangedSubviews {
            sub.removeFromSuperview()
        }
        for info in item.infos {
            let vw = MatchDetailsStatsItemView()
            vw.updateContent(info: info)
            self.stackView.addArrangedSubview(vw)
        }
        // Ads
        self.adsView.updateContent(position: AdsPosition.QuizDashboard)
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // back
        self.addSubview(self.backView)
        self.addBoundsConstraintsTo(subView: self.backView, leading: nil, trailing: nil, top: 15, bottom: -15)
        self.addCenterXAlignmentConstraintTo(subView: self.backView, constant: 0)
        self.backView.addWidthConstraint(constant: 500, relatedBy: .lessThanOrEqual, priority: 999)
        self.addLeadingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: 0, priority: 750)
        self.addTrailingAlignmentConstraintTo(subView: self.backView, relatedBy: .equal, constant: 0, priority: 750)
        // Ads
//        self.backView.addSubview(self.adsView)
//        self.backView.addBoundsConstraintsTo(subView: self.adsView, leading: 10, trailing: -10, top: 10, bottom: nil)
//        self.adsView.addHeightConstraint(50)
        // Stack
        self.backView.addSubview(self.stackView)
//        self.backView.addVerticalSpacingTo(subView1: self.adsView, subView2: self.stackView, constant: 20)
        self.backView.addTopAlignmentConstraintTo(subView: self.stackView, constant: 40)
        self.backView.addBoundsConstraintsTo(subView: self.stackView, leading: 20, trailing: -20, top: nil, bottom: -40)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}


class MatchDetailsStatsItemView: UIView {
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .equalCentering
        vw.spacing = 5.0
        return vw
    }()
    private let lblInfo0:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 18)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        return lbl
    }()
    private let lblInfo1:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.numberOfLines = 1
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 18)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        return lbl
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    
    
    
    
    
    // MARK: - Methods
    func updateContent(info:MatchDetailsInfo) {
        self.lblTitle.text = info.title
        self.lblInfo0.text = info.value0
        self.lblInfo1.text = info.value1
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Stack
        self.addSubview(self.stackView)
        self.addFullBoundsConstraintsTo(subView: self.stackView, constant: 0)
        self.stackView.addArrangedSubview(self.lblInfo0)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.lblInfo1)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}


