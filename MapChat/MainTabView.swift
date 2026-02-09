//
//  MainTabView.swift
//  MapChat
//
//  Created by Cirjan Darius on 09.02.2026.
//

import SwiftUI
import CoreData
import MapChatCore

// Commented out until packages are properly linked
// import MapChatFeatures

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var dependencies: DependencyContainer

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            // Map Tab
            MapTabView()
                .tabItem {
                    Label(
                        AppCoordinator.Tab.map.title,
                        systemImage: AppCoordinator.Tab.map.icon
                    )
                }
                .tag(AppCoordinator.Tab.map)

            // Trip Tab
            TripTabView()
                .tabItem {
                    Label(
                        AppCoordinator.Tab.trip.title,
                        systemImage: AppCoordinator.Tab.trip.icon
                    )
                }
                .tag(AppCoordinator.Tab.trip)

            // Chat Tab
            ChatTabView()
                .tabItem {
                    Label(
                        AppCoordinator.Tab.chat.title,
                        systemImage: AppCoordinator.Tab.chat.icon
                    )
                }
                .tag(AppCoordinator.Tab.chat)
        }
        .tint(.green) // Radiant green theme color
    }
}

// MARK: - Tab Views

struct MapTabView: View {
    @EnvironmentObject private var dependencies: DependencyContainer

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 20) {
                    Image(systemName: "map.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)

                    Text("Map View")
                        .font(.title)
                        .foregroundColor(.white)

                    Text("Real-time location tracking")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()

                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRow(icon: "location.fill", text: "Track friends in real-time")
                        FeatureRow(icon: "person.2.fill", text: "Group-based filtering")
                        FeatureRow(icon: "map.circle", text: "External navigation (Waze, Apple Maps, Google Maps)")
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal, 32)
                }
            }
            .navigationTitle("Map")
            .navigationBarTitleDisplayMode(.inline)
        }
        // TODO: Uncomment when MapChatFeatures package is linked
        // MapView(viewModel: MapViewModel(
        //     locationService: dependencies.locationService,
        //     groupService: dependencies.groupService
        // ))
    }
}

struct TripTabView: View {
    @EnvironmentObject private var dependencies: DependencyContainer

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 20) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)

                    Text("Trips")
                        .font(.title)
                        .foregroundColor(.white)

                    Text("Create and manage your trips")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()

                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRow(icon: "calendar", text: "Plan trips with dates & locations")
                        FeatureRow(icon: "person.3.fill", text: "Create travel groups")
                        FeatureRow(icon: "clock.arrow.circlepath", text: "View trip history")
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal, 32)
                }
            }
            .navigationTitle("Trips")
            .navigationBarTitleDisplayMode(.inline)
        }
        // TODO: Uncomment when MapChatFeatures package is linked
        // TripListView(viewModel: TripViewModel(
        //     tripService: dependencies.tripService,
        //     groupService: dependencies.groupService
        // ))
    }
}

struct ChatTabView: View {
    @EnvironmentObject private var dependencies: DependencyContainer

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 20) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)

                    Text("Chat")
                        .font(.title)
                        .foregroundColor(.white)

                    Text("Connect with your travel buddies")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()

                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRow(icon: "text.bubble.fill", text: "WhatsApp-style messaging")
                        FeatureRow(icon: "photo", text: "Share photos, videos, voice")
                        FeatureRow(icon: "phone.fill", text: "Voice/video calls (WebRTC)")
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal, 32)
                }
            }
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.inline)
        }
        // TODO: Uncomment when MapChatFeatures package is linked
        // ChatListView(viewModel: ChatViewModel(
        //     chatService: dependencies.chatService
        // ))
    }
}

// MARK: - Helper Views

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.green)
                .frame(width: 24)

            Text(text)
                .font(.body)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AppCoordinator())
        .environmentObject(DependencyContainer.shared)
}
