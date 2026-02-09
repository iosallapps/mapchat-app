//
//  MapChatApp.swift
//  MapChat
//
//  Created by Cirjan Darius on 09.02.2026.
//

import SwiftUI
import CoreData

@main
struct MapChatApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var dependencies = DependencyContainer.shared

    let persistenceController = PersistenceController.shared

    static var obFlows: [any ScreenRepresentable] {
        [
            StartScreenView(),
            InfoView(),
            FinalView()
        ]
    }

    init() {
        // Configure dependencies on app launch
        Task { @MainActor in
            DependencyContainer.shared.configure()
        }
    }

    var body: some Scene {
        WindowGroup {
            if appState.hasCompletedOnboarding {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(appState)
                    .environmentObject(coordinator)
                    .environmentObject(dependencies)
            } else {
                OnboardingFlowView(
                    views: MapChatApp.obFlows,
                    onComplete: {
                        appState.completeOnboarding()
                    }
                )
            }
        }
    }
}
