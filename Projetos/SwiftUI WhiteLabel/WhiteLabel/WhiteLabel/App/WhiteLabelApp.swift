//
// WhiteLabelApp.swift
//
//
// Created by Roberto Oliveira on 20/12/22.
// Copyright © 2022 Sportheca. All rights reserved.
//


import SwiftUI

@main
struct WhiteLabelApp: App {
    
    ///Check the app life cycle status
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                print("Application went background")
            case .inactive:
                print("Application got inactive")
            case .active:
                print("Application got active")
            @unknown default:
                print("Some  unknow application status")
            }
        }
    }
}
