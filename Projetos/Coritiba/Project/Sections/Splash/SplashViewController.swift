//
//  SplashViewController.swift
//
//
//  Created by Roberto Oliveira on 28/08/17.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit
import UserNotifications

extension UIViewController {
    func presentHome() {
        guard let _ = ServerManager.shared.user else {
            DispatchQueue.main.async {
                let vc = SignUpViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            return
        }
        
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) in
            if settings.authorizationStatus == .notDetermined {
                DispatchQueue.main.async {
                    let vc = RequestNotificationsViewController()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    let vc = HomeTabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .coverVertical
                    self.present(vc, animated: true, completion: nil)
                }
            }
        })
    }
}

class SplashViewController: UIViewController, MaintenanceViewControllerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.statusBarStyle()
    }
    
    // MARK: - Properties
    private var isAnimationCompleted:Bool = false
    private var versionStatus:VersionStatus?
    private var versionMessage:String?
    private var loading = false
    private let logoSize:CGFloat = 220.0
    
    
    // MARK: - Objects
    private var logoWidthConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private let ivBackground:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "splash_background")
        return iv
    }()
    private let fadeView:TransparentGradientView = {
        let vw = TransparentGradientView()
        vw.backgroundColor = UIColor.black
        vw.updateGradient(start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1.0))
        vw.updateGradient(references: [
            GradientReference(location:0, transparent: true),
            GradientReference(location:1.0, transparent: false)
            ])
        return vw
    }()
    private let adsView:AdsView = AdsView()
    private let ivLogo:UIImageView = {
        let iv = UIImageView()
        iv .contentMode = .scaleAspectFit
        iv.image = UIImage(named: "logo")
        return iv
    }()
    private let lblLoading:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        lbl.textColor = UIColor.white
        lbl.text = "Carregando..."
        return lbl
    }()
    private let sponsorsBackView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.black
        return vw
    }()
    private let ivSponsors:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "sponsors")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private lazy var splashVideo:LocalVideoView = {
        let vw = LocalVideoView()
        vw.delegate = self
        return vw
    }()
    
    
    
    // MARK: - Methods
    private func reset() {
        DispatchQueue.main.async {
            self.lblLoading.alpha = 0
            self.ivLogo.alpha = 1.0
            self.logoWidthConstraint.constant = self.logoSize
            self.view.layoutIfNeeded()
        }
        self.versionMessage = nil
        self.versionStatus = nil
    }
    
    private func resetAndCheckVersion(trackEvent: Int?) {
        self.reset()
        self.checkVersionStatus(trackEvent: trackEvent)
        _ = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(showLoadingLabel), userInfo: nil, repeats: false)
    }
    @objc func showLoadingLabel() {
        if self.loading == true {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.75, animations: {
                    self.lblLoading.alpha = 1.0
                })
            }
        }
    }
    
    private func checkVersionStatus(trackEvent:Int?) {
        self.versionStatus = nil
        self.loading = true
        ServerManager.shared.getVersion(trackEvent: trackEvent, trackValue: nil) { (status:VersionStatus?, message:String?) in
            self.loading = false
            self.versionStatus = status
            self.versionMessage = message
            self.handleVersionResult()
        }
    }
    
    
    
    private func handleVersionResult() {
        // Animate Logo and Handle result
        guard self.versionStatus != nil && self.isAnimationCompleted else {return}
        if self.versionStatus == .Updated {
            self.presentHome()
            return
        } else {
            if self.versionStatus == .Failed {
                DispatchQueue.main.async {
                    self.basicAlert(message: self.versionMessage ?? "Falha ao carregar", btnTitle: "Tentar Novamente") { (_) in
                        self.failedTryAgain()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.presentMaintenanceViewController(status: self.versionStatus ?? .Locked, message: self.versionMessage)
                }
            }
        }
    }
    
    
    
    
    
    
    // MARK: - Terms & Agreements Delegate
    func termsViewControllerDidAcceptTerm() {
        DispatchQueue.main.async {
            self.presentHome()
        }
    }
    
    func termsViewControllerDidCancel() {
        DispatchQueue.main.async {
            self.resetAndCheckVersion(trackEvent: nil)
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - Maintenance Delegate
    private func failedTryAgain() {
        self.resetAndCheckVersion(trackEvent: EventTrack.Splash.tryAgain)
    }
    
    func tryAgain() {
        self.resetAndCheckVersion(trackEvent: EventTrack.Maintenance.tryAgain)
    }
    
    func skipVersion() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Maintenance.skip, trackValue: nil)
        self.presentHome()
    }
    
    @objc func logout() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if ProjectManager.shared.apiPath == "/api/" {
            ProjectManager.shared.apiPath = String.stringValue(from: UserDefaults.standard.object(forKey: "apiPath")) ?? ProjectManager.shared.apiPath
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.logout), name: Notification.Name(NotificationName.ForceLogout.rawValue), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async() {
            self.splashVideo.playLocalVideo(named: "splash")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let lastUser = DataBaseManager.shared.user(for: UserDefaultsManager.shared.lastUserId() ?? "") {
            ServerManager.shared.user = lastUser
            ServerManager.shared.updateUserAPNS()
        }
        self.isAnimationCompleted = false
        self.resetAndCheckVersion(trackEvent: nil)
        UIView.animate(withDuration: 2.0) {
            self.fadeView.alpha = 1
        }
        var images:[UIImage] = []
        // 90 - 230
        for i in 0...280 {
            if let img = UIImage(named: "animation_splash_\(i)") {
                images.append(img)
            }
        }
        self.ivBackground.animationRepeatCount = 1
        self.ivBackground.animationImages = images
        self.ivBackground.animationDuration = 5.0
        self.ivBackground.startAnimating()
        self.ivBackground.image = images.last
        DispatchQueue.main.asyncAfter(deadline: .now()+4.5) {
            self.isAnimationCompleted = true
            self.handleVersionResult()
        }
        
    }
    
    
    
    
    
    
    
    // MARK: - Init methods
    private func prepareElements() {
        self.view.backgroundColor = UIColor(hexString: "012A27")
        // Background
        self.view.addSubview(self.ivBackground)
        self.view.addBoundsConstraintsTo(subView: self.ivBackground, leading: 0, trailing: 0, top: 0, bottom: 0)
        // Fade
        if UIApplication.shared.currentDeviceType() == .iPhone {
            self.view.addSubview(self.fadeView)
            self.fadeView.alpha = 0
            self.fadeView.addHeightConstraint(UIScreen.main.bounds.width*0.5)
            self.view.addBoundsConstraintsTo(subView: self.fadeView, leading: 0, trailing: 0, top: nil, bottom: 0)
            self.fadeView.isHidden = true
        }
        // Logo
        self.view.addSubview(self.ivLogo)
        self.ivLogo.addHeightConstraint(self.logoSize)
        self.logoWidthConstraint =  NSLayoutConstraint(item: self.ivLogo, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.logoSize)
        self.view.addConstraint(self.logoWidthConstraint)
        self.view.addCenterYAlignmentConstraintTo(subView: self.ivLogo, constant: -42)
        self.view.addCenterXAlignmentConstraintTo(subView: self.ivLogo, constant: 0)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}


extension SplashViewController: LocalVideoViewDelegate {
    func localVideoView(localVideoView: LocalVideoView, didFinishPlayingVideo named: String) {
        DispatchQueue.main.async {
            self.isAnimationCompleted = true
            self.handleVersionResult()
        }
       
    }
    
    
}
