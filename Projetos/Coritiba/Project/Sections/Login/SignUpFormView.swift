//
//  SignUpFormView.swift
//
//
//  Created by Roberto Oliveira on 23/01/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class SignUpFormView: UIView, UITextViewDelegate {
    
    // MARK: - Objects
    let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Medium, size: 14)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        return lbl
    }()
    let txfName:CustomTextField = {
        let txf = CustomTextField()
        txf.placeholder = "Nome"
        txf.keyboardType = UIKeyboardType.asciiCapable
        txf.autocapitalizationType = .words
        txf.applySignUpTextfieldStyles()
        txf.returnKeyType = .next
        return txf
    }()
    let txfEmail:CustomTextField = {
        let txf = CustomTextField()
        txf.placeholder = "Email"
        txf.keyboardType = UIKeyboardType.emailAddress
        txf.autocapitalizationType = .none
        txf.applySignUpTextfieldStyles()
        txf.returnKeyType = .next
        return txf
    }()
    let txfPassword:CustomTextField = {
        let txf = CustomTextField()
        txf.placeholder = "Senha"
        txf.keyboardType = UIKeyboardType.asciiCapable
        txf.autocapitalizationType = .none
        txf.applySignUpTextfieldStyles()
        txf.returnKeyType = UIReturnKeyType.next
        txf.autocorrectionType = .no
        txf.isSecureTextEntry = true
        return txf
    }()
    let txfConfirmPassword:CustomTextField = {
        let txf = CustomTextField()
        txf.placeholder = "Confirmar Senha"
        txf.keyboardType = UIKeyboardType.asciiCapable
        txf.autocapitalizationType = .none
        txf.applySignUpTextfieldStyles()
        txf.autocorrectionType = .no
        txf.isSecureTextEntry = true
        txf.returnKeyType = UIReturnKeyType.send
        return txf
    }()
    let btnRecoverPassword:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = UIColor.clear
        btn.setTitleColor(Theme.color(.AlternativeCardElements), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Helvetica.Medium, size: 14)
        btn.setTitle("Recuperar Senha", for: .normal)
        btn.highlightedScale = 0.9
        btn.highlightedAlpha = 1.0
        return btn
    }()
    lazy var txvTerms:UITextView = {
        let vw = UITextView()
        let text = "Ao se cadastrar, você concorda com nossos Termos de Uso e Políticas de Privacidade."
        let attributedString = NSMutableAttributedString(string: text, attributes: [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Avenir.Medium, size: 14),
            NSAttributedString.Key.foregroundColor : Theme.color(.AlternativeCardElements)
            ])
        // Terms of use
        let documentsUrlString = ProjectManager.mainUrl
        let termsRange = (text as NSString).range(of: "Termos de Uso")
        let termsUrlString = "\(documentsUrlString)/termos-de-uso"
        attributedString.addAttribute(.link, value: termsUrlString, range: termsRange)
        attributedString.addAttribute(.font, value: FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 14), range: termsRange)
        // Privacy Policy
        let privacyRange = (text as NSString).range(of: "Políticas de Privacidade")
        let privacyUrlString = "\(documentsUrlString)/politicas-de-privacidade"
        attributedString.addAttribute(.link, value: privacyUrlString, range: privacyRange)
        attributedString.addAttribute(.font, value: FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 14), range: privacyRange)
        // Layout
        vw.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        vw.isEditable = false
        vw.isScrollEnabled = false
        vw.backgroundColor = UIColor.clear
        vw.tintColor = Theme.color(.PrimaryAnchor)
        vw.delegate = self
        vw.attributedText = attributedString
        return vw
    }()
    
    
    
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString.hasSuffix("termos-de-uso") {
            ServerManager.shared.setTrack(trackEvent: EventTrack.Signup.openTermsOfUse, trackValue: nil)
            DispatchQueue.main.async {
                let vc = WebDocumentViewController(id: 2)
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
        } else if URL.absoluteString.hasSuffix("politicas-de-privacidade") {
            ServerManager.shared.setTrack(trackEvent: EventTrack.Signup.openPrivacyPolicy, trackValue: nil)
            DispatchQueue.main.async {
                let vc = WebDocumentViewController(id: 3)
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
        }
        return false
    }
    
    
    
    
    private func prepareElements() {
        self.backgroundColor = Theme.color(.AlternativeCardBackground)
        // Title
        self.addSubview(self.lblTitle)
        self.addBoundsConstraintsTo(subView: self.lblTitle, leading: 20, trailing: -20, top: 20, bottom: nil)
        // Stack
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = UIStackView.Distribution.fill
        stack.alignment = UIStackView.Alignment.fill
        self.addSubview(stack)
        stack.addArrangedSubview(self.txfName)
        stack.addArrangedSubview(self.txfEmail)
        stack.addArrangedSubview(self.txfPassword)
        stack.addArrangedSubview(self.txfConfirmPassword)
        stack.addArrangedSubview(self.txvTerms)
        self.txvTerms.addHeightConstraint(constant: 60, relatedBy: .equal, priority: 750)
        
        self.addVerticalSpacingTo(subView1: self.lblTitle, subView2: stack, constant: 20)
        self.addBoundsConstraintsTo(subView: stack, leading: 20, trailing: -20, top: nil, bottom: -30)
        
        stack.addArrangedSubview(self.btnRecoverPassword)
        self.btnRecoverPassword.addHeightConstraint(constant: 35, relatedBy: .equal, priority: 99)
    }
    
    
    
    
    
    // MARK: - Init Methods
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}









// MARK: - Sign up Styles
extension CustomTextField {
    func applySignUpTextfieldStyles() {
        // Colors
        self.backgroundColor = UIColor.clear
        self.placeholderColor = Theme.color(.AlternativeCardElements).withAlphaComponent(0.6)
        self.textColor = Theme.color(.AlternativeCardElements)
        self.bottomLineColor = Theme.color(.AlternativeCardElements)
        self.borderColor = Theme.color(.AlternativeCardElements)
        // Style
        self.cornerRadius = 15
        self.borderWidth = 1.0
        self.font = FontsManager.customFont(key: FontsManager.Helvetica.Normal, size: 12)
        self.keyboardAppearance = UIKeyboardAppearance.dark
        self.contentInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 8)
        self.returnKeyType = UIReturnKeyType.next
        self.addDefaultAccessory(delegate: nil, autoResign: true)
        if UIScreen.main.bounds.height < 667 {
            self.addHeightConstraint(30)
        } else {
            self.addHeightConstraint(45)
        }
        self.autocorrectionType = .no
    }
}




