//
//  StatusAlert.swift
//
//
//  Created by Roberto Oliveira on 07/06/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

extension UIViewController {
    func statusAlert(message: String, style: StatusAlertStyle) {
        let statusView = StatusAlertView(message: message, style: style)
        statusView.animateDown()
    }
}

enum StatusAlertStyle:Int {
    case Negative = 0
    case Positive = 1
    case Message = 2
    case Warning = 3
}


class StatusAlertView: UIView {
    
    // MARK: - Properties
    private var heightConstraint:NSLayoutConstraint = NSLayoutConstraint()
    
    
    
    // MARK: - Options
    private var message:String = ""
    private var backColor:UIColor = UIColor.cyan
    private var textColor:UIColor = UIColor.white
    private let animationTime:Double = 0.3
    
    
    
    // MARK: - Objects
    private lazy var lblMessage:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular)
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = self.textColor
        lbl.text = self.message
        return lbl
    }()
    
    
    
    // MARK: - Methods
    private func prepareElements() {
        self.backgroundColor = self.backColor
        self.addSubview(self.lblMessage)
        self.lblMessage.addHeightConstraint(constant: 20, relatedBy: .equal, priority: 750)
        self.addBoundsConstraintsTo(subView: self.lblMessage, leading: 10, trailing: -10, top: nil, bottom: -5)
        
        guard let vc = UIApplication.topViewController() else {return}
        vc.view.addSubview(self)
        vc.view.addBoundsConstraintsTo(subView: self, leading: 0, trailing: 0, top: 0, bottom: nil)
//        let titleConstraint = NSLayoutConstraint(item: self.lblMessage, attribute: .top, relatedBy: .equal, toItem: vc.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
//        titleConstraint.priority = UILayoutPriority(500)
//        vc.view.addConstraint(titleConstraint)
        vc.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.lblMessage, constant: 0, priority: 500, relatedBy: .equal)
        
        self.heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)
        self.heightConstraint.priority = UILayoutPriority(900)
        self.heightConstraint.isActive = true
        vc.view.addConstraint(self.heightConstraint)
        vc.view.layoutIfNeeded()
    }
    
    func animateDown() {
        DispatchQueue.main.async {
            self.heightConstraint.isActive = false
            UIView.animate(withDuration: self.animationTime, animations: {
                UIApplication.topViewController()?.view.layoutIfNeeded()
            }, completion: nil)
        }
        _ = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.animateUp), userInfo: nil, repeats: false)
    }
    
    @objc func animateUp() {
        DispatchQueue.main.async {
            self.heightConstraint.isActive = true
            UIView.animate(withDuration: self.animationTime, animations: {
                UIApplication.topViewController()?.view.layoutIfNeeded()
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        }
    }
    
    // MARK: - Init Methods
    init(message:String, style:StatusAlertStyle) {
        super.init(frame: CGRect.zero)
        switch style {
        case .Positive:
            self.backColor = UIColor(R: 0, G: 150, B: 0)
            self.textColor = UIColor.white
            break
            
        case .Negative:
            self.backColor = Theme.systemDestructiveColor
            self.textColor = UIColor.white
            break
            
        case .Message:
            self.backColor = UIColor.blue
            self.textColor = UIColor.white
            break
            
        case .Warning:
            self.backColor = UIColor.yellow
            self.textColor = UIColor.black
        }
        
        self.message = message
        self.prepareElements()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
    
}


