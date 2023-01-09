//
//  AudioLibraryManager.swift
//  
//
//  Created by Roberto Oliveira on 3/24/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import UIKit

class AudioLibraryManager {
    
    // MARK: - Shared
    private init(){}
    static let shared:AudioLibraryManager = AudioLibraryManager()
    
    
    // MARK: - Properties
    var currentItem:AudioLibraryGroupItem? {
        didSet {
            self.downloadLyrics()
        }
    }
    var dataSource:[AudioLibraryGroupItem] = []
    var lyricsDataSource:[Int:String] = [:]
    var currentIndex:Int = 0
    var downloadingIds:Set<Int> = []
    
    
    // MARK: - Player Properties
    var isLyricsEnabled:Bool = false {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(AudioLibraryPlayerContentView.notification_flipCover), object: nil)
        }
    }
    var isRepeatEnabled:Bool = false
    var isShuffleEnabled:Bool = false
    var isMuteEnabled:Bool = false {
        didSet {
            guard let player = AudioLibraryPlayer.shared.player else {return}
            player.isMuted = self.isMuteEnabled
        }
    }
    
    
    
    // MARK: - Static Methods
    static func fileUrlString(sufix:String) -> String {
        if sufix.contains(otherString: "http") {
            return sufix
        }
        let urlString = ProjectManager.mainUrl + ProjectManager.filesPath + sufix
        return urlString
    }
    
    static func downloadsFolder() -> URL {
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folder = documentsDirectoryURL.appendingPathComponent("audio_library")
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
        } catch {}
        return folder
    }
    
    static func isDownloaded(urlString:String) -> Bool {
        guard let audioUrl = URL(string: AudioLibraryManager.fileUrlString(sufix: urlString)) else {return false}
        let folder = AudioLibraryManager.downloadsFolder()
        let destinationUrl = folder.appendingPathComponent(audioUrl.lastPathComponent)
        
        do {
            let resources = try destinationUrl.resourceValues(forKeys:[.fileSizeKey])
            let fileSize = resources.fileSize ?? 0
            if fileSize < 1000 {
                return false
            }
        } catch {
            // error
        }
         
        return FileManager.default.fileExists(atPath: destinationUrl.path)
    }
    
    static func localFileUrl(sufix:String) -> URL? {
        guard let audioUrl = URL(string: AudioLibraryManager.fileUrlString(sufix: sufix)) else {return nil}
        let folder = AudioLibraryManager.downloadsFolder()
        return folder.appendingPathComponent(audioUrl.lastPathComponent)
    }
    
    func downloadLyrics() {
        guard let id = self.currentItem?.id else {return}
        guard self.lyricsDataSource[id] == nil else {return}
        ServerManager.shared.getAudioLibraryItemLyrics(id: id)
    }
    
    
    
    
    
    
    // MARK: - Properties
    func download(id:Int, sufix:String) {
        if AudioLibraryManager.isDownloaded(urlString: sufix) {
            return
        }
        if self.downloadingIds.contains(id) {
            return
        }
        self.downloadingIds.insert(id)
        // start download
        let downloader = AudioLibraryDownloadManager()
        downloader.downloadFile(id: id, urlString: AudioLibraryManager.fileUrlString(sufix: sufix))
    }
    
    func nextTrack() {
        if self.isShuffleEnabled {
            var availableIndexes:[Int] = []
            for (index, item) in self.dataSource.enumerated() {
                if item.id != self.currentItem?.id && AudioLibraryManager.isDownloaded(urlString: item.fileUrlString ?? "") {
                    availableIndexes.append(index)
                }
            }
            if !availableIndexes.isEmpty {
                availableIndexes.shuffle()
                self.currentIndex = availableIndexes[0]
                self.updateItemAtCurrentIndex()
                return
            }
        }
        
        guard self.currentIndex < self.dataSource.count-1 else {return}
        self.currentIndex = self.dataSource.isEmpty ? 0 : min(self.dataSource.count-1, self.currentIndex+1)
        self.updateItemAtCurrentIndex()
        
    }
    
    func previousTrack() {
        self.currentIndex = max(0, self.currentIndex-1)
        self.updateItemAtCurrentIndex()
    }
    
    private func updateItemAtCurrentIndex() {
        guard self.currentIndex < self.dataSource.count else {return}
        let item = self.dataSource[self.currentIndex]
        self.currentItem = item
        if item.id != AudioLibraryPlayer.shared.currentID {
            if self.isLyricsEnabled == true {
                self.isLyricsEnabled = false
            }
            AudioLibraryPlayer.shared.play(id: item.id, localFileUrl: item.fileUrlString ?? "")
        }
    }
    
    
    
    
    
    // MARK: - Floating Button
    private lazy var btnFloating:CustomButton = {
        let btn = CustomButton()
        btn.adjustsImageWhenHighlighted = false
        btn.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        btn.imageView?.tintColor = Theme.color(Theme.Color.AudioLibraryMainButtonText)
        btn.backgroundColor = Theme.color(Theme.Color.AudioLibraryMainButtonBackground)
        btn.setImage(UIImage(named: "btn_audio_library")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.highlightedAlpha = 1.0
        btn.highlightedScale = 0.95
        btn.addTarget(self, action: #selector(self.floatingAction), for: .touchUpInside)
        return btn
    }()
    @objc func floatingAction() {
        ServerManager.shared.setTrack(trackEvent: EventTrack.NoScreen.openAudioLibraryFromFloatingButton, trackValue: AudioLibraryManager.shared.currentItem?.id)
        DispatchQueue.main.async {
            guard let topVc = UIApplication.topViewController() else {return}
            let vc = AudioLibraryPlayerViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.trackEvent = nil//
            topVc.present(vc, animated: true, completion: nil)
        }
    }
    func showFloatingButton() {
        guard let window = UIApplication.shared.keyWindow else {return}
        self.btnFloating.removeFromSuperview()
        window.addSubview(self.btnFloating)
        let bottom = (UIApplication.shared.delegate as? AppDelegate)?.tabController?.tabBar.frame.height ?? 49.0
        window.addBottomAlignmentConstraintTo(subView: self.btnFloating, constant: -bottom)
        window.addTrailingAlignmentConstraintTo(subView: self.btnFloating, constant: -5)
        let btnFloatingSize:CGFloat = 60.0
        self.btnFloating.addHeightConstraint(btnFloatingSize)
        self.btnFloating.addWidthConstraint(btnFloatingSize)
        self.btnFloating.layer.cornerRadius = btnFloatingSize/2
    }
    func hideFloatingButton() {
        self.btnFloating.removeFromSuperview()
    }
    
}



