//
//  CoinsAlertView.swift
//
//
//  Created by Roberto Oliveira on 07/06/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

extension UIViewController {
    func showCoinsAlert(addCoins count: Int) {
        let statusView = CoinsAlertView(count: count)
        statusView.animateDown()
    }
}

class CoinsAlertView: UIView {
    
    // MARK: - Properties
    private var heightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    
    
    
    // MARK: - Options
    private var count:Int = 0
    private let animationTime:Double = 0.3
    
    
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.layer.cornerRadius = 15.0
        vw.layer.shadowRadius = 3.0
        vw.layer.shadowOpacity = 0.2
        vw.layer.shadowOffset = CGSize(width: 0, height: 2)
        return vw
    }()
    private let lblMessage:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 15)
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    private let scoreStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .top
        vw.distribution = .fill
        vw.spacing = 2.0
        return vw
    }()
    private let lblScore:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .right
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 17)
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
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.alpha = 0.0
        // container
        self.addSubview(self.containerView)
        self.containerView.addHeightConstraint(constant: 60, relatedBy: .equal, priority: 750)
        self.addBoundsConstraintsTo(subView: self.containerView, leading: nil, trailing: nil, top: nil, bottom: -5)
        self.addCenterXAlignmentConstraintTo(subView: self.containerView, constant: 0)
        self.addLeadingAlignmentConstraintTo(subView: self.containerView, relatedBy: .equal, constant: 10, priority: 750)
        self.addTrailingAlignmentConstraintTo(subView: self.containerView, relatedBy: .equal, constant: -10, priority: 750)
        self.containerView.addWidthConstraint(constant: 400, relatedBy: .lessThanOrEqual, priority: 999)
        // Score
        self.containerView.addSubview(self.scoreStackView)
        self.containerView.addTrailingAlignmentConstraintTo(subView: self.scoreStackView, constant: -20)
        self.containerView.addCenterYAlignmentConstraintTo(subView: self.scoreStackView, constant: 0)
        self.scoreStackView.addArrangedSubview(self.lblScore)
        self.lblScore.addWidthConstraint(150)
        self.scoreStackView.addArrangedSubview(self.ivCoin)
        self.ivCoin.addHeightConstraint(25)
        self.ivCoin.addWidthConstraint(25)
        // coins
        self.containerView.addSubview(self.lblMessage)
        self.containerView.addBoundsConstraintsTo(subView: self.lblMessage, leading: 15, trailing: nil, top: 0, bottom: 0)
        
        
        guard let vc = UIApplication.topViewController() else {return}
        vc.view.addSubview(self)
        vc.view.addBoundsConstraintsTo(subView: self, leading: 0, trailing: 0, top: 0, bottom: nil)
        vc.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.containerView, constant: 0, priority: 500, relatedBy: .equal)
        self.heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
        self.heightConstraint.priority = UILayoutPriority(900)
        self.heightConstraint.isActive = true
        vc.view.addConstraint(self.heightConstraint)
        vc.view.layoutIfNeeded()
        
        
        let scoreDescriptions = self.count > 0 ? "ganhou" : "perdeu"
        let coinsDescription = abs(self.count) == 1 ? "moeda" : "moedas"
        self.lblMessage.text = "Você \(scoreDescriptions) \(self.count) \(coinsDescription)"
        self.updateCoinsText()
    }
    
    func animateDown() {
        guard let user = ServerManager.shared.user, self.count != 0 else {return}
        DispatchQueue.main.async {
            self.alpha = 1.0
            self.heightConstraint.isActive = false
            UIView.animate(withDuration: self.animationTime, animations: {
                UIApplication.topViewController()?.view.layoutIfNeeded()
            }, completion: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+self.animationTime+0.5) {
            let newCoins = (user.coins ?? 0) + self.count
            user.coins = newCoins
            self.updateCoinsText()
            self.scoreStackView.bounceAnimation()
        }
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.animateUp), userInfo: nil, repeats: false)
    }
    
    @objc func animateUp() {
        DispatchQueue.main.async {
            self.heightConstraint.isActive = true
            UIView.animate(withDuration: self.animationTime, animations: {
                UIApplication.topViewController()?.view.layoutIfNeeded()
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
    }
    
    
    private func updateCoinsText() {
        let coins = ServerManager.shared.user?.coins ?? 0
        let attributed = NSMutableAttributedString()
        attributed.append(NSAttributedString(string: coins.descriptionWithThousandsSeparator(), attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 16)
        ]))
        let coinTitle = coins == 1 ? "Moeda" : "Moedas"
        attributed.append(NSAttributedString(string: "\n\(coinTitle)", attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 10)
        ]))
        self.lblScore.attributedText = attributed
    }
    
    
    
    // MARK: - Init Methods
    init(count:Int) {
        super.init(frame: CGRect.zero)
        self.count = count
        self.prepareElements()
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


