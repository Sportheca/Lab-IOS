//
//  MultipleSurveysResultsGroupHeaderView.swift
//  
//
//  Created by Roberto Oliveira on 3/17/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MultipleSurveysResultsGroupHeaderView: UIView {
    
    // MARK: - Objects
    private let backView:UIView = {
        let iv = UIView()
        iv.backgroundColor = Theme.color(.PrimaryCardBackground)
        iv.layer.cornerRadius = 25.0
        iv.clipsToBounds = true
        iv.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return iv
    }()
    let lblX:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        return lbl
    }()
    private let ivCover0:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblScore0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 21)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let ivCover1:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblScore1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 21)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let lblCoins:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 18)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let ivCoin:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon_coin")
        return iv
    }()
    private let separatorView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardElements).withAlphaComponent(0.5)
        return vw
    }()
    private let summaryStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fillEqually
        vw.spacing = 0.0
        return vw
    }()
    private let lblSummary0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let lblSummary1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    private let lblSummary2:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.textColor = Theme.color(.PrimaryCardElements)
        return lbl
    }()
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent(group:MultipleSurveysResultsGroup, items:[MultipleSurveysResultsGroupAnswerItem], animated:Bool) {
        let coinsPrefix:String = group.coins > 0 ? "+" : ""
        self.lblCoins.text = coinsPrefix + group.coins.descriptionWithThousandsSeparator()
        
        // summary
        var attributed0 = NSAttributedString()
        var attributed1 = NSAttributedString()
        var attributed2 = NSAttributedString()
        if !items.isEmpty {
            var correctAnswers:Int = 0
            for item in items {
                if item.correct {
                    correctAnswers += 1
                }
            }
            let totalAnswers = items.count
            let wrongAnswers = totalAnswers - correctAnswers
            attributed0 = self.attributedSummary(title: "Acertos", info: correctAnswers.descriptionWithThousandsSeparator())
            attributed1 = self.attributedSummary(title: "Erros", info: wrongAnswers.descriptionWithThousandsSeparator())
            attributed2 = self.attributedSummary(title: "Total", info: totalAnswers.descriptionWithThousandsSeparator())
        }
        self.lblSummary0.attributedText = attributed0
        self.lblSummary1.attributedText = attributed1
        self.lblSummary2.attributedText = attributed2
        if !items.isEmpty {
            let duration:TimeInterval = animated ? 0.5 : 0.0
            UIView.animate(withDuration: duration) {
                self.summaryStackView.alpha = 1.0
            }
        }
        
        self.lblScore0.text = group.club0.goals.descriptionWithThousandsSeparator()
        self.lblScore1.text = group.club1.goals.descriptionWithThousandsSeparator()
        self.ivCover0.setServerImage(urlString: group.club0.imageUrl)
        self.ivCover1.setServerImage(urlString: group.club1.imageUrl)
        guard let p0 = group.club0.penaltyGoals, let p1 = group.club1.penaltyGoals else {
            self.lblX.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 24)
            self.lblX.textColor = Theme.color(.MutedText)
            self.lblX.text = "x"
            return
        }
        self.lblX.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 16)
        self.lblX.textColor = Theme.color(.PrimaryCardElements)
        self.lblX.text = "(\(p0.description) x \(p1.description))"
    }
    
    
    private func attributedSummary(title:String, info:String) -> NSAttributedString {
        let attributed = NSMutableAttributedString()
        attributed.append(NSAttributedString(string: "\(title)\n", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        ]))
        attributed.append(NSAttributedString(string: info, attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 24)
        ]))
        return attributed
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 6.0
        self.layer.shadowOffset = CGSize(width: 0, height: 10.0)
        // background
        self.addSubview(self.backView)
        self.addFullBoundsConstraintsTo(subView: self.backView, constant: 0)
        // X
        self.backView.addSubview(self.lblX)
        self.backView.addCenterXAlignmentConstraintTo(subView: self.lblX, constant: 0)
        // Score 0
        self.backView.addSubview(self.lblScore0)
        self.backView.addHorizontalSpacingTo(subView1: self.lblScore0, subView2: self.lblX, constant: 15)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.lblScore0, reference: self.lblX, constant: 0)
        // Score 1
        self.backView.addSubview(self.lblScore1)
        self.backView.addHorizontalSpacingTo(subView1: self.lblX, subView2: self.lblScore1, constant: 15)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.lblScore1, reference: self.lblX, constant: 0)
        // Cover 0
        self.backView.addSubview(self.ivCover0)
        self.ivCover0.addWidthConstraint(39)
        self.ivCover0.addHeightConstraint(39)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.ivCover0, reference: self.lblX, constant: 0)
        self.backView.addHorizontalSpacingTo(subView1: self.ivCover0, subView2: self.lblScore0, constant: 10)
        // Cover 1
        self.backView.addSubview(self.ivCover1)
        self.ivCover1.addWidthConstraint(39)
        self.ivCover1.addHeightConstraint(39)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.ivCover1, reference: self.lblX, constant: 0)
        self.backView.addHorizontalSpacingTo(subView1: self.lblScore1, subView2: self.ivCover1, constant: 10)
        // Coins
        self.backView.addSubview(self.ivCoin)
        self.ivCoin.addWidthConstraint(18)
        self.ivCoin.addHeightConstraint(18)
        self.backView.addTrailingAlignmentConstraintTo(subView: self.ivCoin, constant: -20)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.ivCoin, reference: self.lblX, constant: 0)
        self.backView.addSubview(self.lblCoins)
        self.backView.addHorizontalSpacingTo(subView1: self.lblCoins, subView2: self.ivCoin, constant: 4)
        self.backView.addCenterYAlignmentRelatedConstraintTo(subView: self.lblCoins, reference: self.ivCoin, constant: 0)
        // Separator
        self.backView.addSubview(self.separatorView)
        self.backView.addBoundsConstraintsTo(subView: self.separatorView, leading: 20, trailing: -20, top: nil, bottom: nil)
        self.separatorView.addHeightConstraint(1)
        self.backView.addVerticalSpacingTo(subView1: self.ivCover0, subView2: self.separatorView, constant: 15)
        // Summary
        self.backView.addSubview(self.summaryStackView)
        self.backView.addVerticalSpacingTo(subView1: self.separatorView, subView2: self.summaryStackView, constant: 10)
        self.backView.addBoundsConstraintsTo(subView: self.summaryStackView, leading: 20, trailing: -20, top: nil, bottom: -20)
        self.summaryStackView.addHeightConstraint(50)
        self.summaryStackView.addArrangedSubview(self.lblSummary0)
        self.summaryStackView.addArrangedSubview(self.lblSummary1)
        self.summaryStackView.addArrangedSubview(self.lblSummary2)
        self.summaryStackView.alpha = 0.0
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
