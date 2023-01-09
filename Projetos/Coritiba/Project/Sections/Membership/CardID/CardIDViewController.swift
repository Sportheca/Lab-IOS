//
//  CardIDViewController.swift
//
//
//  Created by Roberto Oliveira on 20/08/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

extension CardIDViewController {
    static func present() {
        guard let user = ServerManager.shared.user else {return}
        if user.isMembershipCardIDCompleted() {
            DispatchQueue.main.async {
                guard let topVc = UIApplication.topViewController() else {return}
                let vc = CardIDViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .coverVertical
                topVc.present(vc, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                guard let topVc = UIApplication.topViewController() else {return}
                let vc = EditProfileViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .coverVertical
                topVc.present(vc, animated: true, completion: nil)
            }
        }
    }
}

class CardIDViewController: BaseViewController {
    
    // MARK: - Properties
    var menuTrackEvent:Int?
    
    
    
    // MARK: - Objects
    private let headerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private let cardView:MembershipCardIDView = MembershipCardIDView()
    private let qrCodeView:QRCodeView = QRCodeView()
    private let qrCodeFrame:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "focus_frame")
        return iv
    }()
    private let lblFooter:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 14)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.text = "Escaneie o Código QR no dispositivo o qual você deseja compartilhar o seu contato."
        return lbl
    }()
    private lazy var btnShare:PrimaryButton = {
        let btn = PrimaryButton(title: "COMPARTILHAR VIA...")
        btn.addTarget(self, action: #selector(self.share), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    // MARK: - Methods
    @objc func close() {
        self.dismissAction()
    }
    
    @objc func share() {
        DispatchQueue.main.async {
            guard let img = UIImage.imageFrom(view: self.cardView) else {return}
            UIApplication.shared.shareImage(img)
        }
    }
    
    private func updateContent() {
        self.cardView.updateContent()
        guard let user = ServerManager.shared.user else {return}
        let nameComponents = user.name?.components(separatedBy: " ") ?? []
        
        let firstName = nameComponents.first ?? ""
        let lastName = (nameComponents.count > 1) ? nameComponents.last ?? "" : ""
        let phone = user.phone ?? ""
        let email = user.email ?? ""
        let vCard = String.vCardFrom(firstName: firstName, lastName: lastName, phone: phone, email: email)
        self.qrCodeView.updateQRCodeWithString(vCard)
    }
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateContent()
    }
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        self.btnClose.addHeightConstraint(40)
        // Header
        self.view.insertSubview(self.headerView, belowSubview: self.btnClose)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.view.addBottomAlignmentRelatedConstraintTo(subView: self.headerView, reference: self.btnClose, constant: 10)
        // Card View
        self.view.addSubview(self.cardView)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.cardView, constant: 15)
        self.view.addCenterXAlignmentConstraintTo(subView: self.cardView, constant: 0)
        self.view.addLeadingAlignmentConstraintTo(subView: self.cardView, relatedBy: .equal, constant: 10, priority: 998)
        self.view.addTrailingAlignmentConstraintTo(subView: self.cardView, relatedBy: .equal, constant: -10, priority: 998)
        self.cardView.addWidthConstraint(constant: 450, relatedBy: .lessThanOrEqual, priority: 999)
        // QRCode View
        self.view.addSubview(self.qrCodeView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.qrCodeView, constant: 0)
        self.view.addLeadingAlignmentConstraintTo(subView: self.qrCodeView, relatedBy: .equal, constant: 10, priority: 750)
        self.view.addTrailingAlignmentConstraintTo(subView: self.qrCodeView, relatedBy: .equal, constant: -10, priority: 750)
        self.qrCodeView.addWidthConstraint(constant: 180, relatedBy: .lessThanOrEqual, priority: 999)
        // Frame
        self.view.insertSubview(self.qrCodeFrame, belowSubview: self.qrCodeView)
        self.view.addVerticalSpacingTo(subView1: self.cardView, subView2: self.qrCodeFrame, constant: 20)
        self.view.addCenterXAlignmentRelatedConstraintTo(subView: self.qrCodeFrame, reference: self.qrCodeView, constant: 0)
        self.view.addCenterYAlignmentRelatedConstraintTo(subView: self.qrCodeFrame, reference: self.qrCodeView, constant: 0)
        self.view.addHeightRelatedConstraintTo(subView: self.qrCodeFrame, reference: self.qrCodeView, relatedBy: .equal, multiplier: 1.0, constant: 40.0, priority: 999)
        self.view.addWidthRelatedConstraintTo(subView: self.qrCodeFrame, reference: self.qrCodeView, relatedBy: .equal, multiplier: 1.0, constant: 40.0, priority: 999)
        // Footer
        self.view.addSubview(self.lblFooter)
        self.view.addVerticalSpacingTo(subView1: self.qrCodeFrame, subView2: self.lblFooter, constant: 30)
        self.view.addCenterXAlignmentConstraintTo(subView: self.lblFooter, constant: 0)
        self.view.addLeadingAlignmentConstraintTo(subView: self.lblFooter, relatedBy: .equal, constant: 10, priority: 750)
        self.view.addTrailingAlignmentConstraintTo(subView: self.lblFooter, relatedBy: .equal, constant: -10, priority: 750)
        self.lblFooter.addWidthConstraint(constant: 300, relatedBy: .lessThanOrEqual, priority: 999)
        self.lblFooter.addHeightConstraint(35)
        // Share
        self.view.addSubview(self.btnShare)
        self.btnShare.addWidthConstraint(180)
        self.btnShare.addHeightConstraint(35)
        self.view.addVerticalSpacingTo(subView1: self.lblFooter, subView2: self.btnShare, constant: 30)
        self.view.addCenterXAlignmentConstraintTo(subView: self.btnShare, constant: 0)
        self.view.addBottomAlignmentConstraintTo(subView: self.btnShare, relatedBy: .lessThanOrEqual, constant: -30, priority: 999)
    }
    
}


