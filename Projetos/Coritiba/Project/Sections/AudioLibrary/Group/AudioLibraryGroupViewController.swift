//
//  AudioLibraryGroupViewController.swift
//  
//
//  Created by Roberto Oliveira on 3/23/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class AudioLibraryGroupViewController: BaseViewController, PaginationContentViewDelegate, AudioLibraryGroupContentViewDelegate {
    
    // MARK: - Properties
    var trackEvent:Int?
    var playItemIDWhenFinishedLoading:Int?
    var shouldPlayFeaturedItemWhenFinishedLoading:Bool = false
    private var showPlayerAnimated = true
    private var currentGroup:AudioLibraryGroup?
    
    
    
    // MARK: - Objects
    private lazy var btnClose:CustomButton = {
        let btn = CustomButton()
        btn.setTitle("Voltar", for: .normal)
        btn.setTitleColor(Theme.color(.PrimaryAnchor), for: .normal)
        btn.titleLabel?.font = FontsManager.customFont(key: FontsManager.Roboto.Black, size: 14)
        btn.highlightedAlpha = 0.7
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.closeAction), for: .touchUpInside)
        return btn
    }()
    private let contentContainerView:UIView = {
        let vw = UIView()
        vw.backgroundColor = UIColor.clear
        return vw
    }()
    private lazy var contentView:AudioLibraryGroupContentView = {
        let vw = AudioLibraryGroupContentView()
        vw.loadingView.btnAction.addTarget(self, action: #selector(self.tryAgain), for: .touchUpInside)
        vw.paginationDelegate = self
        vw.delegate = self
        return vw
    }()
    
    
    
    
    // MARK: - Methods
    @objc func closeAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.AudioLibrary.close, trackValue: nil)
        DispatchQueue.main.async {
            self.dismissAction()
        }
    }
    
    @objc func tryAgain() {
        self.trackEvent = EventTrack.AudioLibrary.tryAgain
        self.loadContent()
    }
    
    func didPullToReload() {
        self.trackEvent = EventTrack.AudioLibrary.pullToReload
        self.loadContent()
    }
    
    func loadNexPage() {
        self.loadContent()
    }
    
    private func loadContent() {
        DispatchQueue.main.async {
            if self.contentView.dataSource.isEmpty {
                self.contentView.loadingView.startAnimating()
                self.contentView.collectionView.isHidden = true
            }
        }
        ServerManager.shared.getAudioLibraryGroupItems(id: self.currentGroup?.id ?? 0, requiredItemID: self.playItemIDWhenFinishedLoading, page: self.contentView.currentPage, trackEvent: self.trackEvent) { (objects:[AudioLibraryGroupItem]?, limit:Int?, margin:Int?) in
            self.trackEvent = nil
            let items = objects ?? []
            DispatchQueue.main.async() {
                if self.contentView.currentPage == 1 {
                    AudioLibraryManager.shared.dataSource = items
                    self.contentView.updateContent(items: items, limit: limit, margin: margin)
                    if items.isEmpty {
                        self.contentView.loadingView.emptyResults()
                    } else {
                        self.contentView.collectionView.isHidden = false
                        self.contentView.loadingView.stopAnimating()
                        if self.shouldPlayFeaturedItemWhenFinishedLoading {
                            self.audioLibraryGroupContentView(audioLibraryGroupContentView: self.contentView, didSelectItem: items[0])
                            self.shouldPlayFeaturedItemWhenFinishedLoading = false
                        }
                        if let requiredItemID = self.playItemIDWhenFinishedLoading {
                            for item in items {
                                if item.id == requiredItemID {
                                    self.showPlayerAnimated = false
                                    self.audioLibraryGroupContentView(audioLibraryGroupContentView: self.contentView, didSelectItem: item)
                                }
                            }
                            self.playItemIDWhenFinishedLoading = nil
                        }
                    }
                } else {
                    AudioLibraryManager.shared.dataSource.append(contentsOf: items)
                    self.contentView.addContent(items: items)
                }
            }
        }
    }
    
    func audioLibraryGroupContentView(audioLibraryGroupContentView: AudioLibraryGroupContentView, didSelectItem item: AudioLibraryGroupItem) {
        guard let sufix = item.fileUrlString else {return}
        if !AudioLibraryManager.isDownloaded(urlString: sufix) {
            AudioLibraryManager.shared.download(id: item.id, sufix: sufix)
            if self.shouldPlayFeaturedItemWhenFinishedLoading {
                return
            }
        }
        self.playAudio(item: item)
    }
    
    @objc func downloadProgressUpdated(_ notification:Notification) {
        guard let info = notification.object as? AudioLibraryDownloadInfo else {return}
        guard info.progress >= 1.0 else {return}
        // check if still not playing any other sound
        guard AudioLibraryManager.shared.downloadingIds.isEmpty else {return}
        let items = self.contentView.dataSource as? [AudioLibraryGroupItem] ?? []
        for item in items {
            if item.id == info.id {
                self.playAudio(item: item)
            }
        }
    }
    
    
    private func playAudio(item:AudioLibraryGroupItem) {
        DispatchQueue.main.async {
            if item.id != AudioLibraryPlayer.shared.currentID {
                AudioLibraryPlayer.shared.play(id: item.id, localFileUrl: item.fileUrlString ?? "")
            }
            AudioLibraryManager.shared.currentItem = item
            let objects = self.contentView.dataSource as? [AudioLibraryGroupItem] ?? []
            for (index,obj) in objects.enumerated() {
                if obj.id == item.id {
                    AudioLibraryManager.shared.currentIndex = index
                }
            }
            let vc = AudioLibraryPlayerViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.trackEvent = nil//
            self.present(vc, animated: self.showPlayerAnimated, completion: nil)
            self.showPlayerAnimated = true
        }
    }
    
    
    
    
    
    // MARK: - Super Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.downloadProgressUpdated(_:)), name: NSNotification.Name(AudioLibraryDownloadManager.notification_downloadProgressUpdated), object: nil)
        if self.contentView.dataSource.isEmpty {
            self.loadContent()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK: - Init Methods
    override func prepareElements() {
        super.prepareElements()
        // Navigation
        self.view.addSubview(self.btnClose)
        self.view.addTopAlignmentConstraintFromSafeAreaTo(subView: self.btnClose, constant: 10)
        self.view.addLeadingAlignmentConstraintTo(subView: self.btnClose, constant: 25)
        self.btnClose.addHeightConstraint(40)
        // Container
        self.view.addSubview(self.contentContainerView)
        self.view.addVerticalSpacingTo(subView1: self.btnClose, subView2: self.contentContainerView, constant: 5)
        self.view.addBoundsConstraintsTo(subView: self.contentContainerView, leading: 0, trailing: 0, top: nil, bottom: 0)
        // Content
        self.contentContainerView.addSubview(self.contentView)
        self.contentContainerView.addFullBoundsConstraintsTo(subView: self.contentView, constant: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Theme.statusBarStyle()
    }
    
}
