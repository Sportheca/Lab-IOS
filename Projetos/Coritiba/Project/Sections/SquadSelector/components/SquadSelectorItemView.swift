//
//  SquadSelectorItemView.swift
//
//
//  Created by Roberto Oliveira on 04/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol SquadSelectorItemViewDelegate:AnyObject {
    func squadSelectorItemView(squadSelectorItemView:SquadSelectorItemView, didSelectItem item:SquadSelectorItem?, atPosition position:Int)
}

class SquadSelectorItemView: UIView {
    
    // MARK: - Properties
    weak var delegate:SquadSelectorItemViewDelegate?
    private var currentPosition:Int?
    private var currentItem:SquadSelectorItem?
    
    // MARK: - Objects
    let btnIcon:CustomButton = {
        let btn = CustomButton()
        btn.layer.shadowOpacity = 0.25
        btn.layer.shadowRadius = 4.0
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.cornerRadius = 0
        btn.setTitleColor(Theme.color(.SecondaryCardBackground), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 10)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    private let titleBackView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 5.0
        return vw
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 2.0
        return vw
    }()
    private let separatorView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return vw
    }()
    private let lblTitle:InsetsLabel = {
        let lbl = InsetsLabel()
        lbl.topInset = 3
        lbl.bottomInset = 3
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        let fontSize:CGFloat = UIScreen.main.bounds.height <= 667 ? 9 : 10
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: fontSize)
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = UIColor.white
//        lbl.adjustsFontSizeToFitWidth = true
//        lbl.minimumScaleFactor = 0.8
        return lbl
    }()
    private let lblInfo:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        let fontSize:CGFloat = UIScreen.main.bounds.height <= 667 ? 8 : 10
        lbl.font = FontsManager.customFont(key: FontsManager.Apex.Bold, size: fontSize)
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = UIColor.white.withAlphaComponent(0.6)
        return lbl
    }()
    private lazy var btnAction:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(self.actionMethod), for: .touchUpInside)
        return btn
    }()
    @objc func actionMethod() {
        self.delegate?.squadSelectorItemView(squadSelectorItemView:self, didSelectItem: self.currentItem, atPosition: self.currentPosition ?? 0)
    }
    
    
    
    // MARK: - Methods
    func updateContent(position:Int, item:SquadSelectorItem?, isActionAllowed:Bool) {
        self.currentPosition = position
        self.currentItem = item
        guard let obj = item else {
            self.updateTitle("", info: nil)
            self.btnIcon.backgroundColor = UIColor.clear
            if isActionAllowed {
                self.btnIcon.setTitle(nil, for: .normal)
                self.btnIcon.setImage(UIImage(named: "adicionar_campo")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.btnIcon.imageView?.tintColor = UIColor.yellow
                self.layer.shadowOpacity = 0.25
                self.layer.shadowRadius = 8.0
                self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
            } else {
                self.layer.shadowOpacity = 0.25
                self.layer.shadowRadius = 4.0
                self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
                self.btnIcon.setTitle(nil, for: .normal)
                self.btnIcon.setImage(nil, for: .normal)
            }
            return
        }
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.updateTitle(obj.title, info: obj.description)
        let imgUrl:String = obj.imageUrl?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.btnIcon.setServerImage(urlString: imgUrl)
        self.btnIcon.backgroundColor = UIColor.clear
        self.btnIcon.setTitle(nil, for: .normal)
        self.btnIcon.backgroundColor = UIColor.clear
    }
    
    private func updateTitle(_ title:String, info:String?) {
        self.lblTitle.text = title
        let alpha:CGFloat = title == "" ? 0.0 : 1.0
        self.lblTitle.alpha = alpha
        self.titleBackView.alpha = alpha
        self.lblInfo.text = info ?? ""
        self.lblInfo.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        let isInfoHidden:Bool = (info ?? "") == ""
        self.separatorView.isHidden = isInfoHidden
        self.lblInfo.isHidden = isInfoHidden
    }
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Button Icon
        self.addSubview(self.btnIcon)
        self.addBoundsConstraintsTo(subView: self.btnIcon, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.addConstraint(NSLayoutConstraint(item: self.btnIcon, attribute: .width, relatedBy: .equal, toItem: self.btnIcon, attribute: .height, multiplier: 0.8, constant: 0))
        // Title
        self.addSubview(self.titleBackView)
        self.addVerticalSpacingTo(subView1: self.btnIcon, subView2: self.titleBackView, constant: -3)
        self.addCenterXAlignmentConstraintTo(subView: self.titleBackView, constant: 0)
        self.addWidthRelatedConstraintTo(subView: self.titleBackView, reference: self.btnIcon, relatedBy: .lessThanOrEqual, multiplier: 1.0, constant: 20, priority: 999)
        // Button Action
        self.addSubview(self.btnAction)
        self.addFullBoundsConstraintsTo(subView: self.btnAction, constant: 0)
        self.titleBackView.addSubview(self.stackView)
        self.titleBackView.addBoundsConstraintsTo(subView: self.stackView, leading: 2, trailing: -2, top: 0, bottom: -0)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.separatorView)
        self.separatorView.addWidthConstraint(1)
        self.titleBackView.addBoundsConstraintsTo(subView: self.separatorView, leading: nil, trailing: nil, top: 2, bottom: -2)
        self.stackView.addArrangedSubview(self.lblInfo)
        
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
