//
//  ContentView.swift
//  Shared
//
//  Created by damiaan on 28/01/2022.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var model = ColorModel()
    
    var body: some View {
        VStack {            
            ColorPicker("Color", selection: $model.color)
            
            Button("Start sharing") {
                Task {
                    do {
                        _ = try await ColorSharing().activate()
                    } catch {
                        print("Failed to activate DrawTogether activity: \(error)")
                    }
                }
            }
        }
        .padding()
        .task {
            for await session in ColorSharing.sessions() {
                model.attach(groupActivitySession: session)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
