//
//  HomeViewController.swift
//
//
//  Created by Roberto Oliveira on 05/11/18.
//  Copyright © 2018 Roberto Oliveira. All rights reserved.
//

import UIKit

class HomeViewController: BaseStackViewController {
    
    // MARK: - Properties
    private var lastUpdate:Date?
    private var bannersTrackEvent:Int?
    private var lastMatchesTrackEvent:Int?
    private var quizViewTrackEvent:Int?
    private var surveysAnswersTrackEvent:Int?
    private var instagramStoriesTrackEvent:Int?
    private var squadSelectorTrackEvent:Int?
    private var nextMatchesTrackEvent:Int?
    private var shopGalleryTrackEvent:Int?
    
    
    // MARK: - Objects
    private lazy var expandedBannerView:HomeExpandedBannersView = {
        let vw = HomeExpandedBannersView()
        vw.delegate = self
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.expanededBannersTryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var tweetsView:HomeTweetsView = {
        let vw = HomeTweetsView()
        vw.delegate = self
        vw.loadinView.btnAction.addTarget(self, action: #selector(self.tweetsTryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var bannerView:HomeBannersView = {
        let vw = HomeBannersView()
        vw.delegate = self
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.bannersTryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var shopGalleryView:HomeShopGalleryView = {
        let vw = HomeShopGalleryView()
        vw.delegate = self
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.shopGalleryTryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var lastMatchesView:ClubHomeLastMatchesView = {
        let vw = ClubHomeLastMatchesView()
        vw.delegate = self
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.lastMatchesTryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var quizView:HomeQuizView = {
        let vw = HomeQuizView()
        vw.delegate = self
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.quizViewTryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var surveysAnswersView:HomeSurveysAnswersView = {
        let vw = HomeSurveysAnswersView()
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.surveysAnswersTryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var instagramStoriesView:InstagramStoriesView = {
        let vw = InstagramStoriesView()
        vw.expandItemTrackEvent = EventTrack.Home.storiesOpenItem
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.instagramStoriesTryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var squadSelectorView:HomeSquadSelectorView = {
        let vw = HomeSquadSelectorView()
        vw.delegate = self
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.squadSelectorTryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var nextMatchesView:ClubHomeNextMatchesView = {
        let vw = ClubHomeNextMatchesView()
        vw.btnFooter.addTarget(self, action: #selector(self.openSchedule), for: .touchUpInside)
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.nextMatchesTryAgain), for: .touchUpInside)
        vw.ticketTrackEvent = EventTrack.Home.buyScheduleTickets
        return vw
    }()
    private lazy var audioLibraryView:HomeAudioLibraryView = {
        let vw = HomeAudioLibraryView()
        vw.delegate = self
        return vw
    }()
    private lazy var ctaBannerView:HomeCTABannerView = {
        let vw = HomeCTABannerView()
        vw.delegate = self
        return vw
    }()
    private let userHeaderView:UserHeaderView = {
        let vw = UserHeaderView()
//        vw.notificationsTrackEvent = EventTrack.Home.openNotificationsCentral
        return vw
    }()
    private let videoView:HomeVideoView = HomeVideoView()
    let topFadeView:TransparentGradientView = {
        let vw = TransparentGradientView()
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 0, y: 1)
        vw.updateGradient(start: startPoint, end: endPoint)
        vw.backgroundColor = UIColor(hexString: "012A27")
        let colors:[CGColor] = [
            UIColor(red: 0.015, green: 0.394, blue: 0.643, alpha: 1).cgColor,
            UIColor(red: 0, green: 0.467, blue: 0.773, alpha: 1).cgColor,
            UIColor(red: 0, green: 0.467, blue: 0.773, alpha: 0).cgColor
        ]
        let locations:[NSNumber] = [0, 0.3, 0.7]
        vw.updateGradient(colors: colors, locations: locations)
        return vw
    }()
    
    // MARK: - Content Methods
    @objc func resetLastUpdate() {
        self.lastUpdate = nil
    }
    
    override func didPullToRefresh() {
        self.bannersTrackEvent = EventTrack.Home.pullToReload
        self.lastMatchesTrackEvent = nil
        self.quizViewTrackEvent = nil
        self.surveysAnswersTrackEvent = nil
        self.instagramStoriesTrackEvent = nil
        self.squadSelectorTrackEvent = nil
        self.nextMatchesTrackEvent = nil
        self.shopGalleryTrackEvent = nil
        self.loadContentIfNeeded(forced: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func loadContentIfNeeded(forced:Bool = false) {
//        var forceUpdate:Bool = forced// change back to false
//        if let date = self.lastUpdate {
//            // Force reload on viewWillAppear if last updated is 5 minutes or longer
//            if Date.now().timeIntervalSince(date) > 60*5 {
//                forceUpdate = true
//                self.lastUpdate = Date.now()
//            }
//        } else {
//            forceUpdate = true
//            self.lastUpdate = Date.now()
//        }
        let forceUpdate = forced
        
        if forceUpdate || self.expandedBannerView.dataSource.isEmpty {
            self.loadExpandedBanners()
        }
        
        if forceUpdate || self.bannerView.dataSource.isEmpty {
            self.loadBanners()
        }
        if forceUpdate || self.shopGalleryView.dataSource.isEmpty {
            self.loadShopGallery()
        }
        if forceUpdate || self.tweetsView.twitterView.dataSource.isEmpty {
            self.loadTweets()
        }
        if forceUpdate || self.lastMatchesView.dataSource.isEmpty {
            self.loadLastMatches()
        }
        if forceUpdate || self.instagramStoriesView.dataSource.isEmpty {
            self.loadInstagramStories()
        }
        if forceUpdate || self.nextMatchesView.dataSource.isEmpty {
            self.loadNextMatches()
        }
        if forceUpdate || self.audioLibraryView.currentItem == nil {
            self.loadAudioLibrary()
        }
        if forceUpdate || self.ctaBannerView.currentItem == nil {
            self.loadCTABanner()
        }
        if forceUpdate || self.squadSelectorView.currentItem == nil {
            self.loadSquadSelector()
        }
        if forceUpdate || self.videoView.currentItem == nil {
            self.loadVideo()
        }
//        if forceUpdate || self.quizView.currentItem == nil {
            self.loadQuizView()
//        }
//        if forceUpdate || self.surveysAnswersView.dataSource.isEmpty {
            self.loadSurveysAnswers()
//        }
        // coins
        self.userHeaderView.updateContent()
        ServerManager.shared.getUserInfo { (success:Bool?) in
            if success == true {
                DispatchQueue.main.async {
                    self.userHeaderView.updateContent()
                }
            }
        }
        
    }
    
    
    
    
    
    
    
    
    // MARK: - Super Methods
    override func appBecomeActive() {
        if !self.bannerView.dataSource.isEmpty {
            self.loadContentIfNeeded(forced: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadContentIfNeeded()
        ServerManager.shared.isHomePresented = true
        FloatingButton.shared.showFloatingButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        FontsManager.exploreFonts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FloatingButton.shared.hideFloatingButton()
    }
    override func prepareElements() {
        super.prepareElements()
        // Fade view
        self.view.addSubview(self.topFadeView)
        self.view.addBoundsConstraintsTo(subView: self.topFadeView, leading: 0, trailing: 0, top: 0, bottom: nil)
        if UIScreen.main.bounds.height < 700 {
            self.topFadeView.addHeightConstraint(250)
        } else if UIScreen.main.bounds.height < 900 {
            self.topFadeView.addHeightConstraint(350)
        } else {
            self.topFadeView.addHeightConstraint(400)
        }
        self.topFadeView.isUserInteractionEnabled = false
        // Refresh Control
//        self.scrollView.addSubview(self.refreshControl)
        self.scrollView.alwaysBounceVertical = true
        // Stack
        self.stackView.spacing = 0
        
//        self.addStackSpaceView(height: 20)
        // User Header
        self.view.addSubview(self.userHeaderView)
        self.view.addBoundsConstraintsTo(subView: self.userHeaderView, leading: 0, trailing: 0, top: nil, bottom: nil)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.userHeaderView, constant: 0)
        self.addStackSpaceView(height: 30)
        // Expanded Banners
        self.addFullWidthStackSubview(self.expandedBannerView)
        // CTA Banner
        self.addFullWidthStackSubview(self.ctaBannerView)
        // Next Matches
        self.addFullWidthStackSubview(self.nextMatchesView)
        // Last Matches
        self.addFullWidthStackSubview(self.lastMatchesView)
        // Banners
        self.addFullWidthStackSubview(self.bannerView)
        // Audio Library
        self.addFullWidthStackSubview(self.audioLibraryView)
        // Quiz
        self.addFullWidthStackSubview(self.quizView)
        // Shop Gallery
        self.addFullWidthStackSubview(self.shopGalleryView)
        // Twitter
        self.addFullWidthStackSubview(self.tweetsView)
        // Squad Selector
        self.addFullWidthStackSubview(self.squadSelectorView)
        // Video
        self.addFullWidthStackSubview(self.videoView)
        // Surveys Answers
        self.addFullWidthStackSubview(self.surveysAnswersView)
        // Instagram Stories
        self.addFullWidthStackSubview(self.instagramStoriesView)
        // Footer
        self.addStackSpaceView(height: 50)
      
    }
    
}








// MARK: - Twitter
extension HomeViewController: HomeTweetsViewDelegate {
    
    private func loadTweets() {
        DispatchQueue.main.async {
            self.tweetsView.twitterView.loadContent(mode: TwitterFeedPosition.Home)
        }
    }
    
    @objc func tweetsTryAgain() {
        self.loadTweets()
    }
    
    func didSelectAllTweets() {
        DispatchQueue.main.async {
            let vc = AllTweetsViewController()
            vc.searchString = self.tweetsView.twitterView.searchString
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


// MARK: - Banners
extension HomeViewController: HomeBannersViewDelegate {
    
    private func loadBanners() {
        DispatchQueue.main.async {
            self.bannerView.loadingView.startAnimating()
            self.bannerView.updateContent(items: [])
        }
        ServerManager.shared.getHomeBanners(id: 2,trackEvent: self.bannersTrackEvent) { (objects:[AllNewsItem]?) in
            self.bannersTrackEvent = nil
            let items = objects ?? []
            DispatchQueue.main.async() {
                if items.isEmpty {
                    self.bannerView.loadingView.emptyResults()
                } else {
                    self.bannerView.loadingView.stopAnimating()
                }
                self.bannerView.updateContent(items: items)
            }
        }
    }
    
    private func loadExpandedBanners() {
        DispatchQueue.main.async {
            self.expandedBannerView.loadingView.startAnimating()
            self.expandedBannerView.updateContent(items: [])
        }
        ServerManager.shared.getHomeBanners(id: 1,trackEvent: self.bannersTrackEvent) { (objects:[AllNewsItem]?) in
            self.bannersTrackEvent = nil
            let items = objects ?? []
            DispatchQueue.main.async() {
                if items.isEmpty {
                    self.expandedBannerView.loadingView.emptyResults()
                } else {
                    self.expandedBannerView.loadingView.stopAnimating()
                }
                self.expandedBannerView.updateContent(items: items)
            }
        }
    }
    
    @objc func bannersTryAgain() {
        self.bannersTrackEvent = EventTrack.Home.newsTryAgain
        self.loadBanners()
    }
    
    @objc func expanededBannersTryAgain() {
        self.loadExpandedBanners()
    }
    func didSelectBanner(item: AllNewsItem) {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Home.openNews, trackValue: item.id)
        DispatchQueue.main.async {
            if let link = item.urlString {
                guard let url = URL(string: link) else {return}
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let vc = NewsViewController(id: item.id)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
//        fatalError("Test Firebase 01")
    }
    
    func didSelectAllBanners() {
        DispatchQueue.main.async {
            let vc = AllNewsViewController()
            vc.trackEvent = EventTrack.Home.openAllNews
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}









// MARK: - Last Matches
extension HomeViewController: ClubHomeLastMatchesViewDelegate {
    
    private func loadLastMatches() {
        DispatchQueue.main.async {
            self.lastMatchesView.loadingView.startAnimating()
            self.lastMatchesView.updateContent(items: [])
        }
        ServerManager.shared.getLastMatchesPreview(trackEvent: self.lastMatchesTrackEvent) { (objects:[ClubHomeLastMatchItem]?) in
            self.lastMatchesTrackEvent = nil
            let items = objects ?? []
            DispatchQueue.main.async() {
                if items.isEmpty {
                    self.lastMatchesView.loadingView.emptyResults()
                } else {
                    self.lastMatchesView.loadingView.stopAnimating()
                }
                self.lastMatchesView.updateContent(items: items)
            }
        }
    }
    
    @objc func lastMatchesTryAgain() {
        self.lastMatchesTrackEvent = EventTrack.Home.lastMatchesTryAgain
        self.loadLastMatches()
    }
    
    func clubHomeLastMatchesView(clubHomeLastMatchesView: ClubHomeLastMatchesView, didSelectItem item: ClubHomeLastMatchItem) {
        DispatchQueue.main.async {
            let vc = MatchDetailsViewController()
            vc.currentID = item.id
            vc.trackEvent = EventTrack.Home.openMatchDetails
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}







// MARK: - Quiz View
extension HomeViewController: HomeQuizViewDelegate {
    
    private func loadQuizView() {
        DispatchQueue.main.async {
            self.quizView.loadingView.startAnimating()
            self.quizView.updateContent(item: nil)
        }
        ServerManager.shared.getHomeQuizPreview(trackEvent: self.quizViewTrackEvent) { (object:HomeQuizItem?) in
            self.quizViewTrackEvent = nil
            DispatchQueue.main.async() {
                if let item = object {
                    self.quizView.updateContent(item: item)
                    self.quizView.loadingView.stopAnimating()
                } else {
                    self.quizView.loadingView.emptyResults()
                }
            }
        }
    }
    
    @objc func quizViewTryAgain() {
        self.quizViewTrackEvent = EventTrack.Home.quizPreviewTryAgain
        self.loadQuizView()
    }
    
    func homeQuizView(homeQuizView: HomeQuizView, didSelectItem item: HomeQuizItem) {
        guard let tabVc = self.tabBarController as? HomeTabBarController else {return}
        ServerManager.shared.setTrack(trackEvent: EventTrack.Home.quizPreviewStart, trackValue: item.id)
        let obj = PushNotification(type: PushNotificationType.Quiz, id: 0, value1: item.id, value2: nil)
        tabVc.performPushNotificationDeeplink(for: obj, fromNotificationCentral: false)
    }
    
}






// MARK: - Surveys Answers
extension HomeViewController {
    
    private func loadSurveysAnswers() {
        DispatchQueue.main.async {
            self.surveysAnswersView.loadingView.startAnimating()
            self.surveysAnswersView.updateContent(items: [])
        }
        ServerManager.shared.getHomeSurveyAnswers(trackEvent: self.surveysAnswersTrackEvent) { (objects:[HomeSurveysAnswersItem]?) in
            self.surveysAnswersTrackEvent = nil
            let items = objects ?? []
            DispatchQueue.main.async() {
                self.surveysAnswersView.isHidden = items.isEmpty
                if items.isEmpty {
                    self.surveysAnswersView.loadingView.emptyResults()
                } else {
                    self.surveysAnswersView.loadingView.stopAnimating()
                }
                self.surveysAnswersView.updateContent(items: items)
            }
        }
    }
    
    @objc func surveysAnswersTryAgain() {
        self.surveysAnswersTrackEvent = nil
        self.loadSurveysAnswers()
    }
    
    
}









// MARK: - Instagram Stories
extension HomeViewController {
    
    private func loadInstagramStories() {
        DispatchQueue.main.async {
            self.instagramStoriesView.loadContent(mode: InstagramStoriesPosition.Home)
        }
    }
    
    @objc func instagramStoriesTryAgain() {
        DispatchQueue.main.async {
            self.instagramStoriesView.loadContent(mode: InstagramStoriesPosition.Home, trackEvent: EventTrack.Home.storiesTryAgain)
        }
    }
    
}






// MARK: - Squad Selector
extension HomeViewController: HomeSquadSelectorViewDelegate, SquadSelectorViewControllerDelegate {
    
    private func loadSquadSelector() {
        DispatchQueue.main.async {
            self.squadSelectorView.loadingView.startAnimating()
            self.squadSelectorView.updateContent(item: nil)
        }
        ServerManager.shared.getHomeSquadInfo(trackEvent: self.squadSelectorTrackEvent) { (object:SquadSelectorInfo?) in
            self.squadSelectorTrackEvent = nil
            DispatchQueue.main.async {
                if let item = object {
                    self.squadSelectorView.updateContent(item: item)
                    self.squadSelectorView.loadingView.stopAnimating()
                } else {
                    self.squadSelectorView.loadingView.emptyResults()
                }
            }
        }
    }
    
    @objc func squadSelectorTryAgain() {
        self.squadSelectorTrackEvent = EventTrack.Home.squadSelectorTryAgain
        self.loadSquadSelector()
    }
    
    func homeSquadSelectorView(didSelectStartWith homeSquadSelectorView: HomeSquadSelectorView) {
        ServerManager.shared.checkIfUserIsRegistered { (confirmed:Bool) in
            guard confirmed else {return}
            DispatchQueue.main.async {
                self.openSquadSelector()
            }
        }
    }
    
    func openSquadSelector() {
        DispatchQueue.main.async {
            let selectorVc = SquadSelectorViewController()
            selectorVc.delegate = self
            selectorVc.trackEvent = EventTrack.Home.squadSelectorStart
            if let item = self.squadSelectorView.currentItem {
                selectorVc.currentInfo = SquadSelectorInfo(id: item.id, title: item.title, scheme: item.scheme)
            }
            let vc = CardContainerViewController()
            vc.childVc = selectorVc
            vc.closeTrackEvent = EventTrack.SquadSelector.close
            vc.closeTrackValue = self.squadSelectorView.currentItem?.id
            vc.view.addBottomAlignmentConstraintFromSafeAreaTo(subView: vc.cardView, constant: -75, priority: 999, relatedBy: .equal)
            let nav = NavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .coverVertical
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func squadSelectorViewController(didCompleteSquadWith squadSelectorViewController: SquadSelectorViewController) {
        self.squadSelectorView.updateContent(item: nil)
    }
    
}


// MARK: - Next Matches
extension HomeViewController {
    
    private func loadNextMatches() {
        DispatchQueue.main.async {
            self.nextMatchesView.loadingView.startAnimating()
            self.nextMatchesView.updateContent(items: [])
        }
        ServerManager.shared.getSchedule(home: true, trackEvent: self.nextMatchesTrackEvent) { (objects:[ScheduleMatchesGroup]?, message:String?) in
            self.nextMatchesTrackEvent = nil
            let items:[ScheduleMatchesGroup] = objects ?? []
            DispatchQueue.main.async() {
                if items.isEmpty {
                    self.nextMatchesView.loadingView.emptyResults(title: message ?? "")
                } else {
                    self.nextMatchesView.loadingView.stopAnimating()
                }
                self.nextMatchesView.updateContent(items: items)
            }
        }
    }
    
    @objc func nextMatchesTryAgain() {
        self.nextMatchesTrackEvent = EventTrack.Home.scheduleTryAgain
        self.loadNextMatches()
    }
    
    @objc func openSchedule() {
        DispatchQueue.main.async {
            let vc = ScheduleViewController()
            vc.trackEvent = EventTrack.Home.openSchedule
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}




// MARK: - Audio Library
extension HomeViewController: HomeAudioLibraryViewDelegate {
    
    private func loadAudioLibrary() {
        DispatchQueue.main.async {
            self.audioLibraryView.loadingView.startAnimating()
            self.audioLibraryView.updateContent(item: nil)
        }
        ServerManager.shared.getHomeAudioLibrary(trackEvent: nil) { (object:HomeAudioLibraryItem?) in
            DispatchQueue.main.async() {
                if let item = object {
                    self.audioLibraryView.updateContent(item: item)
                    self.audioLibraryView.loadingView.stopAnimating()
                    self.audioLibraryView.isHidden = false
                } else {
                    self.audioLibraryView.isHidden = true
                }
            }
        }
    }
    
    func homeAudioLibraryView(homeAudioLibraryView: HomeAudioLibraryView, didSelectItem item: HomeAudioLibraryItem) {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Home.audioLibraryPlay, trackValue: item.id)
        DispatchQueue.main.async {
            let vc = AudioLibraryGroupViewController()
            vc.shouldPlayFeaturedItemWhenFinishedLoading = true
            let nav = NavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .coverVertical
            self.present(nav, animated: true, completion: nil)
        }
    }
    
}





// MARK: - CTA Banner
extension HomeViewController: HomeCTABannerViewDelegate {
    
    private func loadCTABanner() {
        DispatchQueue.main.async {
            self.ctaBannerView.loadingView.startAnimating()
            self.ctaBannerView.updateContent(item: nil)
        }
        ServerManager.shared.getHomeCTA(trackEvent: nil) { (object:HomeCTABannerItem?) in
            DispatchQueue.main.async() {
                if let item = object {
                    self.ctaBannerView.updateContent(item: item)
                    self.ctaBannerView.loadingView.stopAnimating()
                    self.ctaBannerView.isHidden = false
                } else {
                    self.ctaBannerView.isHidden = true
                }
            }
        }
    }
    
    func homeCTABannerView(homeCTABannerView: HomeCTABannerView, didSelectItem item: HomeCTABannerItem) {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Home.openCTABanner, trackValue: item.id)
        DispatchQueue.main.async {
            self.lastUpdate = nil // reset to force reload after performing a cta
            if let deeplink = item.deeplink {
                UIApplication.shared.performPushNotificationDeeplink(for: deeplink, fromNotificationCentral: false)
                return
            }
            DispatchQueue.main.async {
                BaseWebViewController.open(urlString: item.urlString, mode: item.isEmbed)
            }
        }
    }
    
}







// MARK: - Shop Gallery
extension HomeViewController: HomeShopGalleryViewDelegate {
    
    private func loadShopGallery() {
        DispatchQueue.main.async {
            self.shopGalleryView.loadingView.startAnimating()
            self.shopGalleryView.updateContent(items: [])
        }
        ServerManager.shared.getShopGalleryItems(home: true, searchString: "", page: 1, filterID: 0, trackEvent: self.shopGalleryTrackEvent) { (objects:[ShopGalleryItem]?, limit:Int?, margin:Int?) in
            self.shopGalleryTrackEvent = nil
            let items = objects ?? []
            DispatchQueue.main.async() {
                self.shopGalleryView.isHidden = items.isEmpty
                if items.isEmpty {
                    self.shopGalleryView.loadingView.emptyResults()
                } else {
                    self.shopGalleryView.loadingView.stopAnimating()
                }
                self.shopGalleryView.updateContent(items: items)
            }
        }
    }
    
    @objc func shopGalleryTryAgain() {
        self.shopGalleryTrackEvent = nil// no tracks
        self.loadShopGallery()
    }
    
    func didSelectShopGalleryItem(item: ShopGalleryItem) {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Home.openShopGalleryItem, trackValue: item.id)
        DispatchQueue.main.async {
            guard let link = item.link else {return}
            DispatchQueue.main.async {
                BaseWebViewController.open(urlString: link, mode: item.isEmbed)
            }
        }
    }
    
    func didSelectAllShopGallery() {
        DispatchQueue.main.async {
            let vc = ShopGalleryViewController()
            vc.trackEvent = EventTrack.Home.openShopGallery
            let nav = NavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            nav.isDarkStatusBarStyle = false
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .coverVertical
            self.present(nav, animated: true, completion: nil)
        }
    }
    
}








// MARK: - Video
extension HomeViewController {
    
    private func loadVideo() {
        DispatchQueue.main.async {
            self.videoView.loadingView.startAnimating()
            self.videoView.updateContent(item: nil)
        }
        ServerManager.shared.getHomeVideo(trackEvent: nil) { (object:HomeVideoItem?) in
            DispatchQueue.main.async() {
                if let item = object {
                    self.videoView.updateContent(item: item)
                    self.videoView.loadingView.stopAnimating()
                    self.videoView.isHidden = false
                } else {
                    self.videoView.isHidden = true
                }
            }
        }
    }
    
    
}


