//
//  ClubHomeViewController.swift
//  
//
//  Created by Roberto Oliveira on 13/01/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class ClubHomeViewController: BaseStackViewController {
    
    // MARK: - Properties
    private var lastUpdate:Date?
    private var nextMatchesTrackEvent:Int?
    private var lastMatchesTrackEvent:Int?
    private var squadViewTrackEvent:Int?
    
    
    
    
    
    // MARK: - Objects
    private lazy var nextMatchesView:ClubHomeNextMatchesView = {
        let vw = ClubHomeNextMatchesView()
        vw.btnFooter.addTarget(self, action: #selector(self.openSchedule), for: .touchUpInside)
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.nextMatchesTryAgain), for: .touchUpInside)
        vw.ticketTrackEvent = EventTrack.ClubHome.buyScheduleTickets
        return vw
    }()
    private lazy var lastMatchesView:ClubHomeLastMatchesView = {
        let vw = ClubHomeLastMatchesView()
        vw.delegate = self
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.lastMatchesTryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var squadView:ClubHomeSquadView = {
        let vw = ClubHomeSquadView()
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.squadTryAgain), for: .touchUpInside)
        return vw
    }()
    
    
    
    
    
    
    // MARK: - Content Methods
    @objc func openSchedule() {
        DispatchQueue.main.async {
            let vc = ScheduleViewController()
            vc.trackEvent = EventTrack.ClubHome.openSchedule
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func resetLastUpdate() {
        self.lastUpdate = nil
    }
    
    override func didPullToRefresh() {
        self.nextMatchesTrackEvent = EventTrack.ClubHome.pullToReload
        self.lastMatchesTrackEvent = nil
        self.squadViewTrackEvent = nil
        self.loadContentIfNeeded(forced: true)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func loadContentIfNeeded(forced:Bool = false) {
        var forceUpdate:Bool = forced// change back to false
        if let date = self.lastUpdate {
            // Force reload on viewWillAppear if last updated is 5 minutes or longer
            if Date.now().timeIntervalSince(date) > 60*5 {
                forceUpdate = true
                self.lastUpdate = Date.now()
            }
        } else {
            forceUpdate = true
            self.lastUpdate = Date.now()
        }
        if forceUpdate || self.nextMatchesView.dataSource.isEmpty {
            self.loadNextMatches()
        }
        if forceUpdate || self.lastMatchesView.dataSource.isEmpty {
            self.loadLastMatches()
        }
        if forceUpdate || self.squadView.dataSource.isEmpty {
            self.loadSquad()
        }
    }
    
    
    
    
    
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadContentIfNeeded()
    }
    
    override func prepareElements() {
        super.prepareElements()
        // Refresh Control
        self.scrollView.addSubview(self.refreshControl)
        self.scrollView.alwaysBounceVertical = true
        // Stack
        self.stackView.spacing = 0
        self.addStackSpaceView(height: 20)
        
        // Next Matches
        self.addFullWidthStackSubview(self.nextMatchesView)
        // Last Matches
        self.addFullWidthStackSubview(self.lastMatchesView)
        // Squad
        self.addFullWidthStackSubview(self.squadView)
        // Footer
        self.addStackSpaceView(height: 50)
    }
    
    
}














// MARK: - Last Matches
extension ClubHomeViewController: ClubHomeLastMatchesViewDelegate {
    
    private func loadLastMatches() {
        DispatchQueue.main.async {
            self.lastMatchesView.loadingView.startAnimating()
            self.lastMatchesView.updateContent(items: [])
        }
        ServerManager.shared.getLastMatchesPreview(trackEvent: self.lastMatchesTrackEvent) { (objects:[ClubHomeLastMatchItem]?) in
            self.lastMatchesTrackEvent = nil
            let items:[ClubHomeLastMatchItem] = objects ?? []
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
        self.lastMatchesTrackEvent = EventTrack.ClubHome.lastMatchesTryAgain
        self.loadLastMatches()
    }
    
    func clubHomeLastMatchesView(clubHomeLastMatchesView: ClubHomeLastMatchesView, didSelectItem item: ClubHomeLastMatchItem) {
        DispatchQueue.main.async {
            let vc = MatchDetailsViewController()
            vc.currentID = item.id
            vc.trackEvent = EventTrack.ClubHome.openMatchDetails
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}






// MARK: - Next Matches
extension ClubHomeViewController {
    
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
        self.nextMatchesTrackEvent = EventTrack.ClubHome.scheduleTryAgain
        self.loadNextMatches()
    }
    
}






// MARK: - Squad
extension ClubHomeViewController {
    
    private func loadSquad() {
        DispatchQueue.main.async {
            self.squadView.loadingView.startAnimating()
            self.squadView.updateContent(items: [])
        }
        ServerManager.shared.getHomeClubSquad(trackEvent: self.squadViewTrackEvent) { (objects:[ClubHomeSquadGroup]?) in
            self.squadViewTrackEvent = nil
            let items:[ClubHomeSquadGroup] = objects ?? []
            DispatchQueue.main.async() {
                if items.isEmpty {
                    self.squadView.loadingView.emptyResults()
                } else {
                    self.squadView.loadingView.stopAnimating()
                }
                self.squadView.updateContent(items: items)
            }
        }
    }
    
    @objc func squadTryAgain() {
        self.squadViewTrackEvent = EventTrack.ClubHome.squadTryAgain
        self.loadSquad()
    }
    
}
