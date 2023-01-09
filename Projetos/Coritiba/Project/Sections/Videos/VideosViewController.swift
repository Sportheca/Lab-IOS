//
//  VideosViewController.swift
//
//
//  Created by Roberto Oliveira on 17/02/21.
//  Copyright © 2021 Roberto Oliveira. All rights reserved.
//

import UIKit

class VideosViewController: BaseStackViewController {
    
    // MARK: - Properties
    var trackEvent:Int?
    private var dataSource:[VideosGroup] = []
    var loadVideoWithID:Int?
    
    
    
    
    // MARK: - Objects
    private lazy var loadingView:ContentLoadingView = {
        let vw = ContentLoadingView()
        vw.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        return vw
    }()
    private lazy var headerView:VideosHeaderView = {
        let vw = VideosHeaderView()
        return vw
    }()
    private lazy var ivBackground: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "bg_gramado")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    // MARK: - Methods
//    @objc func digitalMembership() {
//        DigitalMembershipRequiredViewController.show()
//    }
//
    @objc func tryAgain() {
        self.trackEvent = nil
        self.loadContent()
    }
    
    private func loadContent() {
        DispatchQueue.main.async {
            for sub in self.stackView.arrangedSubviews {
                sub.removeFromSuperview()
            }
            
//            self.addFullWidthStackSubview(self.headerView)
            self.loadingView.startAnimating()
        }
        ServerManager.shared.getAllVideos(trackEvent: self.trackEvent) { (objects:[VideosGroup]?, message:String?) in
            DispatchQueue.main.async {
                self.dataSource = objects ?? []
                if self.dataSource.isEmpty {
                    self.loadingView.emptyResults(title: message ?? "Nenhum item encontrado")
                } else {
                    self.loadingView.stopAnimating()
                }
                
                for group in self.dataSource {
                    let vw = VideosGroupView()
                    vw.delegate = self
                    vw.updateContent(item: group, title: group.title)
                    self.addFullWidthStackSubview(vw)
                }
                
            }
        }
        
        if let id = self.loadVideoWithID {
            self.loadVideoWithID = nil
            ServerManager.shared.getVideo(id: id, trackEvent: nil) { (item:VideoItem?, message:String?) in
                guard let videoItem = item else {return}
                DispatchQueue.main.async {
                    self.videosGroupView(videosGroupView: VideosGroupView(), didSelectItem: videoItem)
                }
            }
        }
        
    }
    
    
    
    // MARK: - Super Methods
    override func appBecomeActive() {
        super.appBecomeActive()
        if !self.dataSource.isEmpty {
            self.loadContent()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerView.updateContent(title: "Destaques")
        if self.dataSource.isEmpty {
            self.loadContent()
        }
    }
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Loading
        self.view.addSubview(self.loadingView)
        self.view.addCenterXAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        self.view.addCenterYAlignmentConstraintTo(subView: self.loadingView, constant: 0)
        //Background
        self.view.insertSubview(self.ivBackground, belowSubview: self.scrollView)
        self.view.addFullBoundsConstraintsTo(subView: self.ivBackground, constant: 0)
        // Header
        self.addFullWidthStackSubview(self.headerView)
    }
    
}


import AVKit
extension VideosViewController: VideosGroupViewDelegate {
    
    func videosGroupView(videosGroupView: VideosGroupView, didSelectItem item: VideoItem) {
        DispatchQueue.main.async {
//            guard let url = URL(string: item.videoUrl) else {return}
//            let player = AVPlayer(url: url)
//            let playerViewController = AVPlayerViewController()
//            playerViewController.player = player
//            self.present(playerViewController, animated: true) {
//                playerViewController.player!.play()
//            }
            ServerManager.shared.setTrack(trackEvent: EventTrack.Videos.openItem, trackValue: item.id)
//            if item.isDigitalMembershipOnly && ServerManager.shared.user?.isDigitalMembership != true {
//                DigitalMembershipRequiredViewController.show()
//            } else {
                if item.videoUrl.hasPrefix("http") {
                    let vc = BaseWebViewController(urlString: item.videoUrl)
//                    vc.closeTrackEvent = EventTrack.VideoItem.close
//                    vc.closeTrackValue = item.id
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = BaseWebViewController(urlString: item.videoUrl)
//                    vc.closeTrackEvent = EventTrack.VideoItem.close
//                    vc.closeTrackValue = item.id
                    UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    
    
    func videosGroupView(videosGroupView: VideosGroupView, didSelectAllItemsInGroup group: VideosGroup) {
        ServerManager.shared.setTrack(trackEvent: EventTrack.Videos.openCategory, trackValue: group.id)
        DispatchQueue.main.async {
            let vc = VideosCategoryViewController()
            vc.currentGroup = group
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
