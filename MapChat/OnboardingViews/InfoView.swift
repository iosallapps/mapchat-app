//
//  InfoView.swift
//  MapChat
//
//  Created by Cirjan Darius on 09.02.2026.
//

import SwiftUI

struct InfoView: ScreenRepresentable {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "info.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)

            Text("How It Works")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 15) {
                HStack(alignment: .top, spacing: 15) {
                    Image(systemName: "1.circle.fill")
                        .foregroundColor(.blue)
                    Text("Create your profile and set your preferences")
                        .font(.body)
                }

                HStack(alignment: .top, spacing: 15) {
                    Image(systemName: "2.circle.fill")
                        .foregroundColor(.blue)
                    Text("Discover people nearby with similar interests")
                        .font(.body)
                }

                HStack(alignment: .top, spacing: 15) {
                    Image(systemName: "3.circle.fill")
                        .foregroundColor(.blue)
                    Text("Schedule meetings and connect in person")
                        .font(.body)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    InfoView()
}
