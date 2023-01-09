//
// UserProfileDeleteAccountViewController.swift
// 
//
// Created by Roberto Oliveira on 17/03/22.
// Copyright © 2022 Sportheca. All rights reserved.
//


import UIKit

class UserProfileDeleteAccountViewController: BaseKeyboardViewController, UITextFieldDelegate {
    
    
    
    // MARK: - Properties
    private var isPasswordTextfieldHidden:Bool = true
    private var isAccountDeleted:Bool = false
    
    
    // MARK: - Objects
    private let blurView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let formContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private let formStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 15.0
        return vw
    }()
    private let ivIcon:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = Theme.color(.PrimaryAnchor)
        return iv
    }()
    private let lblTitle:RootLabel = {
        let lbl = RootLabel()
        lbl.spaceBetweenLines = 5.0
        lbl.topInset = 10.0
        lbl.bottomInset = 5.0
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 20)
        lbl.textColor = UIColor(hexString: "FFFFFF")
        return lbl
    }()
    private let lblMessage:RootLabel = {
        let lbl = RootLabel()
        lbl.spaceBetweenLines = 5.0
        lbl.topInset = 5.0
        lbl.bottomInset = 10.0
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Light, size: 15)
        lbl.textColor = UIColor.white
        return lbl
    }()
    private lazy var oldPasswordField:EditProfileField = {
        let vw = EditProfileField()
        vw.backgroundColor = UIColor.white
        vw.layer.borderColor = UIColor(hexString: "FFFFFF").cgColor
        vw.textfield.textColor = .black
        vw.textfield.placeholderColor = UIColor.black.withAlphaComponent(1.0)
        vw.textfield.isSecureTextEntry = true
        vw.textfield.placeholder = "SENHA ATUAL"
        vw.textfield.returnKeyType = .send
        vw.textfield.keyboardType = .emailAddress
        vw.textfield.autocapitalizationType = .none
        vw.textfield.delegate = self
        return vw
    }()
    private let actionsStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 10.0
        return vw
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = Theme.color(.PrimaryCardBackground)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("CANCELAR", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.layer.cornerRadius = 10.0
        btn.clipsToBounds = true
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        if let lbl = btn.titleLabel {
            lbl.textAlignment = .center
            lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
            btn.addBoundsConstraintsTo(subView: lbl, leading: 15, trailing: -15, top: 0, bottom: 0)
            lbl.adjustsFontSizeToFitWidth = true
            lbl.minimumScaleFactor = 0.7
        }
        btn.layer.cornerRadius = 10.0
        btn.clipsToBounds = true
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    
    
    
    // MARK: - Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.confirm()
        return true
    }
    
    @objc func close() {
        //ServerManager.shared.setTrack(trackEvent: EventTrack.ChangePassword.close, trackValue: nil)
        DispatchQueue.main.async {
            self.dismissAction()
        }
    }
    
    @objc func confirm() {
        if self.isAccountDeleted == true {
            // user account is already deleted. Just go back to splash
            DispatchQueue.main.async {
                UserDefaultsManager.shared.setLastUserEmail("")
                UIApplication.shared.forceLogout()
            }
            return
        }
        
        
        if self.isPasswordTextfieldHidden == true {
            // First interaction with confirm button, ask for password
            DispatchQueue.main.async {
                self.isPasswordTextfieldHidden = false
                self.oldPasswordField.alpha = 1.0
                self.oldPasswordField.bounceAnimation()
                self.ivIcon.image = UIImage(named: "icon_warning")?.withRenderingMode(.alwaysTemplate)
                self.lblTitle.text = "TEM CERTEZA QUE DESEJA EXCLUIR SUA CONTA?"
                self.lblMessage.text = "Ao excluir sua conta, todos os seus dados serão apagados definitivamente."
                self.btnConfirm.setTitle("SIM, QUERO EXCLUIR MINHA CONTA", for: .normal)
            }
            return
        }
        
        // Password is already asked, check and send request
        let oldPassword = self.oldPasswordField.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if oldPassword == "" {
            DispatchQueue.main.async {
                self.statusAlert(message: "Preencha a senha atual", style: .Negative)
                self.oldPasswordField.textfield.setPlaceholder(color: UIColor.red)
                self.oldPasswordField.bounceAnimation()
            }
            return
        }
        
        DispatchQueue.main.async {
            self.view.firstResponder?.resignFirstResponder()
            self.view.becomeFirstResponder()
            self.view.isUserInteractionEnabled = false
            self.btnConfirm.alpha = 0.5
        }
        ServerManager.shared.setDeleteAccountRequest(password: oldPassword, trackEvent: nil) { (success:Bool?, message:String?) in
            if success == true {
                DispatchQueue.main.async {
                    self.view.firstResponder?.resignFirstResponder()
                    self.view.becomeFirstResponder()
                    self.view.isUserInteractionEnabled = true
                    self.isAccountDeleted = true
                    self.ivIcon.image = UIImage(named: "icon_trash")?.withRenderingMode(.alwaysTemplate)
                    self.lblTitle.text = message?.uppercased() ?? "CONTA EXCLUÍDA\nCOM SUCESSO!"
                    self.lblMessage.alpha = 0.0
                    self.oldPasswordField.alpha = 0.0
                    self.btnConfirm.alpha = 1.0
                    self.btnConfirm.setTitle("SAIR", for: .normal)
                    self.btnClose.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.view.firstResponder?.resignFirstResponder()
                    self.view.becomeFirstResponder()
                    self.view.isUserInteractionEnabled = true
                    self.btnConfirm.alpha = 1.0
                    self.basicAlert(message: message ?? "Erro ao enviar solicitação", handler: nil)
                }
            }
        }
        
    }
    
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.ivIcon.image = UIImage(named: "icon_warning")?.withRenderingMode(.alwaysTemplate)
        self.lblTitle.text = "EXCLUIR CONTA"
        self.lblMessage.text = "Ao excluir sua conta, todos os seus dados serão apagados definitivamente.\nDeseja prosseguir?"
        self.btnConfirm.setTitle("PROSSEGUIR", for: .normal)
    }
    
    
    
    // MARK: - Super Methods
    override func prepareElements() {
            self.verticalConstraintMultipliers = (keyboardVisible: 1.1, keyboardHidden: 1.0)
            super.prepareElements()
            self.contentContainerView.addWidthConstraint(310)
            self.scrollView.addCenterYAlignmentConstraintTo(subView: self.contentContainerView, relatedBy: .equal, constant: 0, priority: 500)
            // Background
            self.view.backgroundColor = UIColor.clear
            self.view.insertSubview(self.blurView, at: 0)
            self.view.addFullBoundsConstraintsTo(subView: self.blurView, constant: 0)
            // Close
    //        self.view.addSubview(self.btnClose)
    //        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 15)
    //        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 15)
            // Stack
            let padding:CGFloat = 40.0
            self.contentContainerView.addSubview(self.formContainerView)
            self.contentContainerView.addFullBoundsConstraintsTo(subView: self.formContainerView, constant: 0)
            self.formContainerView.addSubview(self.formStackView)
            self.formContainerView.addBoundsConstraintsTo(subView: self.formStackView, leading: padding, trailing: -padding, top: 0, bottom: 0)
            // Icon
            self.view.addSubview(self.ivIcon)
            self.view.addCenterXAlignmentConstraintTo(subView: self.ivIcon, constant: 0)
            self.view.addVerticalSpacingTo(subView1: self.ivIcon, subView2: self.formStackView, constant: 35)
            self.ivIcon.addSquareSizeConstraint(150)
            self.formStackView.addArrangedSubview(self.lblTitle)
            self.formStackView.addArrangedSubview(self.lblMessage)
            // Input
            self.formStackView.addArrangedSubview(self.oldPasswordField)
            self.oldPasswordField.addHeightConstraint(45.0)
            self.oldPasswordField.alpha = 0
            // Confirm
            self.view.addSubview(self.actionsStackView)
            self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.actionsStackView, constant: -20)
            self.view.addBoundsConstraintsTo(subView: self.actionsStackView, leading: padding, trailing: -padding, top: nil, bottom: nil)
            self.actionsStackView.addArrangedSubview(self.btnConfirm)
            self.actionsStackView.addArrangedSubview(self.btnClose)
            self.btnConfirm.addHeightConstraint(50)
            self.btnClose.addHeightConstraint(50)
    }
    
    override var canBecomeFirstResponder: Bool {return true}
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.oldPasswordField.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        (textField as? CustomTextField)?.placeholderColor = UIColor.black.withAlphaComponent(0.75)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.oldPasswordField.backgroundColor = UIColor.white.withAlphaComponent(1.0)
    }
    
    
}





