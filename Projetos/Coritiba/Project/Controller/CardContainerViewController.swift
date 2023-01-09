//
//  CardContainerViewController.swift
//  
//
//  Created by Roberto Oliveira on 05/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class CardContainerViewController: BaseViewController {
    
    // MARK: - Properties
    var childVc:UIViewController?
    let cardView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 25.0
        return vw
    }()
    var closeTrackEvent:Int?
    var closeTrackValue:Int?
    
    
    
    // MARK: - Objects
    private let headerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryBackground)
        return vw
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryText), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.dismissAction), for: .touchUpInside)
        return btn
    }()
    
    override func dismissAction() {
        ServerManager.shared.setTrack(trackEvent: self.closeTrackEvent, trackValue: self.closeTrackValue)
        super.dismissAction()
    }
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.view.addSubview(self.cardView)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.cardView, constant: 20)
//        self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.cardView, constant: -20)
        self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.cardView, constant: -20, priority: 998, relatedBy: .equal)
        self.view.addBoundsConstraintsTo(subView: self.cardView, leading: 20, trailing: -20, top: nil, bottom: nil)
    }
    
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        guard let vc = self.childVc else {return}
        vc.extendedLayoutIncludesOpaqueBars = true
        vc.edgesForExtendedLayout = [.all]
        let controller = UINavigationController(rootViewController: vc)
        controller.navigationBar.isHidden = true
        controller.willMove(toParent: self)
        self.cardView.addSubview(controller.view)
        self.cardView.addBoundsConstraintsTo(subView: controller.view, leading: 0, trailing: 0, top: 0, bottom: 0)
        self.addChild(controller)
        controller.didMove(toParent: self)
        
        vc.view.addSubview(self.btnClose)
        vc.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        vc.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 20)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.statusBarStyle()
    }
    
}


