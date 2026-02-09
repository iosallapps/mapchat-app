//
//  TripListView.swift
//  MapChatFeatures
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI
import MapChatCore
import MapChatDesign

/// Main trips list view with categorization
public struct TripListView: View {
    // MARK: - Properties

    @State private var viewModel: TripViewModel
    @State private var showCreateTrip = false
    @State private var showHistory = false

    // MARK: - Initialization

    public init(viewModel: TripViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    // MARK: - Body

    public var body: some View {
        NavigationStack {
            ZStack {
                ColorTokens.background
                    .ignoresSafeArea()

                if viewModel.trips.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    tripListContent
                }

                if viewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationTitle("Trips")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showHistory = true }) {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(ColorTokens.primary)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showCreateTrip = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(ColorTokens.primary)
                    }
                }
            }
            .sheet(isPresented: $showCreateTrip) {
                CreateTripView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $showHistory) {
                TripHistoryView(viewModel: viewModel)
            }
            .task {
                await viewModel.loadTrips()
            }
        }
    }

    // MARK: - Subviews

    private var tripListContent: some View {
        ScrollView {
            VStack(spacing: SpacingTokens.lg) {
                // Search bar
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal, SpacingTokens.md)

                // Active trips
                if !viewModel.activeTrips.isEmpty {
                    tripSection(
                        title: "Active Trips",
                        trips: viewModel.activeTrips,
                        icon: "circle.fill",
                        color: ColorTokens.success
                    )
                }

                // Upcoming trips
                if !viewModel.upcomingTrips.isEmpty {
                    tripSection(
                        title: "Upcoming",
                        trips: viewModel.upcomingTrips,
                        icon: "calendar",
                        color: ColorTokens.info
                    )
                }

                // Recent past trips
                if !viewModel.pastTrips.isEmpty {
                    let recentPast = Array(viewModel.pastTrips.prefix(3))
                    tripSection(
                        title: "Recent",
                        trips: recentPast,
                        icon: "checkmark.circle",
                        color: ColorTokens.textSecondary
                    )
                }
            }
            .padding(.vertical, SpacingTokens.md)
        }
    }

    private func tripSection(
        title: String,
        trips: [Trip],
        icon: String,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: SpacingTokens.sm) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 14))

                Text(title)
                    .font(TypographyTokens.headline)
                    .foregroundColor(ColorTokens.textPrimary)

                Spacer()

                Text("\(trips.count)")
                    .font(TypographyTokens.caption)
                    .foregroundColor(ColorTokens.textSecondary)
            }
            .padding(.horizontal, SpacingTokens.md)

            ForEach(trips) { trip in
                NavigationLink(value: trip) {
                    TripCard(trip: trip, memberCount: 5)
                        .padding(.horizontal, SpacingTokens.md)
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: SpacingTokens.xl) {
            Image(systemName: "car.fill")
                .font(.system(size: 80))
                .foregroundColor(ColorTokens.primary)

            Text("No Trips Yet")
                .font(TypographyTokens.title2)
                .foregroundColor(ColorTokens.textPrimary)

            Text("Create your first trip to start tracking your adventures")
                .font(TypographyTokens.body)
                .foregroundColor(ColorTokens.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, SpacingTokens.xl)

            MapButton(
                title: "Create Trip",
                icon: "plus",
                style: .primary
            ) {
                showCreateTrip = true
            }
            .padding(.horizontal, SpacingTokens.xl)
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

// MARK: - Preview

#Preview {
    TripListView(viewModel: .preview)
}
