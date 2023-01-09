//
//  SquadSelectorShareViewController.swift
//
//
//  Created by Roberto Oliveira on 19/08/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class SquadSelectorShareViewController: BaseViewController {
    
    // MARK: - Properties
    var currentInfo:SquadSelectorInfo?
    private var image:UIImage?
    
    
    
    // MARK: - Objects
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.addTarget(self, action: #selector(self.dismissAction), for: .touchUpInside)
        return btn
    }()
    private let containerView:UIView = {
        let vw = UIView()
        vw.isUserInteractionEnabled = true
        vw.backgroundColor = Theme.color(.PrimaryCardBackground)
        return vw
    }()
    private let ivBackground:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "squad_share_bg")
        iv.backgroundColor = Theme.color(Theme.Color.PrimaryCardBackground)
        return iv
    }()
    private let userHeaderView:SquadShareUserHeaderView = SquadShareUserHeaderView()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 15)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private let squadView:SquadSelectorView = {
        let vw = SquadSelectorView()
        vw.ivBackground.backgroundColor = UIColor.clear
        vw.ivBackground.image = UIImage(named: "linhas_campo_3")
        vw.ivBackground.layer.cornerRadius = 0.0
        vw.ivBackground.transform = CGAffineTransform(translationX: 0, y: 10)
        return vw
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.setTitle("COMPARTILHAR", for: .normal)
        btn.adjustsAlphaWhenHighlighted = false
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    private let lblFooter:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 15)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.text = ProjectInfoManager.TextInfo.faca_o_seu_no_app_oficial.rawValue
        return lbl
    }()
    private let iconsStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .horizontal
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 10.0
        return vw
    }()
    private let ivIcon0:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon_google_play")
        return iv
    }()
    private let ivIcon1:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon_app_store")
        return iv
    }()
    private let ivLogo:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.clear
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "logo")
        return iv
    }()
    private lazy var adsBackView:UIView = {
        let vw = UIView()
        vw.isUserInteractionEnabled = true
        vw.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openBannerLink)))
        return vw
    }()
    private let ivAds:ServerImageView = {
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    
    
    
    
    // MARK: - Methods
    @objc func confirm() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.SquadSelectorShare.confirm, trackValue: self.currentInfo?.id)
        DispatchQueue.main.async {
            guard let img = UIImage.imageFrom(view: self.containerView) else {return}
            UIApplication.shared.shareImage(img)
        }
    }
    
    @objc func openBannerLink() {
        guard let urlString = self.currentInfo?.bannerItem?.urlString else {return}
        guard !urlString.isEmpty else {return}
        DispatchQueue.main.async {
            let item = self.currentInfo?.bannerItem
            BaseWebViewController.open(urlString: urlString , mode: item?.isEmbed)
        }
    }
    
    func updateContent() {
        self.userHeaderView.updateContent()
        guard let item = self.currentInfo else {return}
        // Title
        self.lblTitle.text = item.title
        // Squad
        self.squadView.isActionAllowed = !item.completed
        self.squadView.updateContent(scheme: item.scheme, items: item.items)
        // Ads
        self.adsBackView.backgroundColor = item.bannerItem?.backColor ?? UIColor.clear
        self.ivAds.setServerImage(urlString: item.bannerItem?.imageUrl ?? "")
    }
    
    
    
    // MARK: - Super Methods
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.updateContent()
    }
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Close
        self.view.addSubview(self.btnClose)
        self.btnClose.addHeightConstraint(40)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 20)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        // Confirm
        self.view.addSubview(self.btnConfirm)
        self.view.addCenterXAlignmentConstraintTo(subView: self.btnConfirm, constant: 0)
        self.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: self.btnConfirm, constant: -20)
        self.btnConfirm.addHeightConstraint(50)
        self.btnConfirm.addWidthConstraint(320)
        // Container
        self.view.addSubview(self.containerView)
        self.view.addVerticalSpacingTo(subView1: self.btnClose, subView2: self.containerView, constant: 20)
        self.view.addVerticalSpacingTo(subView1: self.containerView, subView2: self.btnConfirm, constant: 25)
        self.view.addLeadingAlignmentConstraintTo(subView: self.containerView, constant: 10)
        self.view.addTrailingAlignmentConstraintTo(subView: self.containerView, constant: -10)
        // Background
        self.containerView.addSubview(self.ivBackground)
        self.containerView.addFullBoundsConstraintsTo(subView: self.ivBackground, constant: 0)
        // Squad
        self.containerView.addSubview(self.squadView)
        self.containerView.addBoundsConstraintsTo(subView: self.squadView, leading: 0, trailing: 0, top: nil, bottom: nil)
        // Title
        self.containerView.addSubview(self.lblTitle)
        self.containerView.addBoundsConstraintsTo(subView: self.lblTitle, leading: 10, trailing: -10, top: nil, bottom: nil)
        self.lblTitle.addHeightConstraint(25)
        // user Header
        self.containerView.addSubview(self.userHeaderView)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.userHeaderView, constant: 0)
        self.containerView.addVerticalSpacingTo(subView1: self.userHeaderView, subView2: self.lblTitle, constant: 8)
        // Ads
        self.containerView.addSubview(self.adsBackView)
        self.containerView.addBoundsConstraintsTo(subView: self.adsBackView, leading: 0, trailing: 0, top: 0, bottom: nil)
        self.containerView.addVerticalSpacingTo(subView1: self.adsBackView, subView2: self.userHeaderView, constant: 15)
        self.adsBackView.addSubview(self.ivAds)
        // Icons
        self.containerView.addSubview(self.iconsStackView)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.iconsStackView, constant: 0)
        self.iconsStackView.addArrangedSubview(self.ivIcon0)
        self.iconsStackView.addArrangedSubview(self.ivIcon1)
        self.containerView.addConstraint(NSLayoutConstraint(item: self.ivIcon0, attribute: .height, relatedBy: .equal, toItem: self.ivIcon0, attribute: .width, multiplier: 0.29, constant: 0))
        self.containerView.addWidthRelatedConstraintTo(subView: self.ivIcon1, reference: self.ivIcon0)
        // Footer
        self.containerView.addSubview(self.lblFooter)
        self.containerView.addBoundsConstraintsTo(subView: self.lblFooter, leading: 10, trailing: -10, top: nil, bottom: nil)
        self.containerView.addVerticalSpacingTo(subView1: self.lblFooter, subView2: self.iconsStackView, constant: 10)
        self.lblFooter.addHeightConstraint(20)
        // Logo
        self.containerView.addSubview(self.ivLogo)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.ivLogo, constant: 0)
        
        if UIScreen.main.bounds.width <= 375 {
            self.adsBackView.addHeightConstraint(50)
            self.containerView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.squadView, constant: 3)
            self.ivLogo.addWidthConstraint(45)
            self.ivLogo.addHeightConstraint(45)
            self.iconsStackView.addHeightConstraint(25)
            self.containerView.addBottomAlignmentConstraintTo(subView: self.iconsStackView, constant: -10)
            self.containerView.addVerticalSpacingTo(subView1: self.ivLogo, subView2: self.lblFooter, constant: 5)
            self.containerView.addVerticalSpacingTo(subView1: self.squadView, subView2: self.ivLogo, constant: 15)
            self.adsBackView.addFullBoundsConstraintsTo(subView: self.ivAds, constant: 5)
        } else {
            self.adsBackView.addHeightConstraint(60)
            self.containerView.addVerticalSpacingTo(subView1: self.lblTitle, subView2: self.squadView, constant: 8)
            self.ivLogo.addWidthConstraint(60)
            self.ivLogo.addHeightConstraint(60)
            self.iconsStackView.addHeightConstraint(30)
            self.containerView.addBottomAlignmentConstraintTo(subView: self.iconsStackView, constant: -20)
            self.containerView.addVerticalSpacingTo(subView1: self.ivLogo, subView2: self.lblFooter, constant: 10)
            self.containerView.addVerticalSpacingTo(subView1: self.squadView, subView2: self.ivLogo, constant: 20)
            self.adsBackView.addFullBoundsConstraintsTo(subView: self.ivAds, constant: 5)
        }
        
    }
    
}












class SquadShareUserHeaderView: UIView {
    
    // MARK: - Properties
    let btnAvatar:AvatarButton = {
        let btn = AvatarButton()
        btn.isUserInteractionEnabled = false
        return btn
    }()
    private let infoStackView:UIStackView = {
        let vw = UIStackView()
        vw.axis = .vertical
        vw.alignment = .fill
        vw.distribution = .fill
        vw.spacing = 0
        return vw
    }()
    private let lblTitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 14)
        lbl.textColor = Theme.color(.PrimaryText)
        return lbl
    }()
    private let lblSubtitle:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Helvetica.Bold, size: 12)
        lbl.textColor = Theme.color(.MutedText)
        return lbl
    }()
    
    
    
    
    
    
    // MARK: - Methods
    func updateContent() {
        guard let user = ServerManager.shared.user else {return}
        self.btnAvatar.updateWithCurrentUserImage()
        self.lblTitle.text = user.name
        self.lblSubtitle.text = user.membershipTitle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.btnAvatar.layer.cornerRadius = self.btnAvatar.frame.height/2
    }
    
    
    
    // MARK: - Init Methods
    private func prepareElements() {
        self.backgroundColor = UIColor.clear
        // Avatar
        self.addSubview(self.btnAvatar)
        self.addBoundsConstraintsTo(subView: self.btnAvatar, leading: 0, trailing: nil, top: 0, bottom: 0)
        let size:CGFloat = UIScreen.main.bounds.width <= 375 ? 30.0 : 45.0
        self.btnAvatar.addHeightConstraint(size)
        self.btnAvatar.addWidthConstraint(size)
        // Infos
        self.addSubview(self.infoStackView)
        self.addTrailingAlignmentConstraintTo(subView: self.infoStackView, constant: 0)
        self.addHorizontalSpacingTo(subView1: self.btnAvatar, subView2: self.infoStackView, constant: 10)
        self.addCenterYAlignmentRelatedConstraintTo(subView: self.infoStackView, reference: self.btnAvatar, constant: 0)
        self.infoStackView.addArrangedSubview(self.lblTitle)
        self.infoStackView.addArrangedSubview(self.lblSubtitle)
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



