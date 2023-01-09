//
//  AudioLibraryPlayer.swift
//  
//
//  Created by Roberto Oliveira on 3/23/20.
//  Copyright © 2020 Roberto Oliveira. All rights reserved.
//

import Foundation
import AVKit

class AudioLibraryPlayer {
    
    // MARK: - Shared
    private init(){}
    static let shared:AudioLibraryPlayer = AudioLibraryPlayer()
    
    
    
    // MARK: - Properties
    var currentID:Int = 0
    var player: AVPlayer?
    var isPlaying:Bool = false
    
    
    func play(id:Int, localFileUrl:String) {
        self.player?.pause()
        self.player = nil
        guard let audioUrl = URL(string: AudioLibraryManager.fileUrlString(sufix: localFileUrl)) else {return}
        self.currentID = id
        guard AudioLibraryManager.isDownloaded(urlString: localFileUrl) else {
            self.isPlaying = false
            return
        }
        let url = AudioLibraryManager.downloadsFolder().appendingPathComponent(audioUrl.lastPathComponent)
        
        do {
            // set audio options
           try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {}
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        DispatchQueue.main.async {
            self.player = AVPlayer(url: url)
            self.player?.play()
            self.isPlaying = true
        }

    }
    
    @objc func playerDidFinishPlaying(_ note: NSNotification) {
        self.isPlaying = false
        if AudioLibraryManager.shared.isRepeatEnabled {
            guard let item = AudioLibraryManager.shared.currentItem else {return}
            self.play(id: item.id, localFileUrl: item.fileUrlString ?? "")
        } else {
            AudioLibraryManager.shared.nextTrack()
        }
    }
    
    
    
    
    // MARK: Time Descriptions
    func currentTimeSeconds() -> Int? {
        return Int.intValue(from: self.player?.currentTime().seconds)
    }
    
    func totalTimeSeconds() -> Int? {
        return Int.intValue(from: self.player?.currentItem?.duration.seconds)
    }
    
    func currentTimeDescription() -> String {
        var currentDescription = "--:--"
        if let current = self.currentTimeSeconds() {
            currentDescription = self.timeDescription(seconds: current)
        }
        return currentDescription
    }
    
    func totalTimeDescription() -> String {
        var totalDescription = "--:--"
        if let total = self.totalTimeSeconds() {
            totalDescription = self.timeDescription(seconds: total)
        }
        return totalDescription
    }
    
    private func timeDescription(seconds:Int) -> String {
        let hours = (seconds - (seconds%3600))/3600
        let a = seconds-(hours*3600)
        let minutes = (a - (a%60))/60
        let seconds = a - (minutes*60)
        
        let secondsDescription = seconds >= 10 ? seconds.description : "0"+seconds.description
        let minutedDescription = minutes >= 10 ? minutes.description : "0"+minutes.description
        let hoursDescription = hours >= 10 ? hours.description : "0"+hours.description
        
        if hours > 0 {
            return "\(hoursDescription):\(minutedDescription):\(secondsDescription)"
        } else {
            return "\(minutedDescription):\(secondsDescription)"
        }
    }
    
    
}
