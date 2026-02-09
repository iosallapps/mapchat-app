//
//  ScreenRepresentable.swift
//  MapChat
//
//  Created by Cirjan Darius on 09.02.2026.
//

import SwiftUI

protocol ScreenRepresentable: View {
    var backgroundColor: Color { get }

    func onScreenAppear()

    func onScreenDisappear()

    var allowsSwipeNavigation: Bool { get }
}

extension ScreenRepresentable {
    var backgroundColor: Color {
        Color(.systemBackground)
    }

    func onScreenAppear() {
    }

    func onScreenDisappear() {
    }

    var allowsSwipeNavigation: Bool {
        true
    }
}
