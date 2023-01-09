//
//  OverlayImageView.swift
//  
//
//  Created by Roberto Oliveira on 24/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class OverlayImageView: ServerImageView {
    
    // MARK: - Objects
    private let overlayView:UIView = UIView()
    
    // MARK: - Methods
    func updateColor(_ color: UIColor) {
        self.backgroundColor = color
        self.overlayView.backgroundColor = color.withAlphaComponent(0.9)
    }
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        // Overlay
        self.addSubview(self.overlayView)
        self.addFullBoundsConstraintsTo(subView: self.overlayView, constant: 0)
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
