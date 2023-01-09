//
//  HomeTabBarController.swift
//  
//
//  Created by Roberto Oliveira on 14/11/2017.
//  Copyright © 2017 Roberto Oliveira. All rights reserved.
//

import UIKit
import UserNotifications

class EmptyViewController: BaseStackViewController {}

class HomeTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    private let isCenterIconModeEnabled:Bool = true
    private let centerLogoNameActive:String = "tab_icon_club_home"
    private let centerLogoNameInactive:String = "tab_icon_club_home"
    
    // MARK: - Objects
    var homeVc = HomeViewController()
    var videosVc = VideosViewController()
    var clubHomeVc = ClubHomeViewController()
    var coinsVc = QuestionsHomeViewController()
    var menuVc = MenuViewController()
    
    
    
    
    // MARK: - Super methods
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        ServerManager.shared.setTrack(trackEvent: item.tag, trackValue: nil)
    }
    
    var customSelectedTabIndex:Int = 0 {
        didSet {
            if oldValue == 0 && self.customSelectedTabIndex == 0 {
                self.homeVc.scrollView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.customSelectedTabIndex = tabBarController.viewControllers?.firstIndex(of: viewController) ?? self.customSelectedTabIndex
        if self.isCenterIconModeEnabled {
            // center logo
            var centerImage = self.centerLogoNameInactive
            if self.customSelectedTabIndex == 2 {
                centerImage = self.centerLogoNameActive
            }
            self.menuButton.setImage(UIImage(named: centerImage), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Register for Pushs
        self.setupPushNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handlePushNotificationInfo()
    }
    
    
    

    // MARK: - Init methods
    func prepareElements() {
        self.loadViewIfNeeded()
        // Scroll Insets
        //self.automaticallyAdjustsScrollViewInsets = false
        
        // Tab Bar Colors
        self.tabBar.tintColor = Theme.color(.TabBarSelected) // Tab Bar Active Color
        self.tabBar.barTintColor = Theme.color(.TabBarBackground) // Tab Bar back Color
        self.tabBar.isTranslucent = false
        self.tabBar.unselectedItemTintColor = Theme.color(.TabBarUnselected)
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = self.tabBar.barTintColor
            appearance.stackedLayoutAppearance.normal.iconColor = self.tabBar.unselectedItemTintColor
            appearance.stackedLayoutAppearance.selected.iconColor = self.tabBar.tintColor
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
        }
        
        
        // Navigation Bar Colors
        UINavigationBar.appearance().barTintColor = UIColor.white // Background Color
        UINavigationBar.appearance().tintColor = UIColor(R: 50, G: 50, B: 50) // Back Button Color
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font : FontsManager.customFont(key: FontsManager.Avenir.Heavy, size: 18),
            NSAttributedString.Key.foregroundColor:UIColor(R: 50, G: 50, B: 50),
        ] // Title Colorsbutetitle
        
        // Root Controllers
        
        // Home --------
        self.homeVc.tabBarItem.title = "Início"
        if self.isCenterIconModeEnabled {
            self.homeVc.tabBarItem.image = UIImage(named: "tab_icon_1")
            self.homeVc.tabBarItem.selectedImage = UIImage(named: "tab_icon_1")
        } else {
            self.homeVc.tabBarItem.image = UIImage(named: "tab_icon_1")
            self.homeVc.tabBarItem.selectedImage = UIImage(named: "tab_icon_1")
        }
        self.homeVc.tabBarItem.tag = EventTrack.Home.homeTabMenu
        let homeNav = NavigationController(rootViewController: self.homeVc)
        homeNav.navigationBar.isTranslucent = false
        homeNav.navigationBar.isHidden = true
        // -----------------------------------
        
        
        // 1 Questions --------
        self.coinsVc.tabBarItem.title = "Interações"
        if self.isCenterIconModeEnabled {
            self.coinsVc.tabBarItem.image = UIImage(named: "tab_icon_2")
            self.coinsVc.tabBarItem.selectedImage = UIImage(named: "tab_icon_2")
        } else {
            self.coinsVc.tabBarItem.image = UIImage(named: "tab_icon_2")
            self.coinsVc.tabBarItem.selectedImage = UIImage(named: "tab_icon_2")
        }
        self.coinsVc.tabBarItem.tag = EventTrack.HomeQuestions.homeQuestionsTabMenu
        let coinsNav = NavigationController(rootViewController: self.coinsVc)
        coinsNav.navigationBar.isTranslucent = false
        coinsNav.navigationBar.isHidden = true
        // -----------------------------------
        
        
        // 2 Club --------
        self.clubHomeVc.tabBarItem.title = ""
        if self.isCenterIconModeEnabled {
            self.clubHomeVc.tabBarItem.image = nil
            self.clubHomeVc.tabBarItem.selectedImage = nil
            self.setupMiddleButton()
        } else {
            self.clubHomeVc.tabBarItem.image = UIImage(named: "tab_icon_club_home")
            self.clubHomeVc.tabBarItem.selectedImage = UIImage(named: "tab_icon_club_home")
        }
        self.clubHomeVc.tabBarItem.tag = EventTrack.ClubHome.clubHomeTabMenu
        let clubHomeNav = NavigationController(rootViewController: self.clubHomeVc)
        clubHomeNav.navigationBar.isTranslucent = false
        clubHomeNav.navigationBar.isHidden = true
        // -----------------------------------
        
        
        // 3 Videos --------
        self.videosVc.tabBarItem.title = "Vídeos"
        if self.isCenterIconModeEnabled {
            self.videosVc.tabBarItem.image = UIImage(named: "tab_icon_3")
            self.videosVc.tabBarItem.selectedImage = UIImage(named: "tab_icon_3")
        } else {
            self.videosVc.tabBarItem.image = UIImage(named: "tab_icon_1")
            self.videosVc.tabBarItem.selectedImage = UIImage(named: "tab_icon_3")
        }
        self.videosVc.tabBarItem.tag = EventTrack.Videos.tabMenu
        let videosNav = NavigationController(rootViewController: self.videosVc)
        videosNav.navigationBar.isTranslucent = false
        videosNav.navigationBar.isHidden = true
        // -----------------------------------
        
        
        // 4 Menu --------
        self.menuVc.tabBarItem.title = "Menu"
        if self.isCenterIconModeEnabled {
            self.menuVc.tabBarItem.image = UIImage(named: "tab_icon_6")
            self.menuVc.tabBarItem.selectedImage = UIImage(named: "tab_icon_6")
        } else {
            self.menuVc.tabBarItem.image = UIImage(named: "tab_icon_6")
            self.menuVc.tabBarItem.selectedImage = UIImage(named: "tab_icon_6")
        }
        self.menuVc.tabBarItem.tag = EventTrack.Menu.menuTabMenu
        let menuNav = NavigationController(rootViewController: self.menuVc)
        menuNav.navigationBar.isTranslucent = false
        menuNav.navigationBar.isHidden = true
        // -----------------------------------
        

        self.viewControllers = [homeNav, videosNav, clubHomeNav, coinsNav, menuNav]
        
        self.selectedIndex = 0
        
    }
        
    func indexForReference(_ ref:UIViewController) -> Int {
        var vc = ref
        if let nav = ref.navigationController {
            vc = nav
        }
        return self.viewControllers?.firstIndex(of: vc) ?? 0
    }
    
    
    // MARK: - Center Button
    private let menuButton = CustomButton()
    private func setupMiddleButton() {
        var buttonSize:CGFloat = 70.0
        var centerLogoPadding:CGFloat = 8.0
        var centerLogoY:CGFloat = 45.0
        let screenWIDTH = UIScreen.main.bounds.width
        print("screenWIDTH \(screenWIDTH)")
        if screenWIDTH >= 900 {
            buttonSize = 95.0
            centerLogoPadding = 10.0
            centerLogoY = 45.0
        }
        if screenWIDTH == 420 {
            buttonSize = 75.0
            centerLogoPadding = 10.0
            centerLogoY = 55.0
        }
        if screenWIDTH <= 375 {
            buttonSize = 65.0
            centerLogoPadding = 8.0
            centerLogoY = 25.0
        }
        if screenWIDTH <= 320 {
            // 5s only
            buttonSize = 60.0
            centerLogoPadding = 8.0
            centerLogoY = 10.0
        }
//        let buttonSize:CGFloat = 65.0
//        let centerLogoPadding:CGFloat = 6.0
//        let centerLogoY:CGFloat = 7.0
        
        menuButton.backgroundColor = UIColor.clear
        menuButton.highlightedAlpha = 1.0
        menuButton.highlightedScale = 1.0
        menuButton.adjustsAlphaWhenHighlighted = false
        
        if let iv = self.menuButton.imageView {
            self.menuButton.addFullBoundsConstraintsTo(subView: iv, constant: centerLogoPadding)
        }
        menuButton.layer.cornerRadius = buttonSize/2
        
        self.menuButton.setImage(UIImage(named: self.centerLogoNameInactive), for: .normal)
        menuButton.imageView?.contentMode = .scaleAspectFit
        
        
        
        self.view.addSubview(self.menuButton)
        self.view.addCenterXAlignmentConstraintTo(subView: self.menuButton, constant: 0)
        self.menuButton.addSquareSizeConstraint(buttonSize)
        let bottomSafeSpace:CGFloat = DeviceManager.shared.defaultSafeAreaInsets.bottom
        let buttonY:CGFloat = UIScreen.main.bounds.height - bottomSafeSpace - self.tabBar.bounds.height - centerLogoY
        self.view.addTopAlignmentConstraintTo(subView: self.menuButton, constant: buttonY)
        
        
        
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        self.view.layoutIfNeeded()
    }
    
    
    
    
    
    @objc private func menuButtonAction(sender: UIButton) {
        if self.isCenterIconModeEnabled {
            ServerManager.shared.setTrack(trackEvent: self.clubHomeVc.tabBarItem.tag, trackValue: nil)
        } else {
            ServerManager.shared.setTrack(trackEvent: self.coinsVc.tabBarItem.tag, trackValue: nil)
        }
        DispatchQueue.main.async {
            if self.selectedIndex == 2 {
                // if is already there, pop to root
                self.clubHomeVc.navigationController?.popToRootViewController(animated: true)
            }
            self.selectedIndex = 2
            self.customSelectedTabIndex = self.selectedIndex
            self.menuButton.setImage(UIImage(named: self.centerLogoNameActive), for: .normal)
        }
    }
    
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.prepareElements()
        print("screen size \(UIScreen.main.bounds.width)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareElements()
    }
    
}
