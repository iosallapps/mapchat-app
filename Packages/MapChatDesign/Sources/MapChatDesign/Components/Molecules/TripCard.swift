//
//  TripCard.swift
//  MapChatDesign
//
//  Created by Claude on 09.02.2026.
//

import SwiftUI
import MapChatCore

/// Trip card component displaying trip information
public struct TripCard: View {
    // MARK: - Properties

    let trip: Trip
    let memberCount: Int?
    let onTap: (() -> Void)?

    // MARK: - Initialization

    public init(
        trip: Trip,
        memberCount: Int? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.trip = trip
        self.memberCount = memberCount
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: SpacingTokens.sm) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                        Text(trip.name)
                            .font(TypographyTokens.headline)
                            .foregroundColor(ColorTokens.textPrimary)
                            .lineLimit(1)

                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 12))

                            Text(trip.locationName)
                                .font(TypographyTokens.caption)
                        }
                        .foregroundColor(ColorTokens.textSecondary)
                    }

                    Spacer()

                    statusBadge
                }

                Divider()
                    .background(ColorTokens.borderSubtle)

                // Date and member info
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 14))

                        Text(trip.dateRangeFormatted)
                            .font(TypographyTokens.caption)
                    }
                    .foregroundColor(ColorTokens.textSecondary)

                    Spacer()

                    if let memberCount = memberCount {
                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 14))

                            Text("\(memberCount)")
                                .font(TypographyTokens.caption)
                        }
                        .foregroundColor(ColorTokens.textSecondary)
                    }
                }

                // Duration
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 14))

                    Text("\(trip.durationDays) days")
                        .font(TypographyTokens.caption)
                }
                .foregroundColor(ColorTokens.textSecondary)
            }
            .padding(SpacingTokens.md)
            .background(ColorTokens.surface)
            .cornerRadius(CornerRadiusTokens.md)
            .shadow(ShadowTokens.sm)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Subviews

    private var statusBadge: some View {
        Group {
            if trip.isActive {
                MapBadge(
                    text: "Active",
                    variant: .success,
                    size: .small,
                    icon: "circle.fill"
                )
            } else if trip.isUpcoming {
                MapBadge(
                    text: "Upcoming",
                    variant: .info,
                    size: .small
                )
            } else {
                MapBadge(
                    text: "Completed",
                    variant: .secondary,
                    size: .small,
                    icon: "checkmark"
                )
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: SpacingTokens.md) {
        TripCard(trip: .sample, memberCount: 5)

        TripCard(
            trip: Trip(
                name: "Tokyo Adventure",
                locationName: "Tokyo, Japan",
                coordinate: Coordinate(latitude: 35.6762, longitude: 139.6503),
                startDate: Calendar.current.date(byAdding: .day, value: 10, to: Date())!,
                endDate: Calendar.current.date(byAdding: .day, value: 20, to: Date())!,
                groupId: UUID(),
                adminId: UUID()
            ),
            memberCount: 3
        )

        TripCard(
            trip: Trip(
                name: "NYC Trip",
                locationName: "New York, USA",
                coordinate: Coordinate(latitude: 40.7128, longitude: -74.0060),
                startDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
                endDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
                groupId: UUID(),
                adminId: UUID()
            )
        )
    }
    .padding()
    .background(ColorTokens.background)
}
