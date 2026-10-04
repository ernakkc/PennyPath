//
//  CornerRadius.swift
//  PennyPath
//
//  Created by Eren Akkoç on 4.08.2026.
//

import Foundation
import SwiftUI

enum CornerRadius {
    static let cornerSmall: CGFloat = 8
    static let cornerMedium: CGFloat = 16
    static let cornerLarge: CGFloat = 24
    static let cornerPill: CGFloat = 999
    
}

// SwiftUI tarafında kod yazarken hayatı kolaylaştıran dokunuş:
extension View {
    func cornerRadius(_ radius: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

// SwiftUI Extension
extension CGFloat {
    static let cornerSmall: CGFloat = CornerRadius.cornerSmall
    static let cornerMedium: CGFloat = CornerRadius.cornerMedium
    static let cornerLarge: CGFloat = CornerRadius.cornerLarge
    static let cornerPill: CGFloat = CornerRadius.cornerPill
}
