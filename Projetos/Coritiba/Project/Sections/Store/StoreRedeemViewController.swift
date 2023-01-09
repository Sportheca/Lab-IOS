//
//  StoreRedeemViewController.swift
//
//
//  Created by Roberto Oliveira on 14/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol StoreRedeemViewControllerDelegate:AnyObject {
    func storeRedeemViewController(storeRedeemViewController:StoreRedeemViewController, didRedeemItem item:StoreItem, newCuponID cuponID:Int?)
}

class StoreRedeemViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate:StoreRedeemViewControllerDelegate?
    private var currentItem:StoreItem?
    
    
    // MARK: - Objects
    private let blurView:UIVisualEffectView = {
        let vw = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        vw.isUserInteractionEnabled = false
        return vw
    }()
    private lazy var btnClose:CloseButton = {
        let btn = CloseButton()
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.AlternativeCardBackground)
        vw.layer.cornerRadius = 25.0
        return vw
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .center
        vw.distribution = .fill
        vw.spacing = 20.0
        return vw
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.isPlaceholderTintColorEnabled = true
        iv.tintColor = Theme.color(Theme.Color.MutedText)
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 14)
        lbl.textColor = Theme.color(.AlternativeCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let coinsView:StoreItemCoinsView = StoreItemCoinsView()
    private let lblCoinsDescription:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = UIColor(hexString: "FAD716")
        lbl.text = "*VALOR EXCLUSIVO PARA MEMBROS SÓCIO TORCEDORES"
        return lbl
    }()
    private let lblMessage:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 14)
        lbl.textColor = Theme.color(.MutedText)
        lbl.text = "Deseja resgatar esse item? Não é possível reembolsar os resgates feitos."
        return lbl
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("CONFIRMAR", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.backgroundColor = UIColor(hexString: "FAD716")
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    private let loadingView:ContentLoadingView = ContentLoadingView()
    
    
    
    // MARK: - Methods
    @objc func close() {
//        ServerManager.shared.setTrack(trackEvent: EventTrack.StoreItemRedeem.close, trackValue: self.currentItem?.id)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func confirm() {
        guard let item = self.currentItem else {return}
        DispatchQueue.main.async {
            self.btnClose.isHidden = true
            self.stackView.alpha = 0.0
            self.loadingView.startAnimating()
        }
        ServerManager.shared.setStoreItemRedeem(item: item, trackEvent: nil) { (success:Bool?, cuponID:Int?, message:String?) in
            DispatchQueue.main.async {
                self.btnClose.isHidden = false
                self.stackView.alpha = 1.0
                self.loadingView.stopAnimating()
                if success == true {
                    self.basicAlert(message: message ?? "Resgatado com sucesso") { (_) in
                        self.delegate?.storeRedeemViewController(storeRedeemViewController: self, didRedeemItem: item, newCuponID: cuponID)
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.basicAlert(message: message ?? "Falha ao resgatar", handler: nil)
                }
            }
        }
    }
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let item = self.currentItem else {return}
        let placeholder:String? = item.imageUrlString == nil ? "store_bag" : nil
        self.ivCover.setServerImage(urlString: item.imageUrlString, placeholderImageName: placeholder)
        self.lblTitle.text = item.title
        guard let user = ServerManager.shared.user else {return}
        if user.membershipMode != .None {
            self.coinsView.updateContent(coins0: nil, coins1: item.membershipCoins, blockDescription: item.priceBlockDescription)
            self.lblCoinsDescription.isHidden = false
        } else {
            self.coinsView.updateContent(coins0: item.coins, coins1: nil, blockDescription: item.priceBlockDescription)
            self.lblCoinsDescription.isHidden = true
        }
        
    }
    
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.loadViewIfNeeded()
        self.view.backgroundColor = UIColor.clear
        // Blur
        self.view.addSubview(self.blurView)
        self.view.addFullBoundsConstraintsTo(subView: self.blurView, constant: 0)
        // Container
        self.view.addSubview(self.containerView)
        self.containerView.addWidthConstraint(335)
        self.view.addCenterXAlignmentConstraintTo(subView: self.containerView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.containerView, constant: 0)
        // Close
        self.containerView.addSubview(self.btnClose)
        self.containerView.addBoundsConstraintsTo(subView: self.btnClose, leading: nil, trailing: -8, top: 4, bottom: nil)
        self.btnClose.addHeightConstraint(35)
        self.btnClose.addWidthConstraint(35)
        // Stack
        self.containerView.insertSubview(self.stackView, belowSubview: self.btnClose)
        self.containerView.addBoundsConstraintsTo(subView: self.stackView, leading: 20, trailing: -20, top: 25, bottom: -25)
        // Logo
        self.stackView.addArrangedSubview(self.ivCover)
        self.ivCover.addWidthConstraint(200)
        self.ivCover.addHeightConstraint(65)
        // Title
        self.stackView.addArrangedSubview(self.lblTitle)
        // coins
        self.stackView.addArrangedSubview(self.coinsView)
        self.stackView.addArrangedSubview(self.lblCoinsDescription)
        // message
        self.stackView.addArrangedSubview(self.lblMessage)
        // confirm
        self.stackView.addArrangedSubview(self.btnConfirm)
        self.btnConfirm.addWidthConstraint(140)
        self.btnConfirm.addHeightConstraint(40)
        // Loading
        self.containerView.addSubview(self.loadingView)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.containerView.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
    }
    
    
    init(item:StoreItem) {
        super.init(nibName: nil, bundle: nil)
        self.prepareElements()
        self.currentItem = item
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
