//
//  PrimaryButton.swift
//  PennyPath
//
//  Created by Eren Akkoç on 5.08.2026.
//

import SwiftUI

// 1. Butonun Görsel Stil Tanımı
struct PrimaryButtonStyle: ButtonStyle {
    var tint: Color = AppColor.accent
    var cornerRadius: CGFloat = CornerRadius.cornerMedium
    var minHeight: CGFloat = 52
    
    // Butonun tıklanabilir (aktif/inaktif) durumunu dinliyoruz
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(minHeight: minHeight) // Erişilebilirlik için dinamik yükseklik
            .padding(.horizontal, 16)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [tint, tint.opacity(0.82)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .overlay {
                        // İç parlama çizgisi
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .stroke(LinearGradient(colors: [.white.opacity(0.35), .white.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                    }
            }
            // Efektler ve Gölgeler
            .shadow(color: isEnabled ? tint.opacity(isPressed ? 0.15 : 0.35) : .clear, radius: isPressed ? 6 : 14, y: isPressed ? 3 : 7)
            .shadow(color: isEnabled ? .black.opacity(0.20) : .clear, radius: isPressed ? 3 : 8, y: isPressed ? 2 : 4)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .brightness(isPressed ? -0.04 : 0)
            // Disabled (inaktif) durumu için görünüm değişiklikleri
            .opacity(isEnabled ? 1.0 : 0.5)
            .saturation(isEnabled ? 1.0 : 0.6)
            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: isPressed)
            .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}

// 2. SwiftUI Butonlarına Kolay Erişim İçin Extension
extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
    
    static func primary(tint: Color) -> PrimaryButtonStyle {
        PrimaryButtonStyle(tint: tint)
    }
}

#Preview {
    VStack(spacing: 24) {
        Button("Devam Et") {
            print("Normal buton tetiklendi")
        }
        .buttonStyle(.primary)
        
        
        Button("Özel Renk Kullanımı") {
            print("Renkli buton tetiklendi")
        }
        .buttonStyle(.primary(tint: .indigo))
        
        Button("Tıklanamaz Durum (Disabled)") {
            print("Bu tetiklenmeyecek")
        }
        .buttonStyle(.primary)
        .disabled(true)
    }
    .padding()
}
