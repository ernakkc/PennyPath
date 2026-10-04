//
//  PrimaryButton.swift
//  PennyPath
//
//  Created by Eren Akkoç on 5.08.2026.
//

import SwiftUI

// 1. Butonun Görsel Stil Tanımı (Tüm efektler, gölgeler ve animasyonlar burada)
struct PrimaryButtonStyle: ButtonStyle {
    var tint: Color = .blue // AppColor.accent
    var height: CGFloat = 52
    
    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        
        configuration.label
            .font(.headline) // Üstte sabitlediğimiz font
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background {
                RoundedRectangle(cornerRadius: .spMD, style: .continuous) // CornerRadius.medium (16)
                    .fill(
                        LinearGradient(
                            colors: [tint, tint.opacity(0.82)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        // İç parlama çizgisi
                        RoundedRectangle(cornerRadius: .spMD, style: .continuous)
                            .stroke(LinearGradient(colors: [.white.opacity(0.35), .white.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                    }
            }
            // Efektler ve Gölgeler (isPressed durumuna göre otomatik tetiklenir)
            .shadow(color: tint.opacity(isPressed ? 0.15 : 0.35), radius: isPressed ? 6 : 14, y: isPressed ? 3 : 7)
            .shadow(color: .black.opacity(0.20), radius: isPressed ? 3 : 8, y: isPressed ? 2 : 4)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .brightness(isPressed ? -0.04 : 0)
            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: isPressed)
    }
}

// 2. SwiftUI Butonlarına Kolay Erişim İçin Extension
extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
    
    static func primary(tint: Color) -> PrimaryButtonStyle {
        PrimaryButtonStyle(tint: tint)
    }
}



