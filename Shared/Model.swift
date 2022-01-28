//
//  Model.swift
//  TheoPlay
//
//  Created by damiaan on 28/01/2022.
//

import Combine
import GroupActivities
import Dispatch
import struct SwiftUI.Color

class ColorModel: ObservableObject {
    private var sourceOfTruth = Color.red {
        willSet {
            objectWillChange.send()
        }
    }

    var color: Color {
        get { sourceOfTruth }
        set {
            sourceOfTruth = newValue
            broadcast(color: newValue)
        }
    }
            
    // MARK: - Group activities
    
    var groupActivity: SessionWithMessenger<ColorSharing>?
    
    func broadcast(color newColor: Color) {
        if let messenger = groupActivity?.messenger {
            messenger.send(CodableColor(newColor)) { potentialError in
                if let error = potentialError {
                    print(error.localizedDescription)
                }
            }
        } else {
            print("no messenger")
        }
    }
    
    func attach(groupActivitySession newSession: GroupSession<ColorSharing>) {
        let newContainer = SessionWithMessenger(newSession)
        let messenger = newContainer.messenger
        groupActivity = newContainer
        
        let listenToRemoteColorChanges = Task {
            for await (codableColor, _) in messenger.messages(of: CodableColor.self) {
                DispatchQueue.main.sync {
                    self.sourceOfTruth = Color(codableColor)
                }
            }
        }
        newContainer.tasks.insert(listenToRemoteColorChanges)
        
        newSession.$state.sink { state in
            if case .invalidated = state {
                self.groupActivity = nil
            }
        }.store(in: &newContainer.subscriptions)
        
        newSession.join()
    }
}
