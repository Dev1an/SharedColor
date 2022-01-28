//
//  GroupActivity.swift
//  TheoPlay
//
//  Created by damiaan on 28/01/2022.
//

import Foundation
import GroupActivities
import class Combine.AnyCancellable

class SessionWithMessenger<Activity: GroupActivity> {
    let session: GroupSession<Activity>
    let messenger: GroupSessionMessenger

    var subscriptions = Set<AnyCancellable>()
    var tasks = Set<Task<Void, Never>>()
    
    init(_ session: GroupSession<Activity>) {
        self.session = session
        messenger = GroupSessionMessenger(session: session)
    }
    
    deinit {
        print("Removing group activity and listeners")
    }
}

struct ColorSharing: GroupActivity {
    var metadata: GroupActivityMetadata = {
        var metaBuilder = GroupActivityMetadata()
        metaBuilder.type = .generic
        metaBuilder.title = "Theo watch party"
        metaBuilder.fallbackURL = URL(string: "https://theoplayershareplay.thijslowette.repl.co")
        return metaBuilder
    }()
}
