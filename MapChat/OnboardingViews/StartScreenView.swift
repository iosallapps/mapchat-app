//
//  StartScreenView.swift
//  MapChat
//
//  Created by Cirjan Darius on 09.02.2026.
//

import SwiftUI

struct StartScreenView: ScreenRepresentable {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "person.3.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)

            Text("Welcome to MapChat")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Connect and meet with people around you")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    StartScreenView()
}
