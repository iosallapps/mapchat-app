//
//  MeetlyApp.swift
//  Meetly
//
//  Created by Vlad Tudosoiu on 09.02.2026.
//

import SwiftUI
import CoreData

@main
struct MeetlyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
