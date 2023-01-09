//
//  StoreItemDetailsViewController.swift
//
//
//  Created by Roberto Oliveira on 13/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class StoreItemDetailsViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.statusBarStyle()
    }
    
    // MARK: - Properties
    private var loadingStatus:LoadingStatus = .NotRequested
    private var currentItem:StoreItem?
    private var currentDetails:StoreItemDetails?
    var trackEvent:Int?
    
    
    
    // MARK: - Objects
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        return btn
    }()
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 30.0
        return vw
    }()
    private let ivCover:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 30)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()
    private let coinsView:StoreItemCoinsView = StoreItemCoinsView()
    private let lblCoinsDescription:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        lbl.textColor = UIColor(hexString: "FAD716")
        lbl.text = "*VALOR EXCLUSIVO PARA MEMBROS SÓCIO TORCEDORES"
        return lbl
    }()
    // content
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        vw.layer.cornerRadius = 15.0
        return vw
    }()
    private let textView:UITextView = {
        let txv = UITextView()
        txv.isEditable = false
        txv.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 14)
        txv.textColor = Theme.color(.PrimaryCardElements)
        txv.backgroundColor = UIColor(hexString: "003D38")
        txv.textAlignment = .center
        txv.layer.cornerRadius = 10.0
        return txv
    }()
    private lazy var btnDetails:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Ver Regulamento", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        btn.setTitleColor(UIColor(hexString: "1D1D1D"), for: .normal)
        btn.backgroundColor = UIColor(hexString: "FAD716")
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5.0
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.detailsActionMethod), for: .touchUpInside)
        return btn
    }()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("CONFIRMAR", for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    private let footerView:StoreItemDetailsFooterView = StoreItemDetailsFooterView()
    
    private let ivCover0: UIImageView = {
      let iv = UIImageView()
        iv.image = UIImage(named: "store_bg")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    // MARK: - Methods
    @objc func close() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.StoreItem.close, trackValue: self.currentItem?.id)
        self.dismissAction()
    }
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.StoreItem.tryAgain
        self.loadContent()
    }
    
    @objc func detailsActionMethod() {
        guard let item = self.currentDetails else {return}
        ServerManager.shared.setTrack(trackEvent: EventTrack.StoreItem.openDocument, trackValue: self.currentItem?.id)
        if item.isDocumentAvailable {
            DispatchQueue.main.async {
                let vc = WebDocumentViewController(id: self.currentItem?.id ?? 0, mode: .StoreItem)
                vc.closeTrackEvent = EventTrack.StoreDocument.close
                vc.tryAgainTrackEvent = EventTrack.StoreDocument.tryAgain
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    private func loadContent() {
        guard let item = self.currentItem else {return}
        DispatchQueue.main.async {
            self.textView.text = ""
            self.btnDetails.isHidden = true
            self.btnConfirm.isHidden = true
            self.footerView.isHidden = true
            self.loadingView.startAnimating()
        }
        ServerManager.shared.getStoreItemDetails(id: item.id, cuponID: item.cuponID, trackEvent: self.trackEvent) { (details:StoreItemDetails?, object:StoreItem?) in
            self.trackEvent = nil
            DispatchQueue.main.async {
                if let obj = object {
                    self.currentItem = obj
                }
                self.currentDetails = details
                if let item = details {
                    self.textView.text = item.message
                    self.btnDetails.isHidden = !item.isDocumentAvailable
                    self.btnConfirm.isHidden = !item.isAvailable
                    self.btnConfirm.bounceAnimation()
                    self.footerView.updateContent(item: item)
                    self.footerView.isHidden = item.isAvailable
                    self.loadingView.stopAnimating()
                } else {
                    self.loadingView.emptyResults()
                }
                self.updateContent()
            }
        }
    }
    
    
    @objc func confirm() {
        guard let item = self.currentItem else {return}
        DispatchQueue.main.async {
            let vc = StoreRedeemViewController(item: item)
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    private func updateContent() {
        DispatchQueue.main.async {
            guard let item = self.currentItem else {return}
            self.ivCover.setServerImage(urlString: item.imageUrlString)
            self.lblTitle.text = item.title
            self.coinsView.updateContent(coins0: item.coins, coins1: item.membershipCoins, blockDescription: item.priceBlockDescription, addMarker: true)
            self.coinsView.isHidden = item.coins == nil && item.membershipCoins == nil
            self.lblCoinsDescription.isHidden = item.membershipCoins == nil
            
            
            guard let user = ServerManager.shared.user else {return}
            if user.membershipMode != .None && item.coins == nil && item.membershipCoins != nil {
                self.btnConfirm.alpha = 0.6
                self.btnConfirm.isUserInteractionEnabled = false
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - Super Methods
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.loadContent()
        guard let item = self.currentItem else {return}
        self.ivCover.setServerImage(urlString: item.imageUrlString)
        self.lblTitle.text = item.title
        self.coinsView.isHidden = true
        self.lblCoinsDescription.isHidden = true
    }
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Cover
        self.view.addSubview(self.ivCover0)
        self.view.addBoundsConstraintsTo(subView: self.ivCover0, leading: 0, trailing: 0, top: 0, bottom: 0)
        // Close
        self.view.addSubview(self.btnClose)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // Container
        self.view.insertSubview(self.containerView, belowSubview: self.btnClose)
        self.view.addCenterYAlignmentConstraintTo(subView: self.containerView, relatedBy: .equal, constant: 0, priority: 250)
        self.view.addBoundsConstraintsTo(subView: self.containerView, leading: 0, trailing: 0, top: nil, bottom: nil)
        // TextView
        self.containerView.addSubview(self.textView)
        self.containerView.addBoundsConstraintsTo(subView: self.textView, leading: 15, trailing: -15, top: 10, bottom: -10)
        // details
        self.view.insertSubview(self.btnDetails, aboveSubview: self.containerView)
        self.view.addCenterXAlignmentRelatedConstraintTo(subView: self.btnDetails, reference: self.containerView, constant: 0)
        self.view.addBottomAlignmentRelatedConstraintTo(subView: self.btnDetails, reference: self.containerView, constant: 10)
        self.btnDetails.addWidthConstraint(135)
        self.btnDetails.addHeightConstraint(20)
        // Loading
        self.containerView.addSubview(self.loadingView)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.containerView.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        // stack
        self.view.insertSubview(self.stackView, belowSubview: self.btnClose)
        self.view.addVerticalSpacingTo(subView1: self.btnClose, subView2: self.stackView, relatedBy: .greaterThanOrEqual, constant: 10.0, priority: 999)
        self.view.addCenterXAlignmentConstraintTo(subView: self.stackView, constant: 0)
        self.view.addVerticalSpacingTo(subView1: self.stackView, subView2: self.containerView, constant: 10)
        self.stackView.addWidthConstraint(330)
        self.stackView.addArrangedSubview(self.ivCover)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.coinsView)
        self.stackView.addArrangedSubview(self.lblCoinsDescription)
        // Confirm
        self.view.addSubview(self.btnConfirm)
        self.view.addCenterXAlignmentConstraintTo(subView: self.btnConfirm, constant: 0)
        self.btnConfirm.addWidthConstraint(315)
        self.btnConfirm.addHeightConstraint(50)
        // Footer
        self.view.addSubview(self.footerView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.footerView, constant: 0)
        self.footerView.addWidthConstraint(300)
        
        if UIScreen.main.bounds.height < 667 {
            self.ivCover.addHeightConstraint(70)
            self.containerView.addHeightConstraint(150)
            self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.btnConfirm, constant: -10)
            self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.footerView, constant: -10)
        } else {
            self.ivCover.addHeightConstraint(90)
            self.containerView.addHeightConstraint(220)
            self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.btnConfirm, constant: -30)
            self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.footerView, constant: -50)
        }
        
    }
    
    init(item:StoreItem) {
        super.init()
        self.currentItem = item
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}










class StoreItemDetailsFooterView: UIView {
    
    // MARK: - Properties
    private var currentItem:StoreItemDetails?
    private var isCopyAlertVisible:Bool = false
    
    
    // MARK: - Objects
    private let stackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 8.0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    private let lblInfo:InsetsLabel = {
        let lbl = InsetsLabel()
        lbl.leftInset = 10.0
        lbl.rightInset = 10.0
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 25)
        lbl.textColor = Theme.color(.PrimaryText)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private let dashedLayer:CAShapeLayer = {
        var la = CAShapeLayer()
        la.frame = CGRect(x: 0, y: 0, width: 300, height: 45)
        la.fillColor = nil
        la.lineDashPattern = [5, 3]
        la.lineCap = CAShapeLayerLineCap.round
        la.lineWidth = 1.0
        la.strokeColor = Theme.color(.MutedText).cgColor
        return la
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dashedLayer.path = UIBezierPath(roundedRect: self.lblInfo.bounds, cornerRadius: 15.0).cgPath
    }
    
    @objc func labelAction() {
        guard let item = self.currentItem else {return}
        switch item.mode {
            case .Cupom:
                guard !self.isCopyAlertVisible else {return}
                self.isCopyAlertVisible = true
                DispatchQueue.main.async {
                    guard let code = self.currentItem?.footerInfo else {return}
                    let title = self.lblTitle.text ?? ""
                    var txt = title
                    if txt != "" {
                        txt += " "
                    }
                    txt += code
                    UIApplication.topViewController()?.actionAlert(title: txt, items: ["Copiar"], senderView: self.lblInfo, handler: { (title:String?, index:Int?) in
                        self.isCopyAlertVisible = false
                        DispatchQueue.main.async {
                            if index == 0 {
                                UIPasteboard.general.string = code
                                UIApplication.topViewController()?.statusAlert(message: "Copiado!", style: .Positive)
                            }
                        }
                    })
                }
                break
                
            case .File:
                guard let urlString = item.fileUrlString?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
                //guard let url = URL(string: urlString) else {return}
                DispatchQueue.main.async {
                    UIApplication.topViewController()?.downloadFileWith(url:urlString, completionAction:DownloaderAction.Preview, name: item.fileName, fixedFileName: item.fileName, fixedFileSize: item.fileSize)
                }
                break
        }
    }
    
    
    
    
    
    // MARK: - Methods
    func updateContent(item:StoreItemDetails) {
        self.currentItem = item
        self.lblTitle.text = item.footerTitle
        self.lblInfo.text = item.footerInfo
        self.lblSubtitle.text = item.footerSubtitle
    }
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        self.addSubview(self.stackView)
        self.addFullBoundsConstraintsTo(subView: self.stackView, constant: 0)
        self.stackView.addArrangedSubview(self.lblTitle)
        self.stackView.addArrangedSubview(self.lblInfo)
        self.lblInfo.addHeightConstraint(45)
        self.lblInfo.layer.addSublayer(dashedLayer)
        self.stackView.addArrangedSubview(self.lblSubtitle)
        
        self.lblInfo.isUserInteractionEnabled = true
        self.lblInfo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.labelAction)))
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.labelAction))
        gesture.minimumPressDuration = 1.0
        self.lblInfo.addGestureRecognizer(gesture)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.prepareElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}




extension StoreItemDetailsViewController: StoreRedeemViewControllerDelegate {
    func storeRedeemViewController(storeRedeemViewController: StoreRedeemViewController, didRedeemItem item: StoreItem, newCuponID cuponID: Int?) {
        self.currentItem = StoreItem(id: item.id, cuponID: cuponID, title: item.title, imageUrlString: item.imageUrlString, subtitle: item.subtitle, coins: nil, membershipCoins: nil, isMembershipOnly: item.isMembershipOnly)
        self.loadContent()
    }
    
}
