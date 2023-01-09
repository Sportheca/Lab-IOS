//
//  CoinsView.swift
//  
//
//  Created by Roberto Oliveira on 3/16/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class CoinsView: UIView {
    
    // MARK: - Objects
    private let ivCoin:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon_coin")
        return iv
    }()
    let lblCoins:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .left
        lbl.textColor = UIColor(hexString: "F4F5F7")
        return lbl
    }()
    
    
    
    
    // MARK: - Methods
    func updateContent() {
        let coins = ServerManager.shared.user?.coins ?? 0
        let attributed = NSMutableAttributedString()
        attributed.append(NSAttributedString(string: coins.descriptionWithThousandsSeparator(), attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Knockout.Regular, size: 15)
        ]))
        let coinTitle = coins == 1 ? "Moeda" : "Moedas"
        attributed.append(NSAttributedString(string: "\n\(coinTitle)", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Knockout.Regular, size: 15)
        ]))
        self.lblCoins.attributedText = attributed
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.addSubview(self.lblCoins)
        self.addBoundsConstraintsTo(subView: self.lblCoins, leading: nil, trailing: 0, top: 0, bottom: 0)
        self.addSubview(self.ivCoin)
        self.ivCoin.addHeightConstraint(25)
        self.ivCoin.addWidthConstraint(25)
        self.addCenterYAlignmentConstraintTo(subView: self.ivCoin, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.ivCoin, subView2: self.lblCoins, constant: 4)
        self.addLeadingAlignmentConstraintTo(subView: self.ivCoin, constant: 0)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
