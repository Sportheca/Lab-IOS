//
//  StoreItemCell.swift
//
//
//  Created by Roberto Oliveira on 13/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class StoreItemCell: UICollectionViewCell {
    
    // MARK: - Objects
    private let shadowView:UIView = {
        let vw = UIView()
//        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
//        vw.layer.shadowColor = Theme.color(.PrimaryCardBackground).cgColor
//        vw.layer.shadowOpacity = 0.15
//        vw.layer.shadowRadius = 5.0
//        vw.layer.shadowOffset = CGSize(width: 0, height: 5.0)
//        vw.layer.borderWidth = 1.0
//        vw.layer.borderColor = UIColor(hexString: "847248").cgColor
        return vw
    }()
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor(hexString: "003D38")
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.isPlaceholderTintColorEnabled = true
        iv.tintColor = Theme.color(Theme.Color.MutedText)
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 0.0
        return vw
    }()
    private let lblTitle:InsetsLabel = {
        let lbl = InsetsLabel()
        lbl.leftInset = 10.0
        lbl.rightInset = 10.0
        lbl.numberOfLines = 3
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 12)
        lbl.textColor = UIColor.white
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let lblSubtitle:InsetsLabel = {
        let lbl = InsetsLabel()
        lbl.leftInset = 10.0
        lbl.rightInset = 10.0
        lbl.numberOfLines = 3
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let coinsView:StoreItemCoinsView = {
        let vw = StoreItemCoinsView()
        vw.lblTitle0.textColor = UIColor.white
        return vw
    }()
    private let exclusiveTagView:StoreExclusiveTagView = StoreExclusiveTagView()
    
    
    
    // MARK: - Methods
    func updateContent(item:StoreItem) {
        self.ivCover.setServerImage(urlString: item.imageUrlString, placeholderImageName: nil)
        self.lblTitle.text = item.title
        self.lblSubtitle.text = item.subtitle
        self.lblSubtitle.isHidden = item.subtitle == nil
        self.coinsView.updateContent(coins0: item.coins, coins1: item.membershipCoins, blockDescription: item.priceBlockDescription)
        self.coinsView.isHidden = item.coins == nil && item.membershipCoins == nil
        self.exclusiveTagView.isHidden = !item.isMembershipOnly
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.shadowView)
        self.shadowView.addHeightConstraint(88)
        self.addBoundsConstraintsTo(subView: self.shadowView, leading: 25, trailing: -25, top: nil, bottom: 0)
        // back
        self.addSubview(self.backView)
        self.addFullBoundsConstraintsTo(subView: self.backView, constant: 0)
        // cover
        self.backView.addSubview(self.ivCover)
        self.backView.addBoundsConstraintsTo(subView: self.ivCover, leading: 10, trailing: -10, top: 10, bottom: nil)
//        self.ivCover.addHeightConstraint(100)
        // stack
        self.backView.addSubview(self.stackView)
        self.backView.addVerticalSpacingTo(subView1: self.ivCover, subView2: self.stackView, constant: 15)
        self.backView.addBoundsConstraintsTo(subView: self.stackView, leading: 0, trailing: 0, top: nil, bottom: 0)
        // title
        self.stackView.addArrangedSubview(self.lblTitle)
        self.lblTitle.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        // subtitle
        self.stackView.addArrangedSubview(self.lblSubtitle)
        self.lblSubtitle.addHeightConstraint(constant: 50, relatedBy: .equal, priority: 900)
        // coins
        self.stackView.addArrangedSubview(self.coinsView)
        self.coinsView.addHeightConstraint(constant: 50, relatedBy: .equal, priority: 900)
        // tag
        self.stackView.addArrangedSubview(self.exclusiveTagView)
        self.exclusiveTagView.addHeightConstraint(constant: 33, relatedBy: .equal, priority: 999)
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














class StoreExclusiveTagView: UIView {
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 8.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 10)
        lbl.textColor = Theme.color(.PrimaryButtonText)
        lbl.text = "*VALOR EXCLUSIVO PARA MEMBROS SÓCIO TORCEDORES"
        return lbl
    }()
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = Theme.color(.PrimaryButtonBackground)
        self.addSubview(self.stackView)
        self.addCenterXAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.stackView.addArrangedSubview(self.lblTitle)
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







class StoreItemCoinsView: UIView {
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 14.0
        return vw
    }()
    // info 0
    private let stackView0:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 6.0
        return vw
    }()
    private let ivCoin0:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon_coin")
        return iv
    }()
    let lblTitle0:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.textColor = UIColor.white
        return lbl
    }()
    // info 1
    private let stackView1:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 6.0
        return vw
    }()
    private let ivCoin1:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon_coin")
        return iv
    }()
    private let lblTitle1:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.textColor = UIColor(hexString: "FAD716")
        return lbl
    }()
    // block
    private let lblBlock:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.textColor = UIColor(hexString: "FAD716")
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(coins0:Int?, coins1:Int?, blockDescription:String?, addMarker:Bool = false) {
        // info 0
        self.lblTitle0.text = coins0?.descriptionWithThousandsSeparator()
        self.stackView0.isHidden = coins0 == nil
        // info 1
        let txt = coins1?.descriptionWithThousandsSeparator() ?? ""
        self.lblTitle1.text = addMarker ? "\(txt)*" : txt
        self.stackView1.isHidden = coins1 == nil
        // block
        let block = blockDescription?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if block != "" {
            self.lblBlock.text = block
            self.lblBlock.isHidden = false
            self.stackView0.isHidden = true
            self.stackView1.isHidden = true
        } else {
            self.lblBlock.isHidden = true
        }
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.stackView)
        self.addCenterXAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.addCenterYAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.stackView.addArrangedSubview(self.lblBlock)
        self.stackView.addArrangedSubview(self.stackView0)
        self.stackView0.addArrangedSubview(self.ivCoin0)
        self.stackView0.addArrangedSubview(self.lblTitle0)
        self.stackView.addArrangedSubview(self.stackView1)
        self.stackView1.addArrangedSubview(self.ivCoin1)
        self.stackView1.addArrangedSubview(self.lblTitle1)
        
        let iconSize:CGFloat = 18.0
        self.ivCoin0.addWidthConstraint(iconSize)
        self.ivCoin0.addHeightConstraint(iconSize)
        self.ivCoin1.addWidthConstraint(iconSize)
        self.ivCoin1.addHeightConstraint(iconSize)
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
