//
//  RatingContentView.swift
//
//
//  Created by Roberto Oliveira on 22/06/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol RatingContentViewDelegate:AnyObject {
    func ratingContentView(ratingContentView:RatingContentView, didConfirmWithOption option:RatingOption, andMessage message:String)
}

class RatingContentView: UIView {
    
    // MARK: - Properties
    weak var delegate:RatingContentViewDelegate?
    var currentItem:RatingDetails?
    private var selectedOption:RatingOption?
    private var starsButtons:[CustomButton] = []
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 30.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    private let starsView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 5.0
        return vw
    }()
    private let lblMessage:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 14)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        iv.clipsToBounds = true
        return iv
    }()
    private let txvMessage:PlaceholderTextView = {
        let vw = PlaceholderTextView()
        vw.lblPlaceholder.text = "Escreva sua mensagem"
        vw.layer.cornerRadius = 10.0
        vw.layer.borderWidth = 1.0
        vw.layer.borderColor = Theme.color(.SurveyOptionBackground).cgColor
        vw.backgroundColor = Theme.color(.SurveyOptionBackground)
        return vw
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15.0
        btn.adjustsAlphaWhenHighlighted = false
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    // MARK: - Methods
    @objc func confirm() {
        guard let option = self.selectedOption else {return}
        let message:String = option.showTextInput ? self.txvMessage.text : ""
        self.delegate?.ratingContentView(ratingContentView: self, didConfirmWithOption: option, andMessage: message)
    }
    
    @objc func starButtonMethod(_ sender: UIButton) {
        DispatchQueue.main.async {
            guard let item = self.currentItem else {return}
            for option in item.options {
                if option.id == sender.tag {
                    self.selectedOption = option
                }
            }
            self.updateSelectedOption()
        }
    }
    
    func updateContent(item:RatingDetails) {
        self.currentItem = item
        self.selectedOption = item.emptyOption
        for sub in self.starsView.arrangedSubviews {
            sub.removeFromSuperview()
        }
        self.starsButtons.removeAll()
        for option in item.options {
            let btn = self.startButton(index: option.id)
            self.starsView.addArrangedSubview(btn)
            btn.addWidthConstraint(38)
            btn.addHeightConstraint(38)
            self.starsButtons.append(btn)
        }
        self.updateSelectedOption()
    }
    
    private func startButton(index:Int) -> CustomButton {
        let btn = CustomButton()
        btn.tag = index
        btn.setImage(UIImage(named: "icon_rating_star")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn.adjustsImageWhenHighlighted = false
        btn.adjustsAlphaWhenHighlighted = false
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.starButtonMethod(_:)), for: .touchUpInside)
        return btn
    }
    
    private func updateSelectedOption() {
        guard let item = self.selectedOption else {return}
        let actionTitle = item.showTextInput ? "ENVIAR" : "AVALIAR AGORA"
        self.btnConfirm.setTitle(actionTitle, for: .normal)
        self.lblTitle.text = item.title
        for btn in self.starsButtons {
            let color = btn.tag <= item.id ? UIColor(R: 255, G: 157, B: 67) : UIColor(R: 170, G: 170, B: 170)
            btn.tintColor = color
        }
        self.lblMessage.text = item.message
        if let img = item.imageUrl {
            self.ivCover.setServerImage(urlString: img)
            self.ivCover.isHidden = false
        } else {
            self.ivCover.isHidden = true
        }
        self.txvMessage.isHidden = !item.showTextInput
        self.btnConfirm.isHidden = item.id == 0
    }
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.stackView)
        self.addCenterXAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.addTopAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.addBottomAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.stackView.addWidthConstraint(320)
        // elements
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.starsView)
        self.stackView.addArrangedSubview(self.lblMessage)
        self.stackView.addArrangedSubview(self.txvMessage)
        self.txvMessage.addWidthConstraint(295)
        self.txvMessage.addHeightConstraint(170)
        self.stackView.addArrangedSubview(self.ivCover)
        self.ivCover.addHeightConstraint(120)
        self.stackView.addArrangedSubview(self.btnConfirm)
        self.btnConfirm.addWidthConstraint(180)
        self.btnConfirm.addHeightConstraint(45)
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
