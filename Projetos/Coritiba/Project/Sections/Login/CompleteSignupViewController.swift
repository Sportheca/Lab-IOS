//
//  CompleteSignupViewController.swift
//
//
//  Created by Roberto Oliveira on 22/11/2017.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit

class CompleteSignupViewController: BaseKeyboardViewController {
    
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
    private var verticalConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 24)
        lbl.textColor = Theme.color(.TextOverSplashImage)
        lbl.text = "Complete seu Cadastro"
        return lbl
    }()
    private lazy var contentView:SignUpFormView = {
        let vw = SignUpFormView()
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 25.0
        vw.txfName.delegate = self
        vw.txfEmail.delegate = self
        vw.txfPassword.delegate = self
        vw.txfConfirmPassword.delegate = self
        return vw
    }()
    private var confirmTopConstraint:NSLayoutConstraint = NSLayoutConstraint()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Avenir.Black, size: 15)
        btn.layer.cornerRadius = 10.0
        btn.highlightedScale = 0.9
        btn.highlightedAlpha = 0.7
        btn.addTarget(self, action: #selector(self.confirmMethod), for: .touchUpInside)
        return btn
    }()
    @objc func confirmMethod() {
        self.signUp()
    }
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.TextOverSplashImage), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 14)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    
    
    
    
    // MARK: - Methods
    private func updateTexts() {
        DispatchQueue.main.async {
            self.btnConfirm.setTitle("CONFIRMAR", for: .normal)
            self.contentView.lblTitle.text = "Complete seu cadastro para interagir com todas as funcionalidades do app e resgatar prêmios."
            self.contentView.txfPassword.returnKeyType = UIReturnKeyType.next
            UIView.animate(withDuration: 0.25) {
                self.contentView.txfName.alpha = 1.0
                self.contentView.txfName.isHidden = false
                self.contentView.txfConfirmPassword.alpha = 1.0
                self.contentView.txfConfirmPassword.isHidden = false
                self.contentView.btnRecoverPassword.alpha = 0.0
                self.contentView.btnRecoverPassword.isHidden = true
                self.contentView.txvTerms.alpha = 1.0
                self.contentView.txvTerms.isHidden = false
            }
        }
    }
    
    private func signUp() {
        // Check for empty fields before submiting
        var emptyFields:Bool = false
        // Name
        guard let nameText = self.contentView.txfName.text else {return}
        let trimmedName = nameText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedName.isEmpty {
            emptyFields = true
            self.contentView.txfName.setPlaceholder(color: Theme.systemDestructiveColor)
            self.contentView.txfName.bounceAnimation()
        }
        
        // Email
        guard let emailText = self.contentView.txfEmail.text else {return}
        let trimmedEmail = emailText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            emptyFields = true
            self.contentView.txfEmail.setPlaceholder(color: Theme.systemDestructiveColor)
            self.contentView.txfEmail.bounceAnimation()
        }
        
        // Password
        guard let passwordText = self.contentView.txfPassword.text else {return}
        if passwordText.isEmpty {
            emptyFields = true
            self.contentView.txfPassword.setPlaceholder(color: Theme.systemDestructiveColor)
            self.contentView.txfPassword.bounceAnimation()
        }
        
        // Confirm Password
        guard let confirmPasswordText = self.contentView.txfConfirmPassword.text else {return}
        if confirmPasswordText.isEmpty {
            emptyFields = true
            self.contentView.txfConfirmPassword.setPlaceholder(color: Theme.systemDestructiveColor)
            self.contentView.txfConfirmPassword.bounceAnimation()
        }
        
        // Check valid information only if all required fields are done
        if emptyFields == true {
            return
        }
        
        
        // Check also for invalid info, like min characters and whitespaces on password
        // Name minimum characters
        if !trimmedName.isEmpty, trimmedName.count < 3 {
            self.contentView.txfName.bounceAnimation()
            self.contentView.txfName.becomeFirstResponder()
            UIApplication.topViewController()?.statusAlert(message: "Nome deve conter 3 letras ou mais", style: .Negative)
            return
        }
        
        // Invalid Email
        if !trimmedEmail.isValidEmailFormat() {
            self.contentView.txfEmail.bounceAnimation()
            self.contentView.txfEmail.becomeFirstResponder()
            UIApplication.topViewController()?.statusAlert(message: "Email inválido", style: .Negative)
            return
        }
        
        // Password whitespaces
        if passwordText.contains(otherString: " ") {
            self.contentView.txfPassword.text = String()
            self.contentView.txfPassword.setPlaceholder(color: Theme.systemDestructiveColor)
            self.contentView.txfPassword.bounceAnimation()
            self.contentView.txfPassword.becomeFirstResponder()
            UIApplication.topViewController()?.statusAlert(message: "Senha não pode conter espaços", style: .Negative)
            return
        }
        
        // Confirm Password whitespaces
        if confirmPasswordText.contains(otherString: " ") {
            self.contentView.txfConfirmPassword.text = String()
            self.contentView.txfConfirmPassword.setPlaceholder(color: Theme.systemDestructiveColor)
            self.contentView.txfConfirmPassword.bounceAnimation()
            self.contentView.txfConfirmPassword.becomeFirstResponder()
            UIApplication.topViewController()?.statusAlert(message: "Senha não pode conter espaços", style: .Negative)
            return
        }
        
        // Confirm Password equal
        if confirmPasswordText != passwordText {
            self.contentView.txfConfirmPassword.text = String()
            self.contentView.txfConfirmPassword.setPlaceholder(color: Theme.systemDestructiveColor)
            self.contentView.txfConfirmPassword.bounceAnimation()
            self.contentView.txfConfirmPassword.becomeFirstResponder()
            UIApplication.topViewController()?.statusAlert(message: "Confirmação de senha inválida", style: .Negative)
            return
        }
        
        DispatchQueue.main.async {
            self.contentView.alpha = 0.7
            self.view.becomeFirstResponder()
            self.view.isUserInteractionEnabled = false
        }
        ServerManager.shared.updateUser(name: trimmedName, email: trimmedEmail, phone: nil, cpf: nil, gender: nil, birth: nil, newPassword: passwordText, trackEvent: EventTrack.CompleteSignup.confirm) { (success:Bool?, message:String?) in
            if success == true {
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        DispatchQueue.main.async {
                            UIApplication.topViewController()?.statusAlert(message: "Cadastro criado com sucesso!", style: .Positive)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.contentView.alpha = 1.0
                    self.view.becomeFirstResponder()
                    self.view.isUserInteractionEnabled = true
                }
                self.basicAlert(message: message ?? "Falha ao cadastrar", handler: nil)
            }
        }
    }
    
    
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.CompleteSignup.close, trackValue: nil)
        DispatchQueue.main.async {
            self.dismissAction()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.verticalConstraintMultipliers = (keyboardVisible: 1.0, keyboardHidden: 0.9)
        // Background
        self.view.insertSubview(self.ivBackground, belowSubview: self.scrollView)
        self.view.addBoundsConstraintsTo(subView: self.ivBackground, leading: 0, trailing: 0, top: 0, bottom: 0)
//        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.ivBackground, constant: 100)
        // Back View
        self.view.insertSubview(self.backView, aboveSubview: self.ivBackground)
        self.view.addFullBoundsConstraintsTo(subView: self.backView, constant: 0)
        // Container View
        self.contentContainerView.addSubview(self.contentView)
        self.contentView.addWidthConstraint(min(500, UIScreen.main.bounds.size.width-30))
        self.contentContainerView.addCenterXAlignmentConstraintTo(subView: self.contentView, constant: 0)
        // Title
        self.view.addSubview(self.lblTitle)
        self.view.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.contentView, constant: 10)
        self.view.addLeadingAlignmentRelatedConstraintTo(subView: self.lblTitle, reference: self.contentView, constant: 20)
        // Confirm
        self.view.addSubview(self.btnConfirm)
        self.view.addCenterXAlignmentConstraintTo(subView: self.btnConfirm, constant: 0)
//        self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.btnConfirm, constant: -20, priority: 250, relatedBy: .equal)
        
        self.confirmTopConstraint = NSLayoutConstraint(item: self.btnConfirm, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: 20.0)
        self.confirmTopConstraint.priority = UILayoutPriority(999)
//        self.confirmTopConstraint.isActive = false
        self.view.addConstraint(self.confirmTopConstraint)
//        self.view.addVerticalSpacingTo(subView1: self.btnConfirm, subView2: self.btnFlip, constant: 15)
        
        if UIScreen.main.bounds.height < 667 {
            self.contentContainerView.addBoundsConstraintsTo(subView: self.contentView, leading: nil, trailing: nil, top: 10, bottom: -10)
            self.btnConfirm.addHeightConstraint(35)
            self.btnConfirm.addWidthConstraint(280)
        } else {
            self.contentContainerView.addBoundsConstraintsTo(subView: self.contentView, leading: nil, trailing: nil, top: 25, bottom: -25)
            self.btnConfirm.addHeightConstraint(50)
            self.btnConfirm.addWidthConstraint(315)
        }
        
        self.view.addSubview(self.btnClose)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.btnClose.addHeightConstraint(40)
        
        self.updateTexts()
    }
    
    override var canBecomeFirstResponder: Bool {return true}
    
    override func keyboardWillAppear(height: CGFloat, duration: TimeInterval) {
        super.keyboardWillAppear(height: height, duration: duration)
//        DispatchQueue.main.async {
//            self.confirmTopConstraint.isActive = true
//            UIView.animate(withDuration: duration) {
//                self.view.layoutSubviews()
//            }
//        }
    }
    
    override func keyboardWillDisappear(duration: TimeInterval) {
        super.keyboardWillDisappear(duration: duration)
//        DispatchQueue.main.async {
////            self.confirmTopConstraint.isActive = false
//            UIView.animate(withDuration: duration) {
//                self.view.layoutSubviews()
//            }
//        }
    }
    
}







// MARK: - UITextViewDelegate
extension CompleteSignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case self.contentView.txfName:
                self.contentView.txfEmail.becomeFirstResponder()
                break
            case self.contentView.txfEmail:
                self.contentView.txfPassword.becomeFirstResponder()
            break
            case self.contentView.txfPassword:
                self.contentView.txfConfirmPassword.becomeFirstResponder()
            break
            case self.contentView.txfConfirmPassword:
                self.signUp()
                break
            default: break
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.contentView.txfPassword) {
            return !string.contains(otherString: " ")
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = Theme.color(.PrimaryCardElements).withAlphaComponent(0.1)
        (textField as? CustomTextField)?.placeholderColor = UIColor.lightGray
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.clear
    }
}
