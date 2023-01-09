//
//  GradientNavigationBar.swift
//  
//
//  Created by Roberto Oliveira on 26/06/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

class CustomGradientView: UIView {
    
    // MARK: - Options
    var color1:UIColor = UIColor.white
    var color2:UIColor = UIColor.white
    var point1:CGPoint = CGPoint(x: 0, y: 0)
    var point2:CGPoint = CGPoint(x: 1, y: 1)
    var position1:CGFloat = 0.2
    var position2:CGFloat = 1.0
    
    // MARK: - Layout Methods
    func setGradientColors(color1:UIColor, color2:UIColor) {
        self.color1 = color1
        self.color2 = color2
        self.layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layer = self.layer as? CAGradientLayer else {return}
        layer.colors = [self.color1.cgColor, self.color2.cgColor]
        layer.locations = [(self.position1 as NSNumber), (self.position2 as NSNumber)]
        layer.startPoint = self.point1
        layer.endPoint = self.point2
    }
    
    private func setupView() {
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        guard let layer = self.layer as? CAGradientLayer else {return}
        layer.colors = [self.color1.cgColor, self.color2.cgColor]
        layer.locations = [(self.position1 as NSNumber), (self.position2 as NSNumber)]
        layer.startPoint = self.point1
        layer.endPoint = self.point2
        layer.frame = self.bounds
    }
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
}
