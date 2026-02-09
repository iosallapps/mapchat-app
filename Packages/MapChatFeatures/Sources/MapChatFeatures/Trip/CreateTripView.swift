//
//  CreateTripView.swift
//  MapChatFeatures
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI
import MapChatCore
import MapChatDesign

/// View for creating a new trip
public struct CreateTripView: View {
    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: TripViewModel

    @State private var tripName = ""
    @State private var locationName = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(7 * 86400) // 7 days later
    @State private var selectedGroup: Group?
    @State private var availableGroups: [Group] = []
    @State private var showGroupPicker = false
    @State private var tripDescription = ""

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

                ScrollView {
                    VStack(spacing: SpacingTokens.lg) {
                        // Header
                        headerSection

                        // Form fields
                        formSection

                        // Create button
                        MapButton(
                            title: "Create Trip",
                            icon: "checkmark",
                            style: .primary,
                            isLoading: viewModel.isLoading
                        ) {
                            Task {
                                await createTrip()
                            }
                        }
                        .padding(.top, SpacingTokens.lg)
                    }
                    .padding(SpacingTokens.lg)
                }
            }
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .task {
                availableGroups = await viewModel.fetchUserGroups()
            }
        }
    }

    // MARK: - Subviews

    private var headerSection: some View {
        VStack(spacing: SpacingTokens.sm) {
            Image(systemName: "car.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(ColorTokens.primary)

            Text("Plan Your Adventure")
                .font(TypographyTokens.headline)
                .foregroundColor(ColorTokens.textPrimary)
        }
        .padding(.vertical, SpacingTokens.md)
    }

    private var formSection: some View {
        VStack(spacing: SpacingTokens.md) {
            // Trip name
            VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                Text("Trip Name")
                    .font(TypographyTokens.caption)
                    .foregroundColor(ColorTokens.textSecondary)

                MapTextField(
                    placeholder: "e.g., Paris Vacation",
                    text: $tripName,
                    icon: "text.cursor"
                )
            }

            // Location
            VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                Text("Location")
                    .font(TypographyTokens.caption)
                    .foregroundColor(ColorTokens.textSecondary)

                MapTextField(
                    placeholder: "e.g., Paris, France",
                    text: $locationName,
                    icon: "location.fill"
                )
            }

            // Dates
            VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                Text("Start Date")
                    .font(TypographyTokens.caption)
                    .foregroundColor(ColorTokens.textSecondary)

                DatePicker(
                    "",
                    selection: $startDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .labelsHidden()
                .tint(ColorTokens.primary)
                .padding(SpacingTokens.sm)
                .background(ColorTokens.surface)
                .cornerRadius(CornerRadiusTokens.md)
            }

            VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                Text("End Date")
                    .font(TypographyTokens.caption)
                    .foregroundColor(ColorTokens.textSecondary)

                DatePicker(
                    "",
                    selection: $endDate,
                    in: startDate...,
                    displayedComponents: .date
                )
                .labelsHidden()
                .tint(ColorTokens.primary)
                .padding(SpacingTokens.sm)
                .background(ColorTokens.surface)
                .cornerRadius(CornerRadiusTokens.md)
            }

            // Group selection
            VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                Text("Group")
                    .font(TypographyTokens.caption)
                    .foregroundColor(ColorTokens.textSecondary)

                Button(action: { showGroupPicker = true }) {
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(ColorTokens.textSecondary)

                        Text(selectedGroup?.name ?? "Select Group")
                            .font(TypographyTokens.body)
                            .foregroundColor(selectedGroup == nil ? ColorTokens.textSecondary : ColorTokens.textPrimary)

                        Spacer()

                        Image(systemName: "chevron.down")
                            .foregroundColor(ColorTokens.textTertiary)
                    }
                    .padding(SpacingTokens.md)
                    .background(ColorTokens.surface)
                    .cornerRadius(CornerRadiusTokens.md)
                }
            }

            // Description (optional)
            VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                Text("Description (Optional)")
                    .font(TypographyTokens.caption)
                    .foregroundColor(ColorTokens.textSecondary)

                TextEditor(text: $tripDescription)
                    .font(TypographyTokens.body)
                    .foregroundColor(ColorTokens.textPrimary)
                    .frame(height: 100)
                    .padding(SpacingTokens.sm)
                    .background(ColorTokens.surface)
                    .cornerRadius(CornerRadiusTokens.md)
            }
        }
        .confirmationDialog("Select Group", isPresented: $showGroupPicker) {
            ForEach(availableGroups) { group in
                Button(group.name) {
                    selectedGroup = group
                }
            }

            Button("Create New Group") {
                // TODO: Navigate to create group
            }
        }
    }

    // MARK: - Actions

    private func createTrip() async {
        // Validate group selection
        guard let group = selectedGroup else {
            // TODO: Show error
            return
        }

        // Create trip
        let trip = Trip(
            name: tripName,
            locationName: locationName,
            coordinate: Coordinate(latitude: 0, longitude: 0), // TODO: Geocode location
            startDate: startDate,
            endDate: endDate,
            groupId: group.id,
            adminId: UUID(), // TODO: Use current user ID
            description: tripDescription.isEmpty ? nil : tripDescription
        )

        // Validate
        let validation = viewModel.validateTrip(trip)
        guard validation.isValid else {
            // TODO: Show validation error
            return
        }

        // Create
        let success = await viewModel.createTrip(trip)
        if success {
            dismiss()
        }
    }
}

// MARK: - Preview

#Preview {
    CreateTripView(viewModel: .preview)
}
