//
//  PlaceholderTextView.swift
//
//
//  Created by Roberto Oliveira on 23/06/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView, UITextViewDelegate {
    
    let lblPlaceholder:UITextView = {
        let lbl = UITextView()
        lbl.textColor = Theme.color(.SurveyOptionText).withAlphaComponent(0.5)
        lbl.backgroundColor = UIColor.clear
        return lbl
    }()
    
    func textViewDidChange(_ textView: UITextView) {
        self.lblPlaceholder.isHidden = self.text != ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblPlaceholder.frame = self.bounds
    }
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        self.addDefaultAccessory()
        self.textColor = Theme.color(.SurveyOptionText)
        self.delegate = self
        // Placeholder
        self.addSubview(self.lblPlaceholder)
        self.lblPlaceholder.isUserInteractionEnabled = false
        // Fonts
        let customFont = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        self.font = customFont
        self.lblPlaceholder.font = customFont
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
