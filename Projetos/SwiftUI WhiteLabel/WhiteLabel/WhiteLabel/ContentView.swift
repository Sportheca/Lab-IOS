//
// ContentView.swift
//
//
// Created by Roberto Oliveira on 20/12/22.
// Copyright © 2022 Sportheca. All rights reserved.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "sportscourt.fill")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .font(.largeTitle)
            Text("Hello, OneFan!")
                .font(.title)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
