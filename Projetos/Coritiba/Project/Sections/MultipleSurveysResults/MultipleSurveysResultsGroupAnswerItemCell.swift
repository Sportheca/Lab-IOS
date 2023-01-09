//
//  MultipleSurveysResultsGroupAnswerItemCell.swift
//  
//
//  Created by Roberto Oliveira on 3/17/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MultipleSurveysResultsGroupAnswerItemCell: UITableViewCell {
    
    // MARK: - Objects
    private let ivIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = Theme.color(.PrimaryText)
        return iv
    }()
    private let separatorView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.MutedText)
        return vw
    }()
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    private let answersStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 0.0
        return vw
    }()
    private let lblUserAnswer:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 22)
        return lbl
    }()
    private let lblCorrectAnswer:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
        lbl.textColor = Theme.color(.PrimaryAnchor)
        return lbl
    }()
    private let ivCoin:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon_coin")
        return iv
    }()
    private let lblCoins:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 18)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.6
        return lbl
    }()
    
    
    
    
    // MARK: - Methods
    func updateContent(item:MultipleSurveysResultsGroupAnswerItem, headerTitle:String) {
        self.lblHeader.text = headerTitle
        let iconName = item.correct ? "icon_question_answer_right" : "icon_question_answer_wrong"
        self.ivIcon.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        self.lblTitle.text = item.title
        let coinsPrefix:String = item.coins > 0 ? "+" : ""
        self.lblCoins.text = coinsPrefix + item.coins.descriptionWithThousandsSeparator()
        self.lblUserAnswer.text = item.userAnswer
        self.lblUserAnswer.textColor = item.correct ? Theme.color(.PrimaryAnchor) : Theme.color(.MutedText)
        
        if item.correct {
            self.lblCorrectAnswer.text = nil
            self.lblCorrectAnswer.isHidden = true
        } else {
            self.lblCorrectAnswer.text = "Resposta Correta: " + (item.correctAnswer ?? "")
            self.lblCorrectAnswer.isHidden = false
        }
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        // Separator
        self.addSubview(self.separatorView)
        self.separatorView.addHeightConstraint(1)
        self.addBoundsConstraintsTo(subView: self.separatorView, leading: 20, trailing: -20, top: nil, bottom: 0)
        // Icon
        self.addSubview(self.ivIcon)
        self.ivIcon.addWidthConstraint(28)
        self.ivIcon.addHeightConstraint(28)
        self.addBoundsConstraintsTo(subView: self.ivIcon, leading: nil, trailing: -20, top: 15, bottom: nil)
        // Header
        self.addSubview(self.lblHeader)
        self.addBoundsConstraintsTo(subView: self.lblHeader, leading: 20, trailing: nil, top: 15, bottom: nil)
        // Title
        self.addSubview(self.lblTitle)
        self.addVerticalSpacingTo(subView1: self.lblHeader, subView2: self.lblTitle, constant: 3)
        self.addLeadingAlignmentConstraintTo(subView: self.lblTitle, constant: 20)
        self.addHorizontalSpacingTo(subView1: self.lblTitle, subView2: self.ivIcon, constant: 20)
        // Coins
        self.addSubview(self.ivCoin)
        self.ivCoin.addWidthConstraint(18)
        self.ivCoin.addHeightConstraint(18)
        self.addTrailingAlignmentConstraintTo(subView: self.ivCoin, constant: -20)
        self.addVerticalSpacingTo(subView1: self.ivIcon, subView2: self.ivCoin, constant: 12)
        self.addSubview(self.lblCoins)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.lblCoins, reference: self.ivCoin, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.lblCoins, subView2: self.ivCoin, constant: 4)
        self.lblCoins.addWidthConstraint(60)
        // Answers
        self.addSubview(self.answersStackView)
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.answersStackView, constant: 10)
        self.addBoundsConstraintsTo(subView: self.answersStackView, leading: 20, trailing: nil, top: nil, bottom: -15)
        self.addHorizontalSpacingTo(subView1: self.answersStackView, subView2: self.lblCoins, constant: 5)
        self.answersStackView.addArrangedSubview(self.lblUserAnswer)
        self.answersStackView.addArrangedSubview(self.lblCorrectAnswer)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
