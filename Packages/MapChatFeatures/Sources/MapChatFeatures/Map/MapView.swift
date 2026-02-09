//
//  MapView.swift
//  MapChatFeatures
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI
import MapChatCore
import MapChatDesign

/// Main map view displaying user locations
public struct MapView: View {
    // MARK: - Properties

    @State private var viewModel: MapViewModel
    @State private var selectedUser: User?
    @State private var showNavigationOptions = false

    // MARK: - Initialization

    public init(viewModel: MapViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            // Map container (placeholder until MapBox integration)
            mapPlaceholder

            // Top bar with group selector
            VStack {
                topBar
                Spacer()
            }

            // Loading overlay
            if viewModel.isLoading {
                loadingOverlay
            }
        }
        .task {
            await viewModel.startTracking()
            await viewModel.loadGroups()
            await viewModel.refreshLocations()
        }
        .sheet(isPresented: $showNavigationOptions) {
            if let user = selectedUser, let location = user.currentLocation {
                NavigationOptionsSheet(location: location, viewModel: viewModel)
            }
        }
    }

    // MARK: - Subviews

    private var topBar: some View {
        HStack {
            // Group selector
            if !viewModel.availableGroups.isEmpty {
                GroupSelectorView(
                    groups: viewModel.availableGroups,
                    selectedGroup: viewModel.selectedGroup
                ) { group in
                    viewModel.selectGroup(group)
                }
            }

            Spacer()

            // Tracking status
            if viewModel.isTrackingLocation {
                HStack(spacing: 4) {
                    Circle()
                        .fill(ColorTokens.success)
                        .frame(width: 8, height: 8)

                    Text("Tracking")
                        .font(TypographyTokens.caption)
                        .foregroundColor(ColorTokens.textSecondary)
                }
                .padding(.horizontal, SpacingTokens.sm)
                .padding(.vertical, SpacingTokens.xs)
                .background(ColorTokens.surface)
                .cornerRadius(CornerRadiusTokens.sm)
            }
        }
        .padding(SpacingTokens.md)
    }

    private var mapPlaceholder: some View {
        ZStack {
            ColorTokens.surface
                .ignoresSafeArea()

            VStack(spacing: SpacingTokens.lg) {
                Image(systemName: "map.fill")
                    .font(.system(size: 60))
                    .foregroundColor(ColorTokens.primary)

                Text("Map View")
                    .font(TypographyTokens.title2)
                    .foregroundColor(ColorTokens.textPrimary)

                Text("MapBox integration coming soon")
                    .font(TypographyTokens.body)
                    .foregroundColor(ColorTokens.textSecondary)

                // Show user locations list
                if !viewModel.userLocations.isEmpty {
                    VStack(spacing: SpacingTokens.sm) {
                        Text("Active Locations:")
                            .font(TypographyTokens.headline)
                            .foregroundColor(ColorTokens.textPrimary)

                        ForEach(viewModel.userLocations, id: \.userId) { location in
                            LocationPinView(location: location) {
                                selectedUser = User.sample // TODO: Fetch actual user
                                showNavigationOptions = true
                            }
                        }
                    }
                    .padding(SpacingTokens.lg)
                }
            }
        }
    }

    private var loadingOverlay: some View {
        ZStack {
            ColorTokens.overlay
                .ignoresSafeArea()

            ProgressView()
                .tint(ColorTokens.primary)
                .scaleEffect(1.5)
        }
    }
}

// MARK: - Location Pin View

struct LocationPinView: View {
    let location: UserLocation
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: SpacingTokens.sm) {
                Image(systemName: "location.fill")
                    .foregroundColor(ColorTokens.primary)

                VStack(alignment: .leading, spacing: 2) {
                    Text("User Location")
                        .font(TypographyTokens.bodyBold)
                        .foregroundColor(ColorTokens.textPrimary)

                    Text("Updated \(location.timestamp.timeAgoString)")
                        .font(TypographyTokens.caption)
                        .foregroundColor(ColorTokens.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(ColorTokens.textTertiary)
            }
            .padding(SpacingTokens.md)
            .background(ColorTokens.surface)
            .cornerRadius(CornerRadiusTokens.md)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Group Selector View

struct GroupSelectorView: View {
    let groups: [Group]
    let selectedGroup: Group?
    let onSelect: (Group?) -> Void

    @State private var showPicker = false

    var body: some View {
        Button(action: { showPicker = true }) {
            HStack(spacing: 4) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 14))

                Text(selectedGroup?.name ?? "All Friends")
                    .font(TypographyTokens.bodyBold)

                Image(systemName: "chevron.down")
                    .font(.system(size: 12))
            }
            .foregroundColor(ColorTokens.textPrimary)
            .padding(.horizontal, SpacingTokens.md)
            .padding(.vertical, SpacingTokens.sm)
            .background(ColorTokens.surface)
            .cornerRadius(CornerRadiusTokens.md)
        }
        .confirmationDialog("Select Group", isPresented: $showPicker) {
            Button("All Friends") {
                onSelect(nil)
            }

            ForEach(groups) { group in
                Button(group.name) {
                    onSelect(group)
                }
            }
        }
    }
}

// MARK: - Navigation Options Sheet

struct NavigationOptionsSheet: View {
    let location: UserLocation
    let viewModel: MapViewModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: SpacingTokens.lg) {
                // Location info
                VStack(spacing: SpacingTokens.sm) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 40))
                        .foregroundColor(ColorTokens.primary)

                    Text("Navigate to Location")
                        .font(TypographyTokens.headline)
                        .foregroundColor(ColorTokens.textPrimary)

                    Text("Updated \(location.timestamp.timeAgoString)")
                        .font(TypographyTokens.caption)
                        .foregroundColor(ColorTokens.textSecondary)
                }
                .padding(.top, SpacingTokens.xl)

                // Navigation options
                VStack(spacing: SpacingTokens.sm) {
                    ForEach(NavigationApp.allCases, id: \.self) { app in
                        MapButton(
                            title: app.title,
                            icon: app.icon,
                            style: .outline
                        ) {
                            viewModel.openNavigation(to: location, using: app)
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, SpacingTokens.lg)

                Spacer()
            }
            .background(ColorTokens.background)
            .navigationTitle("Navigation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Preview

#Preview {
    MapView(viewModel: .preview)
}
