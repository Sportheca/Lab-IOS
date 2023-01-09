//
// Player.swift
//
//
// Created by Sergio Aquiles on 05/01/23.
// Copyright © 2023 Sportheca. All rights reserved.
//


import SwiftUI
import AVKit


struct Player: UIViewControllerRepresentable {
    
    var videoURL: URL
    @Binding var isVideoFinished: Bool
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let vc = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        vc.player = player
        vc.showsPlaybackControls = false
        player.play()
        
        return vc
    }
    
    ///Do something here if this viewController need to be updated from a swiftUI view.
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) { }
    
    /// Creates the custom instance that you use to notify changes from your view to other parts of your SwiftUI interface.
    /// Works like a delegate
    class Coordinator {
        var parent: Player
       
        init(_ parent: Player) {
            self.parent = parent
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        }
       
        @objc func playerDidFinishPlaying() {
            parent.isVideoFinished = true
            print("Video has finished.")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
