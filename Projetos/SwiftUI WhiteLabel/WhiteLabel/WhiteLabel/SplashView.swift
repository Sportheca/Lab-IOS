//
// SplashView.swift
//
//
// Created by Sergio Aquiles on 05/01/23.
// Copyright © 2023 Sportheca. All rights reserved.
//


import SwiftUI
import AVKit

struct SplashView: View {
    
    let url = Bundle.main.url(forResource: "fitdance", withExtension: "mp4")
    @State private var isVideoFinished = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            if isVideoFinished {
                ContentView()
            } else {
                if let url = url {
                    Player(videoURL: url, isVideoFinished: $isVideoFinished)
                        .ignoresSafeArea()
                }
            }
        }
        .onAppear {
            guard let _ = self.url else {
                isVideoFinished.toggle()
                print("Impossible to load splash video.")
                return
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
