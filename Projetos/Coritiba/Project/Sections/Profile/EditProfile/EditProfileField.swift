//
//  EditProfileField.swift
//
//
//  Created by Roberto Oliveira on 23/08/18.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit

class EditProfileField: UIView {
    
    // MARK: - Objects
    let textfield:CustomTextField = {
        let txf = CustomTextField()
        txf.textColor = Theme.color(.PrimaryText)
        txf.placeholderColor = Theme.color(.MutedText)
        txf.keyboardAppearance = .dark
        return txf
    }()
    
    
    
    
    
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Theme.color(.PrimaryText).cgColor
        // Textfield
        self.addSubview(self.textfield)
        self.addBoundsConstraintsTo(subView: self.textfield, leading: 10, trailing: -10, top: nil, bottom: nil)
        self.addCenterYAlignmentConstraintTo(subView: self.textfield, constant: 0)
        self.textfield.addDefaultAccessory(delegate: nil, autoResign: true)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
