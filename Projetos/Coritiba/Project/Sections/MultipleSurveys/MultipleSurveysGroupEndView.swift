//
//  MultipleSurveysGroupEndView.swift
//  
//
//  Created by Roberto Oliveira on 06/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class MultipleSurveysGroupEndView: UIView {
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 25.0
        return vw
    }()
    private let ivIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblMessage:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 14)
        return lbl
    }()
    
    
    // MARK: - Methods
    func updateContent(iconName:String, message:String) {
        self.ivIcon.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        self.lblMessage.text = message
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.stackView)
        self.addCenterYAlignmentConstraintTo(subView: self.ivIcon, constant: 0)
        self.addBoundsConstraintsTo(subView: self.stackView, leading: 35, trailing: -35, top: nil, bottom: nil)
        self.stackView.addArrangedSubview(self.ivIcon)
        self.ivIcon.addHeightConstraint(110)
        self.stackView.addArrangedSubview(self.lblMessage)
        
        self.ivIcon.tintColor = Theme.color(.PrimaryCardElements)
        self.lblMessage.textColor = Theme.color(.PrimaryCardElements)
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

