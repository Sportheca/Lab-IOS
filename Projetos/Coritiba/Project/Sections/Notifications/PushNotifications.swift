//
//  PushNotifications.swift
//
//
//  Created by Roberto Oliveira on 05/06/2018.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

// Appdelegate request it's PushNotificationDelegate to handle a push notification when received
protocol PushNotificationDelegate {
    func handlePushNotificationInfo()
}

struct PushNotification {
    var type:PushNotificationType
    var id:Int
    var value1:Int?
    var value2:Int?
}

enum PushNotificationType: Int {
    case Default = 0
    
    case VersionControl = 1000
    case ForceCrash = 1001
    case ForceLogout = 1002
    case NewBadges = 1003
    
    case News = 1
    case Quiz = 2
    case Surveys = 3
    case MultipleSurveys = 4
    
    case PlayerProfile = 5
    case Membership = 6
    case Schedule = 7
    case SquadSelector = 8
    case Store = 9
    case SurveySpecificQuestion = 10
    case AudioPlayerItem = 11
    case MatchDetails = 12
    case StoreItem = 13
    case EditProfile = 14
    case Rankings = 15
    case ScheduleItem = 16//idjogo
    case Birthday = 17 // do nothing
    case MembershipCardID = 18 // carteirinha
    case ShopGallery = 19 // Loja
}



// Extension of ViewController to setup PushNotifications and handle deeplinks
extension HomeTabBarController: PushNotificationDelegate {
    
    // Call This method on viewDidLoad to setup pushNotificationDelegate and request Push Notification authorization
    func setupPushNotifications() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        appDelegate.pushNotificationDelegate = self
        appDelegate.tabController = self
    }
    
    // Call this method on viewWillAppear to handle a pushNotification if needed
    func handlePushNotificationInfo() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        guard let info = appDelegate.pushNotificationInfo else {return}
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now()+2.0) {
            appDelegate.pushNotificationInfo = nil // Reset deeplink to nil after handling
        }
        // Create PushNotification object to handle deeplink easier
        guard let pushId = info["idPush"] as? Int, let pushType = PushNotificationType(rawValue: info["t"] as? Int ?? 0) else {return}
        if pushType == .Default {
            appDelegate.pushNotificationInfo = nil
        }
        
        
        let push = PushNotification(type: pushType, id: pushId, value1: (info["v"] as? Int), value2: (info["v2"] as? Int))
        
        // Track push opening if needed
        if let trackId = info["trackId"] as? Int {
            ServerManager.shared.setLogPushOpen(pushId, trackId: trackId)
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.performPushNotificationDeeplink(for: push, fromNotificationCentral: false)
        }
        
    }
    
}




// Extension of UIApplication to finally shows push notification deeplink contents
extension UIApplication {
    func performPushNotificationDeeplink(for push:PushNotification, fromNotificationCentral:Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        appDelegate.tabController?.performPushNotificationDeeplink(for: push, fromNotificationCentral: fromNotificationCentral)
    }
}

extension HomeTabBarController {
    
    func performPushNotificationDeeplink(for push:PushNotification, fromNotificationCentral:Bool) {
        if push.type != .Default && push.type != .VersionControl {
            // --
        }
        
        switch push.type {
        case .MembershipCardID:
            CardIDViewController.present()
            return
            
        case .News:
            DispatchQueue.main.async {
                if !fromNotificationCentral {
                    self.selectedIndex = 0
                }
                let vc = NewsViewController(id: push.value1 ?? 0)
                self.homeVc.navigationController?.pushViewController(vc, animated: true)
            }
            return
            
        case .Quiz:
            DispatchQueue.main.async {
                self.selectedIndex = 3
                self.coinsVc.quizVc.showGroupWithID(push.value1 ?? 0)
                self.coinsVc.setCurrentTab(index: 0)
            }
            return
            
        case .Surveys:
            DispatchQueue.main.async {
                self.selectedIndex = 3
                self.coinsVc.setCurrentTab(index: 1)
            }
            return
            
        case .SurveySpecificQuestion:
            DispatchQueue.main.async {
                if let id = push.value1 {
                    self.coinsVc.surveysVc.loadQuestion(id: id)
                }
                self.selectedIndex = 3
                self.coinsVc.setCurrentTab(index: 1)
            }
            return
            
        case .MultipleSurveys:
            DispatchQueue.main.async {
                self.selectedIndex = 3
                self.coinsVc.setCurrentTab(index: 2)
            }
            return
            
        case .PlayerProfile:
            DispatchQueue.main.async {
                if !fromNotificationCentral {
                    self.selectedIndex = 2
                }
                PlayerProfileViewController.showPlayer(id: push.value1 ?? 0, trackEvent: nil)
            }
            return
            
        case .Membership:
            //MembershipHomeViewController.present()
            return
            
        case .Schedule:
            DispatchQueue.main.async {
                let vc = ScheduleViewController()
                if !fromNotificationCentral {
                    self.selectedIndex = 2
                    self.menuVc.navigationController?.pushViewController(vc, animated: true)
                } else {
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return
            
        case .ScheduleItem:
            DispatchQueue.main.async {
                let vc = ScheduleViewController()
                vc.scrollToItemID = push.value1
                if !fromNotificationCentral {
                    self.selectedIndex = 2
                    self.menuVc.navigationController?.pushViewController(vc, animated: true)
                } else {
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return
            
        case .SquadSelector:
            DispatchQueue.main.async {
                if !fromNotificationCentral {
                    self.selectedIndex = 0
                }
                let selectorVc = SquadSelectorViewController()
                if let id = push.value1 {
                    selectorVc.currentInfo = SquadSelectorInfo(id: id, title: "", scheme: SquadScheme.s343)
                }
                let vc = CardContainerViewController()
                vc.childVc = selectorVc
                vc.closeTrackEvent = EventTrack.SquadSelector.close
                vc.closeTrackValue = push.value1
                let nav = NavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                nav.modalPresentationStyle = .fullScreen
                nav.modalTransitionStyle = .coverVertical
                UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
            }
            return
            
        case .Store:
            DispatchQueue.main.async {
                if !fromNotificationCentral {
                    self.selectedIndex = 4
                }
                let vc = StoreHomeViewController()
                let nav = NavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                nav.isDarkStatusBarStyle = false
                nav.modalPresentationStyle = .fullScreen
                nav.modalTransitionStyle = .coverVertical
                UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
            }
            return
            
        case .Rankings:
            DispatchQueue.main.async {
                if !fromNotificationCentral {
                    self.selectedIndex = 4
                }
                let vc = RankingsViewController()
                let nav = NavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                nav.isDarkStatusBarStyle = false
                nav.modalPresentationStyle = .fullScreen
                nav.modalTransitionStyle = .coverVertical
                UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
            }
            return
            
        case .EditProfile:
            DispatchQueue.main.async {
                if !fromNotificationCentral {
                    self.selectedIndex = 4
                }
                let vc = EditProfileViewController()
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .coverVertical
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
            return
            
        case .AudioPlayerItem:
            DispatchQueue.main.async {
                let vc = AudioLibraryGroupViewController()
                vc.playItemIDWhenFinishedLoading = push.value1
                let nav = NavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                nav.modalPresentationStyle = .fullScreen
                nav.modalTransitionStyle = .coverVertical
                UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
            }
            return
            
        case .MatchDetails:
            DispatchQueue.main.async {
                if !fromNotificationCentral {
                    self.selectedIndex = 0
                }
                let vc = MatchDetailsViewController()
                vc.currentID = push.value1
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
            return
            
            
        case .StoreItem:
            DispatchQueue.main.async {
                guard let id = push.value1 else {return}
                let vc = StoreItemDetailsViewController(item: StoreItem(id: id, cuponID: nil, title: "", imageUrlString: nil, subtitle: nil, coins: nil, membershipCoins: nil, isMembershipOnly: false))
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
            return
            
        case .ShopGallery:
            DispatchQueue.main.async {
                let vc = ShopGalleryViewController()
                //vc.trackEvent = EventTrack.Menu.openShopGallery
                let nav = NavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                nav.isDarkStatusBarStyle = false
                nav.modalPresentationStyle = .fullScreen
                nav.modalTransitionStyle = .coverVertical
                UIApplication.topViewController()?.present(nav, animated: true, completion: nil)
            }
            break
            
        default : break //
        }
        
    }
    
}












