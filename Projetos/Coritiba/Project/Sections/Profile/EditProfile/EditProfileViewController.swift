//
//  EditProfileViewController.swift
//
//
//  Created by Roberto Oliveira on 23/08/18.
//  Copyright © 2018 RobertoOliveira. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseStackViewController, EditProfileHeaderViewDelegate, UITextFieldDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.statusBarStyle()
    }
    
    
    // MARK: - Properties
    private var selectedDate:Date?
    private var selectedGender:Gender?
    private var genders:[Gender] = [Gender.NotDefined, Gender.Female, Gender.Male, Gender.Other]
    
    
    
    
    
    // MARK: - Object
    private let closeHeaderView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryBackground)
        return vw
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        return btn
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.setTitle("SALVAR ALTERAÇÕES", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.layer.cornerRadius = 10.0
        btn.clipsToBounds = true
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    private lazy var headerView:EditProfileHeaderView = {
        let vw = EditProfileHeaderView()
        vw.delegate = self
        return vw
    }()
    private lazy var nameField:EditProfileField = {
        let vw = EditProfileField()
        vw.textfield.placeholder = "Nome"
        vw.textfield.returnKeyType = .next
        vw.textfield.autocapitalizationType = .words
        vw.textfield.delegate = self
        return vw
    }()
    private lazy var emailField:EditProfileField = {
        let vw = EditProfileField()
        vw.textfield.placeholder = "Email"
        vw.textfield.returnKeyType = .next
        vw.textfield.keyboardType = .emailAddress
        vw.textfield.autocapitalizationType = .none
        vw.textfield.delegate = self
        return vw
    }()
    private lazy var cpfField:EditProfileField = {
        let vw = EditProfileField()
        vw.textfield.placeholder = "CPF"
        vw.textfield.returnKeyType = .next
        vw.textfield.keyboardType = .numberPad
        vw.textfield.autocapitalizationType = .words
        vw.textfield.delegate = self
        return vw
    }()
    private lazy var genderField:EditProfileField = {
        let vw = EditProfileField()
        vw.textfield.placeholder = "Gênero"
        vw.textfield.tintColor = UIColor.clear
        return vw
    }()
    private lazy var genderPicker:UIPickerView = {
        let vw = UIPickerView()
        vw.dataSource = self
        vw.delegate = self
        return vw
    }()
    private lazy var birthField:EditProfileField = {
        let vw = EditProfileField()
        vw.textfield.placeholder = "Data de Nascimento"
        vw.textfield.tintColor = UIColor.clear
        return vw
    }()
    private lazy var datePicker:UIDatePicker = {
        let dp = UIDatePicker()
        if #available(iOS 13.4, *) {
            dp.preferredDatePickerStyle = .wheels
        }
        dp.maximumDate = Date.now()
        dp.datePickerMode = .date
        dp.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
        return dp
    }()
    @objc func dateChanged() {
        self.selectedDate = self.datePicker.date
        self.birthField.textfield.text = self.datePicker.date.stringWith(format: "dd/MM/yyyy")
    }
    private lazy var phoneField:EditProfileField = {
        let vw = EditProfileField()
        vw.textfield.placeholder = "Telefone"
        vw.textfield.keyboardType = .numberPad
        vw.textfield.delegate = self
        return vw
    }()
    private lazy var passwordField:EditProfileField = {
        let vw = EditProfileField()
        vw.textfield.placeholder = "Nova Senha"
        vw.textfield.returnKeyType = .send
        vw.textfield.autocapitalizationType = .none
        vw.textfield.autocorrectionType = .no
        vw.textfield.isSecureTextEntry = true
        vw.textfield.delegate = self
        return vw
    }()
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Methods
    @objc func cancel() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.EditProfile.close, trackValue: nil)
        DispatchQueue.main.async {
            if self.changesMade() {
                self.questionAlert(title: "Atenção!", message: "Você tem alterações não salvas! Tem certeza de que deseja cancelar?", handler: { (answer:Bool) in
                    if answer == true {
                        self.dismissAction()
                    }
                })
            } else {
                self.dismissAction()
            }
        }
    }
    
    @objc func confirm() {
        guard let user = ServerManager.shared.user else {return}
        if !self.changesMade() {
            DispatchQueue.main.async {
                self.statusAlert(message: "Nenhuma alteração foi feita", style: .Negative)
            }
            return
        }
        // Name
        let trimmedName = self.nameField.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if trimmedName.count < 3 {
            DispatchQueue.main.async {
                self.statusAlert(message: "Seu nome deve conter 3 letras ou mais", style: .Negative)
            }
            return
        }
        // Email
        let trimmedEmail = self.emailField.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if trimmedEmail == "" {
            if user.email != nil && user.email != "" {
                DispatchQueue.main.async {
                    self.statusAlert(message: "Email inválido", style: .Negative)
                }
                return
            }
        }
        if !trimmedEmail.isValidEmailFormat() {
            DispatchQueue.main.async {
                self.statusAlert(message: "Email inválido", style: .Negative)
            }
            return
        }
        // CPF
        let trimmedCPF = self.cpfField.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Phone
        let phone = self.phoneField.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        
        DispatchQueue.main.async {
            self.btnClose.isUserInteractionEnabled = false
            self.btnClose.alpha = 0.5
            self.btnConfirm.isUserInteractionEnabled = false
            self.btnConfirm.alpha = 0.5
            self.view.isUserInteractionEnabled = false
        }
        ServerManager.shared.updateUser(name: trimmedName, email: trimmedEmail, phone: phone, cpf: trimmedCPF, gender: self.selectedGender, birth: self.selectedDate, newPassword: nil, trackEvent: EventTrack.EditProfile.confirm) { (success:Bool?, message:String?) in
            if success == true {
                DispatchQueue.main.async {
                    self.basicAlert(message: message ?? "Salvo com sucesso") { (_) in
                        self.dismissAction()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.btnClose.isUserInteractionEnabled = true
                    self.btnClose.alpha = 1.0
                    self.btnConfirm.isUserInteractionEnabled = true
                    self.btnConfirm.alpha = 1.0
                    self.view.isUserInteractionEnabled = true
                    self.titleAlert(title: "Ooops!", message: message ?? "Erro ao salvar", handler: nil)
                }
            }
        }
    }
    
    
    
    private func changesMade() -> Bool {
        guard let user = ServerManager.shared.user else {return false}
        // Name
        let userNameString = user.name ?? ""
        let nameString = self.nameField.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if (userNameString != nameString) {
            return true
        }
        // Email
        let userEmailString = user.email ?? ""
        let emailString = self.emailField.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if (userEmailString != emailString) {
            return true
        }
        // CPF
        let userCPFString = user.cpf?.withMaskCPF() ?? ""
        let cpfString = self.cpfField.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if (userCPFString != cpfString) {
            return true
        }
        // Birth date
        let userDateString = user.born?.stringWith(format: "dd/MM/yyyy") ?? ""
        let selectedDateString = self.selectedDate?.stringWith(format: "dd/MM/yyyy") ?? ""
        if userDateString != selectedDateString {
            return true
        }
        // Gender
        if let selected = self.selectedGender {
            if selected != user.gender {
                return true
            }
        }
        // Phone
        let userPhoneString = user.phone ?? ""
        let phoneString = self.phoneField.textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if (userPhoneString != phoneString) {
            return true
        }
        // New Password
//        if (self.passwordField.textfield.text ?? "") != "" {
//            return true
//        }
        return false
    }
    
    
    
    
    // MARK: - Delegate Methods
    func updateAvatar() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.EditProfile.changePhoto, trackValue: nil)
        DispatchQueue.main.async {
            self.chooseMedia()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameField.textfield {
            self.emailField.textfield.becomeFirstResponder()
        } else if textField == self.emailField.textfield {
            self.genderField.textfield.becomeFirstResponder()
        }  else if textField == self.genderField.textfield {
            self.birthField.textfield.becomeFirstResponder()
        } else if textField == self.phoneField.textfield {
            self.cpfField.textfield.becomeFirstResponder()
        } else {
            self.confirm()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.phoneField.textfield {
            return textField.applyMaskToPhone(range: range, string: string) // PHONE MASK
        } else if textField == self.cpfField.textfield {
            return textField.applyMaskToCPF(range: range, string: string) // CPF MASK
        }
        return true
    }
    
    
    
    
    
    
    
    // MARK: - Content Methods
    private func updateContent() {
        guard let user = ServerManager.shared.user else {return}
        self.nameField.textfield.text = user.name
        self.emailField.textfield.text = user.email
        self.cpfField.textfield.text = user.cpf?.withMaskCPF()
        if let date = user.born {
            self.selectedDate = date
            self.birthField.textfield.text = date.stringWith(format: "dd/MM/yyyy")
            self.datePicker.setDate(date, animated: false)
        }
        if let gender = user.gender {
            self.selectedGender = gender
            self.genderField.textfield.text = user.gender?.genderDescription()
            for (index, item) in self.genders.enumerated() {
                if item == gender {
                    self.genderPicker.selectRow(index, inComponent: 0, animated: false)
                }
            }
        }
        self.phoneField.textfield.text = user.phone?.withMaskPhone()
    }
    
    
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateContent()
    }
    
    override func prepareElements() {
        super.prepareElements()
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        self.btnClose.addHeightConstraint(40)
        // Header
        self.view.insertSubview(self.closeHeaderView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.closeHeaderView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.view.addBottomAlignmentRelatedConstraintTo(subView: self.closeHeaderView, reference: self.btnClose, constant: 10)
        self.view.addVerticalSpacingTo(subView1: self.closeHeaderView, subView2: self.stackView, constant: -60)
        // Header
        self.addFullWidthStackSubview(self.headerView)
        
        self.stackView.spacing = 17
        let width = min(450, UIScreen.main.bounds.width-50)
        let height:CGFloat = 50.0
        // Name
        self.stackView.addArrangedSubview(self.nameField)
        self.nameField.addWidthConstraint(width)
        self.nameField.addHeightConstraint(height)
        // Email
        self.stackView.addArrangedSubview(self.emailField)
        self.emailField.addWidthConstraint(width)
        self.emailField.addHeightConstraint(height)
        // Gender
        self.stackView.addArrangedSubview(self.genderField)
        self.genderField.addWidthConstraint(width)
        self.genderField.textfield.inputView = self.genderPicker
        self.genderField.addHeightConstraint(height)
        // Birth
        self.stackView.addArrangedSubview(self.birthField)
        self.birthField.addWidthConstraint(width)
        self.birthField.textfield.inputView = self.datePicker
        self.birthField.addHeightConstraint(height)
        // Phone
        self.stackView.addArrangedSubview(self.phoneField)
        self.phoneField.addWidthConstraint(width)
        self.phoneField.addHeightConstraint(height)
        // CPF
        self.stackView.addArrangedSubview(self.cpfField)
        self.cpfField.addWidthConstraint(width)
        self.cpfField.addHeightConstraint(45)
        // Password
//        self.stackView.addArrangedSubview(self.passwordField)
//        self.passwordField.addWidthConstraint(width)
//        self.passwordField.addHeightConstraint(45)
        self.addStackSpaceView(height: 20)
        // Confirm
        self.stackView.addArrangedSubview(self.btnConfirm)
        self.btnConfirm.addHeightConstraint(50)
        self.btnConfirm.addWidthConstraint(315)
        
        self.addStackSpaceView(height: 80)
    }
    
}


extension EditProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let gender = self.genders[row]
        self.selectedGender = gender
        self.genderField.textfield.text = gender.genderDescription()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let gender = self.genders[row]
        return gender.genderDescription() ?? "-"
    }
    
}



// MARK: - Update Avatar methods
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseMedia() {
        self.chooseMediaSourceAlert(sourceView: self.view) { (type:UIImagePickerController.SourceType?) in
            guard let mode = type else {
                ServerManager.shared.setTrack(trackEvent: EventTrack.EditProfile.changePhotoCancel, trackValue: nil)
                return
            }
            if mode == .camera {
                ServerManager.shared.setTrack(trackEvent: EventTrack.EditProfile.changePhotoCamera, trackValue: nil)
                // Take Photo with camera
                DispatchQueue.main.async {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = UIImagePickerController.SourceType.camera
                    imagePicker.navigationBar.isTranslucent = false
                    imagePicker.modalPresentationStyle = .overFullScreen
                    self.present(imagePicker, animated: true, completion: nil)
                }
            } else {
                ServerManager.shared.setTrack(trackEvent: EventTrack.EditProfile.changePhotoLibrary, trackValue: nil)
                // Choose from photo library
                DispatchQueue.main.async {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    imagePicker.navigationBar.isTranslucent = false
                    imagePicker.modalPresentationStyle = .overFullScreen
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        let new = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
        let fixedImage = new?.fixOrientation()
        DispatchQueue.main.async {
            self.headerView.btnAvatar.setImage(fixedImage, for: .normal)
            picker.dismiss(animated: true, completion: nil)
        }
        if let img = fixedImage {
            ServerManager.shared.userImage = img
            ServerManager.shared.updateAvatar(image: img) { (success:Bool?) in
                // --
            }
        }
    }
    
}

//// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
