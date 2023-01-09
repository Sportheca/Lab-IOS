//
//  MenuViewController.swift
//
//
//  Created by Roberto Oliveira on 17/01/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

enum MenuType {
    case Membership
    case UserProfile
    case Ranking
    case Store
    case Settings
    case Logout
    case AudioLibrary
    case DynamicItem
    case ShopGallery
    case Debug
}

struct MenuItem {
    var id:Int
    var type:MenuType
    var title:String
    var iconName:String
    var isIconLarge:Bool
    
    var imageUrlString:String?
    var link:String?
    var isEmbed:WebContentPresentationMode
    var deeplink:PushNotification?
}


struct MenuSection {
    var backgroundColor1:UIColor
    var backgroundColor2:UIColor
    var elementsColor:UIColor
    var isColapsable:Bool
    var headerTitle:String?
    var headerImageName:String?
    var items:[MenuItem]
}

class MenuViewController: BaseViewController, MenuViewDelegate {
    
    // MARK: - Objects
    private lazy var headerView:MenuHeaderView = {
        let vw = MenuHeaderView()
        vw.btnAvatar.addTarget(self, action: #selector(self.avatarMethod), for: .touchUpInside)
        return vw
    }()
    private lazy var contentView:MenuView = {
        let vw = MenuView()
        vw.delegate = self
        return vw
    }()
    private let loadingView:ContentLoadingView = ContentLoadingView()
    private let lblVersion:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textAlignment = .left
        lbl.font = FontsManager.customFont(key: FontsManager.Roboto.Regular, size: 11)
        lbl.textColor = Theme.color(.MutedText)
        lbl.text = "Versão: " + (String.stringValue(from: Bundle.main.infoDictionary?["CFBundleShortVersionString"]) ?? "")
        return lbl
    }()
    
    
    
    // MARK: - Methods
    private func loadContent() {
        DispatchQueue.main.async {
            if self.contentView.dataSource.isEmpty {
                self.loadingView.startAnimating()
            }
        }
        ServerManager.shared.getMenuDynamicItems(trackEvent: nil) { (objects:[MenuItem]?) in
            var sections:[MenuSection] = []
            
            // Membership Items
//            let memberShipItems:[MenuItem] = [
//                MenuItem(id: 0, type: .Membership, title: "", iconName: "menu_membership_section", isIconLarge: true, imageUrlString: nil, link: nil, isEmbed: false, deeplink: nil),
//            ]
//            let memberShipSection = MenuSection(backgroundColor1: UIColor(R: 235, G: 198, B: 66), backgroundColor2: UIColor(R: 216, G: 174, B: 43), elementsColor: Theme.color(.PrimaryButtonText), isColapsable: false, headerTitle: nil, headerImageName: nil, items: memberShipItems)
//            sections.append(memberShipSection)
            
            // Debug
//            let debugSection = MenuSection(backgroundColor1: Theme.systemDestructiveColor, backgroundColor2: Theme.systemDestructiveColor, elementsColor: UIColor.white, isColapsable: false, headerTitle: nil, headerImageName: nil, items: [MenuItem(id: 0, type: .Debug, title: "Debug Manager", iconName: "side_menu_0", isIconLarge: false, imageUrlString: nil, link: nil, isEmbed: false, deeplink: nil)])
//            if DebugManager.isDebugModeEnabled {
//                sections.append(debugSection)
//            }
            
            // Menu Items
            let logoutTitle = ServerManager.shared.isUserRegistered() ? "Sair" : "Entrar com Outra Conta"
            var menuItems = [
                MenuItem(id: 0, type: .UserProfile, title: "Perfil", iconName: "side_menu_1", isIconLarge: false, imageUrlString: nil, link: nil, isEmbed: WebContentPresentationMode.DefaultEmbed, deeplink: nil),
                MenuItem(id: 0, type: .Ranking, title: "Ranking", iconName: "side_menu_2", isIconLarge: false, imageUrlString: nil, link: nil, isEmbed: WebContentPresentationMode.DefaultEmbed, deeplink: nil),
                MenuItem(id: 0, type: .Store, title: "Resgates", iconName: "side_menu_10", isIconLarge: false, imageUrlString: nil, link: nil, isEmbed: WebContentPresentationMode.DefaultEmbed, deeplink: nil),
                MenuItem(id: 0, type: .AudioLibrary, title: "Áudios", iconName: "side_menu_7", isIconLarge: false, imageUrlString: nil, link: nil, isEmbed: WebContentPresentationMode.DefaultEmbed, deeplink: nil),
                MenuItem(id: 0, type: .ShopGallery, title: ProjectInfoManager.TextInfo.loja_titulo.rawValue, iconName: "side_menu_3", isIconLarge: false, imageUrlString: nil, link: nil, isEmbed: WebContentPresentationMode.DefaultEmbed, deeplink: nil),
                MenuItem(id: 0, type: .Settings, title: "Configurações", iconName: "side_menu_5", isIconLarge: false, imageUrlString: nil, link: nil, isEmbed: WebContentPresentationMode.DefaultEmbed, deeplink: nil),
                MenuItem(id: 0, type: .Logout, title: logoutTitle, iconName: "side_menu_6", isIconLarge: false, imageUrlString: nil, link: nil, isEmbed: WebContentPresentationMode.DefaultEmbed, deeplink: nil),
            ]
            // Dynamic Menu Items
            let items = objects ?? []
            for (i, item) in items.enumerated() {
                menuItems.insert(item, at: i)
            }
            
            let defaultSection = MenuSection(backgroundColor1: UIColor.clear, backgroundColor2: UIColor.clear, elementsColor: Theme.color(.PrimaryText), isColapsable: false, headerTitle: nil, headerImageName: nil, items: menuItems)
            sections.append(defaultSection)
            
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.contentView.updateContent(items: sections)
            }
        }
    }
    
    @objc func avatarMethod() {
        self.showUserProfile(trackEvent: EventTrack.Menu.profileAvatar)
    }
    
    private func showUserProfile(trackEvent:Int?) {
        ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
            guard confirmed else {return}
            DispatchQueue.main.async {
                let vc = UserProfileViewController()
                vc.badgesTrackEvent = trackEvent
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func didSelect(item: MenuItem) {
        guard let nav = self.navigationController else {return}
        switch item.type {
        case .UserProfile:
            DispatchQueue.main.async {
                self.showUserProfile(trackEvent: EventTrack.Menu.profile)
            }
            break
        case .Membership:
            //ServerManager.shared.setTrack(trackEvent: EventTrack.Menu.membership, trackValue: nil)
            //MembershipHomeViewController.present()
            break
            
        case .Debug:
            DispatchQueue.main.async {
                let vc = DebugViewController()
                nav.pushViewController(vc, animated: true)
            }
            break
            
        case .Settings:
            ServerManager.shared.setTrack(trackEvent: EventTrack.Menu.settings, trackValue: nil)
            DispatchQueue.main.async {
                let vc = SettingsViewController()
                nav.pushViewController(vc, animated: true)
            }
            break
        case .Ranking:
            ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
                guard confirmed else {return}
                DispatchQueue.main.async {
                    let vc = RankingsViewController()
                    vc.trackEvent = EventTrack.Menu.ranking
                    let nav = NavigationController(rootViewController: vc)
                    nav.isNavigationBarHidden = true
                    nav.isDarkStatusBarStyle = false
                    nav.modalPresentationStyle = .fullScreen
                    nav.modalTransitionStyle = .coverVertical
                    self.present(nav, animated: true, completion: nil)
                }
            }
            break
        case .Store:
            ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
                guard confirmed else {return}
                DispatchQueue.main.async {
                    let vc = StoreHomeViewController()
                    vc.trackEvent = EventTrack.Menu.store
                    let nav = NavigationController(rootViewController: vc)
                    nav.isNavigationBarHidden = true
                    nav.isDarkStatusBarStyle = false
                    nav.modalPresentationStyle = .fullScreen
                    nav.modalTransitionStyle = .coverVertical
                    self.present(nav, animated: true, completion: nil)
                }
            }
            break
            
        case .AudioLibrary:
            DispatchQueue.main.async {
                let vc = AudioLibraryGroupViewController()
                vc.trackEvent = EventTrack.Menu.audioLibrary
                let nav = NavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                nav.isDarkStatusBarStyle = false
                nav.modalPresentationStyle = .fullScreen
                nav.modalTransitionStyle = .coverVertical
                self.present(nav, animated: true, completion: nil)
            }
            break
            
        case .Logout:
            ServerManager.shared.setTrack(trackEvent: EventTrack.Menu.logout, trackValue: nil)
            DispatchQueue.main.async {
                self.questionAlert(title: "Tem certeza que deseja sair?", message:  "Você poderá entrar novamente em sua conta utilizando seu email e senha") { (answer:Bool) in
                    if answer {
                        ServerManager.shared.setTrack(trackEvent: EventTrack.Menu.logoutYes, trackValue: nil)
                        // Reset Users Properties and Dimsiss to Login/Splash vc
                        DispatchQueue.main.async {
                            UIApplication.shared.forceLogout()
                        }
                    } else {
                        ServerManager.shared.setTrack(trackEvent: EventTrack.Menu.logoutNo, trackValue: nil)
                    }
                }
            }
            break
            
        case .DynamicItem:
            ServerManager.shared.setTrack(trackEvent: EventTrack.Menu.DynamicCTA, trackValue: item.id)
            DispatchQueue.main.async {
                if let deeplink = item.deeplink {
                    UIApplication.shared.performPushNotificationDeeplink(for: deeplink, fromNotificationCentral: false)
                    return
                }
                let urlString = item.link ?? ""
                DispatchQueue.main.async {
                    BaseWebViewController.open(urlString: urlString, mode: item.isEmbed)
                }
            }
            return
            
        case .ShopGallery:
            DispatchQueue.main.async {
                let vc = ShopGalleryViewController()
                vc.trackEvent = EventTrack.Menu.openShopGallery
                let nav = NavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                nav.isDarkStatusBarStyle = false
                nav.modalPresentationStyle = .fullScreen
                nav.modalTransitionStyle = .coverVertical
                self.present(nav, animated: true, completion: nil)
            }
            break
        }
        
    }
    
    
    
    
    // MARK: - Super Methods
    override func prepareElements() {
        super.prepareElements()
        // Header
        self.view.addSubview(self.headerView)
        self.view.addBoundsConstraintsTo(subView: self.headerView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.headerView.addHeightConstraint(180)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.headerView, constant: 0)
        // Content
        self.view.addSubview(self.contentView)
        self.view.addVerticalSpacingTo(subView1: self.headerView, subView2: self.contentView, constant: 0)
        self.view.addBoundsConstraintsTo(subView: self.contentView, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Loading View
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        // Version
        self.view.addSubview(self.lblVersion)
        self.view.addBoundsConstraintsTo(subView: self.lblVersion, leading: 15, trailing: nil, top: nil, bottom: -20)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerView.updateContent()
        self.loadContent()
    }
    
    
}
