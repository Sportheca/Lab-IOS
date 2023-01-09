//
//  RequestNotificationsViewController.swift
//
//
//  Created by Roberto Oliveira on 26/01/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit
import UserNotifications

class RequestNotificationsViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.statusBarStyle()
    }
    
    // MARK: - Objects
    private let ivBackground:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "splash_background")
        return iv
    }()
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear//.withAlphaComponent(0.7)
        return vw
    }()
    private var containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let ivLogo:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "logo")
        return iv
    }()
    private let lblDescription:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 17)
        lbl.textColor = Theme.color(.TextOverSplashImage)
        lbl.text = ProjectInfoManager.TextInfo.ativar_notificacoes.rawValue
        return lbl
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 18)
        btn.setTitle("Continuar", for: .normal)
        btn.layer.cornerRadius = 5
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.9
        btn.addTarget(self, action: #selector(self.confirmMethod), for: .touchUpInside)
        return btn
    }()
    @objc func confirmMethod() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.PushNotificationsPermission.confirm, trackValue: nil)
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            appDelegate.registerForPushNotifications(UIApplication.shared)
        }
    }
    @objc func didRegister() {
        DispatchQueue.main.async {
            let vc = HomeTabBarController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRegister), name: Notification.Name(NotificationName.DidRegisterForNotifications.rawValue), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Init methods
    private func prepareElements() {
        self.view.backgroundColor = Theme.color(.PrimaryBackground)
        //self.automaticallyAdjustsScrollViewInsets = false
        // Background
        self.view.addSubview(self.ivBackground)
        self.view.addFullBoundsConstraintsTo(subView: self.ivBackground, constant: 0)
        self.view.addSubview(self.backView)
        self.view.addFullBoundsConstraintsTo(subView: self.backView, constant: 0)
        // Container View
        self.view.addSubview(self.containerView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.containerView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.containerView, constant: 0)
        self.containerView.addWidthConstraint(260)
        self.containerView.addHeightConstraint(constant: UIScreen.main.bounds.size.height-100, relatedBy: .equal, priority: 750)
        self.containerView.addHeightConstraint(constant: 460, relatedBy: .greaterThanOrEqual, priority: 900)
        self.containerView.addHeightConstraint(constant: 600, relatedBy: .lessThanOrEqual, priority: 900)
        // Logo
        self.containerView.addSubview(self.ivLogo)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.ivLogo, constant: 0)
        self.containerView.addTopAlignmentConstraintTo(subView: self.ivLogo, constant: 10)
        self.ivLogo.addWidthConstraint(230)
        self.ivLogo.addHeightConstraint(150)
        // Description
        self.containerView.addSubview(self.lblDescription)
        self.containerView.addVerticalSpacingTo(subView1: self.ivLogo, subView2: self.lblDescription, constant: 20)
        self.containerView.addBoundsConstraintsTo(subView: self.lblDescription, leading: 0, trailing: 0, top: nil, bottom: nil)
        // Confirm
        self.containerView.addSubview(self.btnConfirm)
        self.containerView.addVerticalSpacingTo(subView1: self.lblDescription, subView2: self.btnConfirm, relatedBy: .greaterThanOrEqual, constant: 20, priority: 1000)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.btnConfirm, constant: 0)
        self.containerView.addBottomAlignmentConstraintTo(subView: self.btnConfirm, constant: -10)
        self.btnConfirm.addWidthConstraint(220)
        self.btnConfirm.addHeightConstraint(50)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}












