//
//  ContentLoadingView.swift
//
//
//  Created by Roberto Oliveira on 29/10/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class ContentLoadingView: UIView {
    
    
    // MARK: - Properties
    var color:UIColor = UIColor.clear {
        didSet {
            self.lblTitle.textColor = self.color
            self.btnAction.setTitleColor(self.color, for: .normal)
            self.btnAction.layer.borderColor = self.color.cgColor
            self.marker.backgroundColor = self.color
        }
    }
    
    
    
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Medium, size: 15)
        lbl.text = "Carregando"
        return lbl
    }()
    let btnAction:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Tentar Novamente", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Helvetica.Medium, size: 14)
        btn.layer.cornerRadius = 5.0
        btn.layer.borderWidth = 1.0
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.9
        return btn
    }()
    private let marker:UIView = {
        let vw = UIView()
        return vw
    }()
    
    
    
    // MARK: - Methods
    func startAnimating() {
        self.btnAction.isHidden = true
        self.lblTitle.text = "Carregando"
        self.marker.isHidden = false
        self.marker.frame = CGRect(x: (self.frame.width/2)-70, y: 25, width: 30, height: 1)
        UIView.animate(withDuration: 1.0, delay: 0, options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat, UIView.AnimationOptions.allowUserInteraction], animations: {
            self.marker.frame = CGRect(x: (self.frame.width/2)+40, y: 25, width: 30, height: 1)
        }, completion: nil)
        self.isHidden = false
    }
    
    func stopAnimating(hide:Bool = true) {
        self.isHidden = hide
        self.marker.isHidden = true
        self.marker.layer.removeAllAnimations()
    }
    
    func emptyResults(title:String = "Nenhum item encontrado") {
        self.btnAction.isHidden = false
        self.lblTitle.text = title
        self.stopAnimating(hide: false)
    }
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.isHidden = true
        self.addSubview(self.containerView)
        self.addFullBoundsConstraintsTo(subView: self.containerView, constant: 0)
        self.containerView.addHeightConstraint(60)
        self.containerView.addWidthConstraint(constant: 150, relatedBy: .greaterThanOrEqual, priority: 999)
        // Title
        self.containerView.addSubview(self.lblTitle)
        self.lblTitle.addHeightConstraint(25)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 0, trailing: 0, top: 0, bottom: nil)
        // Marker
        self.containerView.addSubview(self.marker)
        // Action
        self.containerView.addSubview(self.btnAction)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.btnAction, constant: 0)
        self.containerView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.btnAction, constant: 5)
        self.btnAction.addFullBoundsConstraintsTo(subView: self.btnAction.titleLabel!, constant: 5)
        self.btnAction.isHidden = true
        
        self.color = Theme.color(.MutedText)
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
