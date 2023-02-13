//
//  SpendingTrackingApp.swift
//  SpendingTracking
//
//  Created by Ivica Petrsoric on 13.02.2023..
//

import SwiftUI

@main
struct SpendingTrackingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
