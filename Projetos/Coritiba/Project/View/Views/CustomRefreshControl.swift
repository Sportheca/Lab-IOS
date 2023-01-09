//
//  CustomRefreshControl.swift
//
//
//  Created by Roberto Oliveira on 31/10/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class CustomRefreshControl: UIRefreshControl {
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.tintColor = Theme.color(.PrimaryAnchor)
        self.clipsToBounds = true
    }
    
    override init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}

