//
// LocalVideoView.swift
// 
//
// Created by Roberto Oliveira on 31/05/22.
// Copyright © 2022 Sportheca. All rights reserved.
//

import AVFoundation
import UIKit

protocol LocalVideoViewDelegate:AnyObject {
    func localVideoView(localVideoView:LocalVideoView, didFinishPlayingVideo named:String)
}

/// This CustomView class is used to reproduce a local .mp4 video file in .ScaleAspectFill mode. A delegate is provided to check when video is finished
class LocalVideoView: UIView {

    // MARK: - Properties
    weak var delegate:LocalVideoViewDelegate?
    private var player:AVPlayer = AVPlayer()
    private var currentVideoName:String = ""

    
    
    func playLocalVideo(named:String) {
        guard let path = Bundle.main.path(forResource: named, ofType:"mp4") else {
            // failed
            self.delegate?.localVideoView(localVideoView: self, didFinishPlayingVideo: self.currentVideoName)
            return
        }
        self.currentVideoName = named
        self.player = AVPlayer(url: URL(fileURLWithPath: path))
        guard let la = self.layer as? AVPlayerLayer else {
            // failed
            self.delegate?.localVideoView(localVideoView: self, didFinishPlayingVideo: self.currentVideoName)
            return
        }
        la.player = self.player
        la.videoGravity = .resizeAspectFill
        self.player.play()
    }
    
    /// Observer method to identify that video did finished
    @objc func playerDidFinishPlaying() {
        self.delegate?.localVideoView(localVideoView: self, didFinishPlayingVideo: self.currentVideoName)
    }

    // Override UIView property
    public override static var layerClass: AnyClass {return AVPlayerLayer.self}
    
    init() {
        super.init(frame: CGRect.zero)
        // Add observer to video_finished event
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

