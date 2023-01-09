//
//  TransparentGradientView.swift
//  
//
//  Created by Roberto Oliveira on 03/10/2017.
//  Copyright © 2017 SportsMatch. All rights reserved.
//

import UIKit

struct GradientReference {
    var location:NSNumber
    var transparent:Bool
}

class TransparentGradientView: UIView {
    
    // MARK: - Properties
    private let gradientLayer = CAGradientLayer()
    private var gradientLocations:[NSNumber] = [0.0, 1.0]
    private var gradientColors:[CGColor] = [UIColor.clear.cgColor, UIColor.black.cgColor]
    private var gradientStartPoint:CGPoint = CGPoint(x: 0, y: 0)
    private var gradientEndPoint:CGPoint = CGPoint(x: 1.0, y: 1.0)
    
    // MARK: - Methods
    func updateGradient(references: [GradientReference]) {
        self.gradientLocations.removeAll()
        self.gradientColors.removeAll()
        for ref in references {
            self.gradientLocations.append(ref.location)
            self.gradientColors.append(ref.transparent ? UIColor.clear.cgColor : UIColor.black.cgColor)
        }
    }
    
    func updateGradient(colors:[CGColor], locations:[NSNumber]) {
        self.gradientColors = colors
        self.gradientLocations = locations
    }
    
    func updateGradient(start:CGPoint, end:CGPoint) {
        self.gradientStartPoint = start
        self.gradientEndPoint = end
    }
    
    // MARK: - Super Methods
    override func layoutSubviews() {
        self.gradientLayer.frame = self.bounds
        self.gradientLayer.colors = self.gradientColors
        self.gradientLayer.startPoint = self.gradientStartPoint
        self.gradientLayer.endPoint = self.gradientEndPoint
        self.gradientLayer.locations = self.gradientLocations
        self.layer.mask = self.gradientLayer
    }
}











