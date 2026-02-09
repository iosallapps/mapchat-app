//
//  TripHistoryView.swift
//  MapChatFeatures
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI
import MapChatCore
import MapChatDesign

/// View showing past trips with search and filtering
public struct TripHistoryView: View {
    // MARK: - Properties

    @State private var viewModel: TripViewModel
    @State private var searchText = ""
    @State private var selectedTrip: Trip?

    // MARK: - Initialization

    public init(viewModel: TripViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            ColorTokens.background
                .ignoresSafeArea()

            if filteredPastTrips.isEmpty {
                emptyStateView
            } else {
                tripListContent
            }
        }
        .navigationTitle("Trip History")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search trips...")
    }

    // MARK: - Computed Properties

    private var filteredPastTrips: [Trip] {
        let past = viewModel.pastTrips

        guard !searchText.isEmpty else { return past }

        return past.filter { trip in
            trip.name.localizedCaseInsensitiveContains(searchText) ||
            trip.locationName.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Subviews

    private var tripListContent: some View {
        ScrollView {
            LazyVStack(spacing: SpacingTokens.sm) {
                ForEach(filteredPastTrips) { trip in
                    TripCard(trip: trip)
                        .padding(.horizontal, SpacingTokens.md)
                        .onTapGesture {
                            selectedTrip = trip
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                Task {
                                    await deleteTrip(trip)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .padding(.vertical, SpacingTokens.md)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: SpacingTokens.lg) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(ColorTokens.textSecondary)

            Text("No Past Trips")
                .font(TypographyTokens.headline)
                .foregroundColor(ColorTokens.textPrimary)

            Text(searchText.isEmpty ?
                 "Your completed trips will appear here" :
                 "No trips found matching '\(searchText)'"
            )
            .font(TypographyTokens.body)
            .foregroundColor(ColorTokens.textSecondary)
            .multilineTextAlignment(.center)
        }
        .padding(SpacingTokens.xl)
    }

    // MARK: - Actions

    private func deleteTrip(_ trip: Trip) async {
        _ = await viewModel.deleteTrip(id: trip.id)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TripHistoryView(viewModel: .preview)
    }
}
