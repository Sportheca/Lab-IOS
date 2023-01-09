//
//  PrimaryButton.swift
//
//
//  Created by Roberto Oliveira on 06/08/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class PrimaryButton: CustomButton {
    
    init(title:String?) {
        super.init(frame: CGRect.zero)
        self.adjustsAlphaWhenHighlighted = false
        self.highlightedScale = 0.95
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        self.backgroundColor = Theme.color(.PrimaryButtonBackground)
        self.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        self.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 12)
        self.setTitle(title, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
