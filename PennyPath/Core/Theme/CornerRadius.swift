//
//  CornerRadius.swift
//  PennyPath
//
//  Created by Eren Akkoç on 4.08.2026.
//

import Foundation
import SwiftUI

enum CornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let pill: CGFloat = 999
}

// SwiftUI tarafında kod yazarken hayatı kolaylaştıran dokunuş:
extension View {
    func cornerRadius(_ radius: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}
