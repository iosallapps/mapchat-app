//
//  OnboardingFlowView.swift
//  MapChat
//
//  Created by Cirjan Darius on 09.02.2026.
//

import SwiftUI

struct OnboardingFlowView: View {
    @State private var currentIndex = 0
    let views: [AnyView]
    let onComplete: () -> Void

    init(views: [any ScreenRepresentable], onComplete: @escaping () -> Void) {
        self.views = views.map { AnyView($0) }
        self.onComplete = onComplete
    }

    var body: some View {
        ZStack {
            // Display current view
            views[currentIndex]

            // Continue button fixed at bottom
            VStack {
                Spacer()

                Button(action: moveForward) {
                    Text(isLastScreen ? "Get Started" : "Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
    }

    private var isLastScreen: Bool {
        currentIndex == views.count - 1
    }

    private func moveForward() {
        if isLastScreen {
            onComplete()
        } else {
            withAnimation {
                currentIndex += 1
            }
        }
    }
}

#Preview {
    OnboardingFlowView(
        views: MapChatApp.obFlows,
        onComplete: { print("Onboarding completed") }
    )
}
