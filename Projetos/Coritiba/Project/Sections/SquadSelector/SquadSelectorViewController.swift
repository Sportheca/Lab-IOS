//
//  SquadSelectorViewController.swift
//  
//
//  Created by Roberto Oliveira on 05/02/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

protocol SquadSelectorViewControllerDelegate:AnyObject {
    func squadSelectorViewController(didCompleteSquadWith squadSelectorViewController:SquadSelectorViewController)
}

class SquadSelectorViewController: BaseViewController, SquadSchemeSelectorViewDelegate, SquadSelectorViewDelegate {
    
    // MARK: - Properties
    weak var delegate:SquadSelectorViewControllerDelegate?
    var currentInfo:SquadSelectorInfo?
    private var listSelectorDataSource:[SquadSelectorListItem] = []
    private var selectedPosition:Int?
    var trackEvent:Int?
    
    // MARK: - Objects
    private let containerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor(hexString: "1D1D1D")
        vw.layer.cornerRadius = 15.0
        vw.layer.borderWidth = 1.0
        vw.layer.borderColor = UIColor.white.cgColor
        return vw
    }()
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private let lblHeader:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .center
        lbl.font = FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 15)
        lbl.textColor = Theme.color(.PrimaryCardElements)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        return lbl
    }()
    private lazy var schemeSelectorView:SquadSchemeSelectorView = {
        let vw = SquadSchemeSelectorView()
        vw.delegate = self
        return vw
    }()
    private lazy var squadView:SquadSelectorView = {
        let vw = SquadSelectorView()
        vw.delegate = self
        return vw
    }()
    private lazy var btnConfirm:CustomButton = {
        let btn = CustomButton()
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.setTitleColor(Theme.color(.PrimaryButtonText), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Bold, size: 12)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10.0
        btn.setTitle("CONCLUIR", for: .normal)
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.confirm), for: .touchUpInside)
        return btn
    }()
    private lazy var btnShare:IconButton = {
        let btn = IconButton(iconLeading: 20, iconTop: 3, iconBottom: -3, horizontalSpacing: 5, titleTrailing: -20, titleTop: 0, titleBottom: 0)
        btn.lblTitle.font = FontsManager.customFont(key: FontsManager.Roboto.Medium, size: 12)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5.0
        btn.updateContent(icon: UIImage(named: "icon_share")?.withRenderingMode(.alwaysTemplate), title: "Compartilhar")
        btn.backgroundColor = Theme.color(.PrimaryButtonBackground)
        btn.lblTitle.textColor = Theme.color(.PrimaryButtonText)
        btn.ivIcon.tintColor = Theme.color(.PrimaryButtonText)
        btn.adjustsAlphaWhenHighlighted = false
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.share), for: .touchUpInside)
        return btn
    }()
    
    
    
    // MARK: - Methods
    @objc func share() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.SquadSelector.share, trackValue: self.currentInfo?.id)
        DispatchQueue.main.async {
            let vc = SquadSelectorShareViewController()
            vc.currentInfo = self.currentInfo
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func confirm() {
        guard let item = self.currentInfo else {return}
        for (_, obj) in item.items {
            if obj == nil {
                DispatchQueue.main.async {
                    self.basicAlert(message: "Selecione todos os jogadores antes de enviar!", handler: nil)
                }
                return
            }
        }
        DispatchQueue.main.async {
            self.loadingView.startAnimating()
            self.containerView.isHidden = true
        }
        ServerManager.shared.setSquadSelectorInfo(item: item, trackEvent: nil) { (success:Bool?, message:String?) in
            DispatchQueue.main.async {
                self.delegate?.squadSelectorViewController(didCompleteSquadWith: self)
                self.updateContent()
                self.loadingView.stopAnimating()
                self.containerView.isHidden = false
            }
        }
    }
    
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.SquadSelector.tryAgain
        self.loadContent()
    }
    
    private func loadContent() {
        DispatchQueue.main.async {
            self.loadingView.startAnimating()
            self.containerView.isHidden = true
        }
        ServerManager.shared.getSquadSelectorInfo(item:self.currentInfo, trackEvent: self.trackEvent) { (success:Bool?) in
            self.trackEvent = nil
            DispatchQueue.main.async {
                if success == true {
                    self.updateContent()
                    self.loadingView.stopAnimating()
                    self.containerView.isHidden = false
                    self.addAdvertiserBannerToCardContainerVc()
                } else {
                    self.loadingView.emptyResults()
                }
            }
        }
    }
    
    func addAdvertiserBannerToCardContainerVc() {
        guard let vc = self.parent?.parent as? CardContainerViewController else {return}
        let vw = UIView()
        vw.isUserInteractionEnabled = true
        vw.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openBannerLink)))
        vw.backgroundColor = self.currentInfo?.bannerItem?.backColor ?? UIColor.clear
        vc.view.addSubview(vw)
        vc.cardView.layer.cornerRadius = 0.0
        vc.view.addBoundsConstraintsTo(subView: vw, leading: 0, trailing: 0, top: nil, bottom: 0)
        let iv = ServerImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.clear
        vw.addSubview(iv)
        iv.setServerImage(urlString: self.currentInfo?.bannerItem?.imageUrl)
        if UIScreen.main.bounds.width <= 375 {
            vw.addFullBoundsConstraintsTo(subView: iv, constant: 5)
        } else {
            vw.addBoundsConstraintsTo(subView: iv, leading: 10, trailing: -10, top: 5, bottom: nil)
            let bottom:CGFloat = UIApplication.shared.safeAreaInsets().bottom == 0 ? -10 : 0
            vc.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: iv, constant: bottom)
        }
        vc.view.addVerticalSpacingTo(subView1: vc.cardView, subView2: vw, constant: 20)
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
        guard let item = self.currentInfo else {return}
        // Title
        self.lblHeader.text = item.title
        // Scheme
        self.schemeSelectorView.updateContent(selectedScheme: item.scheme)
        // Squad
        self.squadView.isActionAllowed = !item.completed
        self.squadView.updateContent(scheme: item.scheme, items: item.items)
        // Confirm
        self.containerView.isUserInteractionEnabled = !item.completed
        self.btnConfirm.alpha = item.completed ? 0.5 : 1.0
        self.btnShare.isHidden = !item.completed
    }
    
    func squadSchemeSelectorView(squadSchemeSelectorView: SquadSchemeSelectorView, didSelectScheme scheme: SquadScheme) {
        ServerManager.shared.setTrack(trackEvent: EventTrack.SquadSelector.selectScheme, trackValue: scheme.rawValue)
        self.currentInfo?.scheme = scheme
        self.squadView.changeSquadScheme(scheme: scheme, animated: true)
    }
    
    func squadSelectorView(squadSelectorView: SquadSelectorView, didRemoveItemAt position: Int) {
        guard let item = self.currentInfo else {return}
        ServerManager.shared.setTrack(trackEvent: EventTrack.SquadSelector.removeItem, trackValue: position)
        item.removeItemAt(position: position)
        self.squadView.updateContent(scheme: item.scheme, items: item.items)
    }
    
    func squadSelectorView(squadSelectorView: SquadSelectorView, didSelectAddAt position: Int) {
        guard let item = self.currentInfo else {return}
        ServerManager.shared.setTrack(trackEvent: EventTrack.SquadSelector.addItem, trackValue: position)
        self.selectedPosition = position
        DispatchQueue.main.async {
            let vc = SquadSelectorItemsListViewController()
            vc.referenceID = item.id
            vc.extendedLayoutIncludesOpaqueBars = true
            vc.edgesForExtendedLayout = [.all]
            vc.lblHeader.text = self.lblHeader.text
            vc.dataSource = self.listSelectorDataSource
            var selectedIds:[Int] = []
            for (_,obj) in item.items {
                guard let id = obj?.id else {continue}
                selectedIds.append(id)
            }
            vc.selectedIds = selectedIds
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    // MARK: - Super Methods
    override func firstTimeViewWillAppear() {
        super.firstTimeViewWillAppear()
        self.updateContent()
        self.loadContent()
    }
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        self.view.clipsToBounds = true
        self.view.backgroundColor = .clear
        // Container
        self.view.addSubview(self.containerView)
        self.view.addBoundsConstraintsTo(subView: self.containerView, leading: 0, trailing: 0, top: 0, bottom: 0)
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        // Confirm
        self.containerView.addSubview(self.btnConfirm)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.btnConfirm, constant: 0)
        self.containerView.addBottomAlignmentConstraintTo(subView: self.btnConfirm, constant: -8)
        self.btnConfirm.addWidthConstraint(230)
        self.btnConfirm.addHeightConstraint(35)
        // Squad
        self.containerView.addSubview(self.squadView)
        self.containerView.addCenterXAlignmentConstraintTo(subView: self.squadView, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: self.squadView, attribute: .width, relatedBy: .equal, toItem: self.squadView, attribute: .height, multiplier: 0.69, constant: 0)
        widthConstraint.priority = UILayoutPriority(900)
        self.view.addConstraint(widthConstraint)
        self.containerView.addLeadingAlignmentConstraintTo(subView: self.squadView, relatedBy: .greaterThanOrEqual, constant: 10, priority: 999)
        self.containerView.addTrailingAlignmentConstraintTo(subView: self.squadView, relatedBy: .lessThanOrEqual, constant: -10, priority: 999)
        self.containerView.addVerticalSpacingTo(subView1: self.squadView, subView2: self.btnConfirm, constant: 8)
        // Header
        self.containerView.addSubview(self.lblHeader)
        self.containerView.addBoundsConstraintsTo(subView: self.lblHeader, leading: 10, trailing: -10, top: 55, bottom: nil)
        self.lblHeader.addHeightConstraint(23)
        // Schemes
        self.containerView.addSubview(self.schemeSelectorView)
        self.containerView.addVerticalSpacingTo(subView1: self.lblHeader, subView2: self.schemeSelectorView, constant: 5)
        self.containerView.addBoundsConstraintsTo(subView: self.schemeSelectorView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.containerView.addVerticalSpacingTo(subView1: self.schemeSelectorView, subView2: self.squadView, constant: 8)
        // Share
        self.view.addSubview(self.btnShare)
        self.view.addBoundsConstraintsTo(subView: self.btnShare, leading: nil, trailing: -20, top: 20, bottom: nil)
        self.btnShare.addHeightConstraint(20)
        self.btnShare.isHidden = true
    }
    
}




extension SquadSelectorViewController: SquadSelectorItemsListViewControllerDelegate {
    
    func squadSelectorItemsListViewController(squadSelectorItemsListViewController: SquadSelectorItemsListViewController, didSelectItem item: SquadSelectorListItem) {
        DispatchQueue.main.async {
            guard let object = self.currentInfo, let position = self.selectedPosition else {return}
            for (i, obj) in object.items {
                if obj?.id == item.id {
                    object.removeItemAt(position: i)
                }
            }
            object.items[position] = SquadSelectorItem(id: item.id, title: item.title, description: nil, imageUrl: item.imageUrl)
            self.squadView.updateContent(scheme: object.scheme, items: object.items)
        }
    }
    
    func squadSelectorItemsListViewController(squadSelectorItemsListViewController: SquadSelectorItemsListViewController, didFinishLoadItems items: [SquadSelectorListItem]) {
        self.listSelectorDataSource = items
    }
    
}




