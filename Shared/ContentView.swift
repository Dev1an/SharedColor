//
//  ContentView.swift
//  Shared
//
//  Created by damiaan on 28/01/2022.
//

import SwiftUI
import Combine
import AVKit

let player = AVPlayer(url: URL(string: "https://cdn.theoplayer.com/video/big_buck_bunny/big_buck_bunny.m3u8")!)

struct ContentView: View {
    @StateObject var model = ColorModel()
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
            
            ColorPicker("Color", selection: $model.color)
            
            Button("Start sharing") {
                Task {
                    do {
                        _ = try await ColorSharing().activate()
                    } catch {
                        print("Failed to activate activity: \(error)")
                    }
                }
            }
        }
        .padding()
        .task {
            for await session in ColorSharing.sessions() {
                model.attach(groupActivitySession: session)
                player.playbackCoordinator.coordinateWithSession(session)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
