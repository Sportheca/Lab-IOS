//
//  QuestionResultView.swift
//  
//
//  Created by Roberto Oliveira on 11/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

enum QuestionResultMode {
    case Correct
    case Wrong
    case TimeOut
}

class QuestionResultView: UIView {
    
    // MARK: - Objects
    private let verticalStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 7
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 14)
        lbl.textColor = Theme.color(.PrimaryAnchor)
        return lbl
    }()
    private let coinsStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 2.0
        return vw
    }()
    private let lblCoins:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .right
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 20)
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    private let ivCoin:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon_coin")
        return iv
    }()
    
    
    
    
    // MARK: - Methods
    func updateContent(mode:QuestionResultMode, coins:Int?) {
        var prefix:String = "-"
        switch mode {
        case .Correct:
            self.lblTitle.text = "Você acertou!"
            prefix = "+"
            break
        case .Wrong:
            self.lblTitle.text = "Você errou!"
            break
        case .TimeOut:
            self.lblTitle.text = "Tempo esgotado!"
            break
        }
        if let value = coins {
            self.lblCoins.text = "\(prefix)\(value.descriptionWithThousandsSeparator())"
            self.coinsStackView.isHidden = false
        } else {
            self.coinsStackView.isHidden = true
        }
    }
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.verticalStackView)
        self.addCenterXAlignmentConstraintTo(subView: self.verticalStackView, constant: 0)
        self.addBoundsConstraintsTo(subView: self.verticalStackView, leading: nil, trailing: nil, top: 0, bottom: -10)
        self.verticalStackView.addArrangedSubview(self.lblTitle)
        self.verticalStackView.addArrangedSubview(self.coinsStackView)
        self.coinsStackView.addArrangedSubview(self.lblCoins)
        self.coinsStackView.addArrangedSubview(self.ivCoin)
        self.ivCoin.addHeightConstraint(18)
        self.ivCoin.addWidthConstraint(18)
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
