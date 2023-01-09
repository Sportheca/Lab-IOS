//
//  UserProfileChangePasswordViewController.swift
//  
//
//  Created by Roberto Oliveira on 2/17/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class UserProfileChangePasswordViewController: BaseKeyboardViewController, UITextViewDelegate, UITextFieldDelegate {
    
    // MARK: - Objects
    private let blurView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    lazy var btnClose:UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.setTitle("Voltar", for: .normal)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 5.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 16)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.text = "ALTERAR SENHA"
        return lbl
    }()
    private let formContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardBackground)
        vw.layer.cornerRadius = 15.0
        vw.layer.shadowOpacity = 0.25
        vw.layer.shadowRadius = 5.0
        vw.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        return vw
    }()
    private let loadingView:ContentLoadingView = ContentLoadingView()
    private let formStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 10.0
        return vw
    }()
    private lazy var oldPasswordField:EditProfileField = {
//        let field = FormField(inputType: .Password, placeHolder: "Senha Atual", returnKey: .next)
//        field.delegate = self
        let vw = EditProfileField()
        vw.layer.borderColor = Theme.color(.AlternativeCardElements).cgColor
        vw.textfield.textColor = Theme.color(.AlternativeCardElements)
        vw.textfield.placeholderColor = Theme.color(.AlternativeCardElements).withAlphaComponent(0.5)
        vw.textfield.isSecureTextEntry = true
        vw.textfield.placeholder = "Senha Atual"
        vw.textfield.returnKeyType = .next
        vw.textfield.keyboardType = .emailAddress
        vw.textfield.autocapitalizationType = .none
        vw.textfield.delegate = self
        return vw
    }()
    private lazy var newPasswordField:EditProfileField = {
//        let field = FormField(inputType: .Password, placeHolder: "Nova Senha", returnKey: .next)
//        field.delegate = self
        let vw = EditProfileField()
        vw.layer.borderColor = Theme.color(.AlternativeCardElements).cgColor
        vw.textfield.textColor = Theme.color(.AlternativeCardElements)
        vw.textfield.placeholderColor = Theme.color(.AlternativeCardElements).withAlphaComponent(0.5)
        vw.textfield.isSecureTextEntry = true
        vw.textfield.placeholder = "Nova Senha"
        vw.textfield.returnKeyType = .next
        vw.textfield.keyboardType = .emailAddress
        vw.textfield.autocapitalizationType = .none
        vw.textfield.delegate = self
        return vw
    }()
    private lazy var confirmPasswordField:EditProfileField = {
//        let field = FormField(inputType: .Password, placeHolder: "Confirmar Senha", returnKey: .send)
//        field.delegate = self
        let vw = EditProfileField()
        vw.layer.borderColor = Theme.color(.AlternativeCardElements).cgColor
        vw.textfield.textColor = Theme.color(.AlternativeCardElements)
        vw.textfield.placeholderColor = Theme.color(.AlternativeCardElements).withAlphaComponent(0.5)
        vw.textfield.isSecureTextEntry = true
        vw.textfield.placeholder = "Confirmar Nova Senha"
        vw.textfield.returnKeyType = .send
        vw.textfield.keyboardType = .emailAddress
        vw.textfield.autocapitalizationType = .none
        vw.textfield.delegate = self
        return vw
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.setTitle("SALVAR", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.layer.cornerRadius = 10.0
        btn.clipsToBounds = true
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    
    
    
    // MARK: - Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.oldPasswordField.textfield:
            self.newPasswordField.textfield.becomeFirstResponder()
            return true
            
        case self.newPasswordField.textfield:
            self.confirmPasswordField.textfield.becomeFirstResponder()
            return true
            
        case self.confirmPasswordField.textfield:
            self.confirm()
            return true
            
        default: return true
        }
    }
    
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.ChangePassword.close, trackValue: nil)
        DispatchQueue.main.async {
            self.dismissAction()
        }
    }
    
    @objc func confirm() {
        //guard let user = ServerManager.shared.user else {return}
        
        var isValidData:Bool = true
        
        let oldPassword = self.oldPasswordField.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // New Password
        let password = self.newPasswordField.textfield.text ?? ""
        if password.contains(otherString: " ") {
            DispatchQueue.main.async {
                self.basicAlert(message: "A senha não pode conter espaços", handler: nil)
            }
            isValidData = false
            return
        }
        if password.count < 3 {
            DispatchQueue.main.async {
                self.basicAlert(message: "Senha muito curta", handler: nil)
            }
            isValidData = false
            return
        }
        
        // Confirm Password
        let confirmPassword = self.confirmPasswordField.textfield.text ?? ""
        if confirmPassword != password {
            DispatchQueue.main.async {
                self.basicAlert(message: "Confirmação Incorreta", handler: nil)
            }
            isValidData = false
            return
        }
        
        
        if !isValidData {
//            return // stop if not valid
        }
        
        DispatchQueue.main.async {
            self.view.firstResponder?.resignFirstResponder()
            self.view.becomeFirstResponder()
            self.loadingView.startAnimating()
            self.formStackView.alpha = 0.0
            self.btnConfirm.alpha = 0.0
        }
        
        ServerManager.shared.updateUserPassword(oldPassword: oldPassword, newPassword: confirmPassword, trackEvent: EventTrack.ChangePassword.confirm) { (success:Bool?, message:String?) in
            if success == true {
                DispatchQueue.main.async {
                    self.formStackView.alpha = 1.0
                    self.btnConfirm.alpha = 1.0
                    self.loadingView.stopAnimating()
                    self.basicAlert(message: message ?? "Senha alterada com sucesso!", handler: { (_) in
                        DispatchQueue.main.async {
                            self.dismissAction()
                        }
                    })
                }
            } else {
                DispatchQueue.main.async {
                    self.formStackView.alpha = 1.0
                    self.btnConfirm.alpha = 1.0
                    self.loadingView.stopAnimating()
                    self.basicAlert(message: message ?? "Erro ao alterar senha\n\nTente novamente mais tarde", handler: nil)
                }
            }

        }
        
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Super Methods
    override func prepareElements() {
        super.prepareElements()
        self.contentContainerView.addWidthConstraint(310)
        self.scrollView.addCenterYAlignmentConstraintTo(subView: self.contentContainerView, relatedBy: .equal, constant: 0, priority: 500)
        // Background
        self.view.backgroundColor = UIColor.clear
        self.view.insertSubview(self.blurView, at: 0)
        self.view.addFullBoundsConstraintsTo(subView: self.blurView, constant: 0)
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 15)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 15)
        // Stack
        self.contentContainerView.addSubview(self.stackView)
        self.contentContainerView.addBoundsConstraintsTo(subView: self.stackView, leading: nil, trailing: nil, top: 10, bottom: -10)
        self.contentContainerView.addCenterXAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.contentContainerView.addLeadingAlignmentConstraintTo(subView: self.stackView, relatedBy: .equal, constant: 10, priority: 750)
        self.contentContainerView.addTrailingAlignmentConstraintTo(subView: self.stackView, relatedBy: .equal, constant: -10, priority: 750)
        self.stackView.addWidthConstraint(constant: 500, relatedBy: .lessThanOrEqual, priority: 999)
        // Title
//        self.stackView.addArrangedSubview(self.lblTitle)
//        self.lblTitle.addHeightConstraint(25)
        // Form Container
        self.stackView.addArrangedSubview(self.formContainerView)
        // Loading
        self.formContainerView.addSubview(self.loadingView)
        self.formContainerView.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.formContainerView.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        // Title
        self.formContainerView.addSubview(self.lblTitle)
        self.formContainerView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 10, trailing: -10, top: 30, bottom: nil)
        self.lblTitle.addHeightConstraint(25)
        // Form Stack
        self.formContainerView.addSubview(self.formStackView)
        self.formContainerView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.formStackView, constant: 30)
        self.formContainerView.addBoundsConstraintsTo(subView: self.formStackView, leading: 27, trailing: -27, top: nil, bottom: nil)
        // Fields
        self.formStackView.addArrangedSubview(self.oldPasswordField)
        let inputHeight:CGFloat = 50.0
        self.oldPasswordField.addHeightConstraint(inputHeight)
        self.formStackView.addArrangedSubview(self.newPasswordField)
        self.newPasswordField.addHeightConstraint(inputHeight)
        self.formStackView.addArrangedSubview(self.confirmPasswordField)
        self.confirmPasswordField.addHeightConstraint(inputHeight)
        // Confirm
        self.formContainerView.addSubview(self.btnConfirm)
        self.formContainerView.addVerticalSpacingTo(subView1: self.formStackView, subView2: self.btnConfirm, constant: 30)
        self.formContainerView.addCenterXAlignmentConstraintTo(subView: self.btnConfirm, constant: 0)
        self.formContainerView.addBottomAlignmentConstraintTo(subView: self.btnConfirm, constant: -30)
        self.btnConfirm.addWidthConstraint(280)
        self.btnConfirm.addHeightConstraint(50)
    }
    
    override var canBecomeFirstResponder: Bool {return true}
    
}




