//
//  MaintenanceViewController.swift
//
//
//  Created by Roberto Oliveira on 25/10/2017.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentMaintenanceViewController(status:VersionStatus, message:String?) {
        let vc = MaintenanceViewController()
        vc.versionStatus = status
        vc.message = message
        vc.delegate = self as? MaintenanceViewControllerDelegate
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

enum VersionStatus:Int {
    case Updated = 0
    case UpdateRequired = 1
    case UpdateAvailable = 4
    case Locked = 2
    case Failed = 3
}

var global_shouldCheckVersionWhenBecomesActive:Bool = false

protocol MaintenanceViewControllerDelegate {
    func tryAgain()
    func skipVersion()
}

class MaintenanceViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.statusBarStyle()
    }
    
    // MARK: - Properties
    var delegate:MaintenanceViewControllerDelegate?
    var versionStatus:VersionStatus?
    var message:String? = nil
    
    
    
    // MARK: - Objects
    private let backView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear//.withAlphaComponent(0.7)
        return vw
    }()
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
    private let ivLogo:UIImageView = {
        let iv = UIImageView()
        iv .contentMode = .scaleAspectFit
        iv.image = UIImage(named: "logo")
        return iv
    }()
    private let lblMessage:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 16)
        lbl.textColor = Theme.color(.TextOverSplashImage)
        return lbl
    }()
    private lazy var btnAction:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 17)
        btn.layer.cornerRadius = 10.0
        btn.highlightedAlpha = 0.8
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.actionMethod), for: .touchUpInside)
        return btn
    }()
    @objc func actionMethod() {
        if self.versionStatus == .UpdateRequired || self.versionStatus == .UpdateAvailable {
            if let url = URL(string: ProjectManager.shared.itunesLink) {
                ServerManager.shared.setTrack(trackEvent: EventTrack.Maintenance.downloadNewVersion, trackValue: nil)
                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.delegate?.tryAgain()
                self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    private lazy var btnSkip:UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitleColor(Theme.color(.TextOverSplashImage), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Helvetica.Medium, size: 14)
        btn.setTitle("Agora Não", for: .normal)
        btn.addTarget(self, action: #selector(self.skipMethod), for: .touchUpInside)
        return btn
    }()
    @objc func skipMethod() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: {
                self.delegate?.skipVersion()
            })
        }
    }
    private let lblVersion:UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        lbl.textColor = Theme.color(.TextOverSplashImage)
        return lbl
    }()
    
    
    
    // MARK: - Methods
    private func updateInterface() {
        if self.versionStatus == .UpdateRequired || self.versionStatus == .UpdateAvailable {
            self.lblMessage.text = self.message ?? "Nova versão disponível!\n\nPor favor, atualize para continuar..."
            self.btnAction.setTitle("Clique aqui para atualizar!", for: .normal)
            self.btnSkip.isHidden = (self.versionStatus != .UpdateAvailable)
        } else {
            self.lblMessage.text = self.message ?? "Servidores em manutenção\n\nPor favor, tente novamente mais tarde"
            self.btnAction.setTitle("Tentar Novamente", for: .normal)
            self.btnSkip.isHidden = true
        }
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else {return}
        self.lblVersion.text = "Versão: \(version)"
    }
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateInterface()
    }
    
    
    
    // MARK: - Init methods
    private func prepareElements() {
        self.view.backgroundColor = Theme.color(.PrimaryBackground)
        // Background
        self.view.addSubview(self.ivBackground)
        self.view.addFullBoundsConstraintsTo(subView: self.ivBackground, constant: 0)
        self.view.addSubview(self.backView)
        self.view.addFullBoundsConstraintsTo(subView: self.backView, constant: 0)
//        if UIApplication.shared.currentDeviceType() == .iPhone {
//            self.view.addSubview(self.fadeView)
//            self.fadeView.addHeightConstraint(UIScreen.main.bounds.width*0.7)
//            self.view.addBoundsConstraintsTo(subView: self.fadeView, leading: 0, trailing: 0, top: nil, bottom: 0)
//        }
        // Detail
        self.view.addSubview(self.lblVersion)
        self.view.addCenterXAlignmentConstraintTo(subView: self.lblVersion, constant: 0)
        self.view.addBottomAlignmentConstraintTo(subView: self.lblVersion, constant: -30)
        self.lblVersion.addHeightConstraint(20)
        // Skip
        self.view.addSubview(self.btnSkip)
        self.view.addVerticalSpacingTo(subView1: self.btnSkip, subView2: self.lblVersion, constant: 5)
        self.view.addCenterXAlignmentConstraintTo(subView: self.btnSkip, constant: 0)
        self.btnSkip.addHeightConstraint(50)
        // Action
        self.view.addSubview(self.btnAction)
        self.view.addCenterXAlignmentConstraintTo(subView: self.btnAction, constant: 0)
        self.view.addVerticalSpacingTo(subView1: self.btnAction, subView2: self.btnSkip, constant: 5)
        self.btnAction.addHeightConstraint(50)
        self.btnAction.addWidthConstraint(240)
        // Logo
        self.view.addSubview(self.ivLogo)
        self.view.addCenterXAlignmentConstraintTo(subView: self.ivLogo, constant: 0)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.ivLogo, constant: 40)
        self.ivLogo.addWidthConstraint(120)
        self.ivLogo.addHeightConstraint(120)
        // Message
        self.view.addSubview(self.lblMessage)
        self.view.addCenterYAlignmentConstraintTo(subView: self.lblMessage, constant: 0)
        self.view.addLeadingAlignmentConstraintTo(subView: self.lblMessage, relatedBy: .greaterThanOrEqual, constant: 20, priority: 999)
        self.view.addTrailingAlignmentConstraintTo(subView: self.lblMessage, relatedBy: .lessThanOrEqual, constant: -20, priority: 999)
        self.view.addCenterXAlignmentConstraintTo(subView: self.lblMessage, constant: 0)
        self.lblMessage.addWidthConstraint(constant: 450, relatedBy: .lessThanOrEqual, priority: 999)
        self.view.addVerticalSpacingTo(subView1: self.lblMessage, subView2: self.btnAction, relatedBy: .equal, constant: 15, priority: 999)
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







