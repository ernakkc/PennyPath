//
//  PrimaryButton.swift
//  PennyPath
//
//  Created by Eren Akkoç on 5.08.2026.
//

import SwiftUI

struct ButtonComp: View {

    // MARK: - Properties

    let title: String
    let action: () -> Void

    // Appearance
    var systemImage: String? = nil

    var tint: Color = AppColor.accent
    var foregroundColor: Color = .white

    var height: CGFloat = 52
    var cornerRadius: CGFloat = 16

    var font: Font = AppFont.headline
    var iconSize: CGFloat = 16

    var horizontalPadding: CGFloat = 18

    // Effects
    var showGlow: Bool = true
    var showShadow: Bool = true

    @State private var isPressed = false

    // MARK: - Body

    var body: some View {
        Button {
            action()
        } label: {

            HStack(spacing: 9) {

                if let systemImage {
                    Image(systemName: systemImage)
                        .font(
                            .system(
                                size: iconSize,
                                weight: .semibold
                            )
                        )
                }

                Text(title)
                    .font(font)
                    .lineLimit(1)
            }
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .padding(.horizontal, horizontalPadding)
            .background {

                RoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: .continuous
                )
                .fill(
                    LinearGradient(
                        colors: [
                            tint.opacity(1.0),
                            tint.opacity(0.82)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {

                    RoundedRectangle(
                        cornerRadius: cornerRadius,
                        style: .continuous
                    )
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.35),
                                .white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
                }
                .overlay {

                    RoundedRectangle(
                        cornerRadius: cornerRadius,
                        style: .continuous
                    )
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.12),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                }
            }
            .shadow(
                color: showGlow
                    ? tint.opacity(isPressed ? 0.15 : 0.35)
                    : .clear,
                radius: isPressed ? 6 : 14,
                y: isPressed ? 3 : 7
            )
            .shadow(
                color: showShadow
                    ? .black.opacity(0.20)
                    : .clear,
                radius: isPressed ? 3 : 8,
                y: isPressed ? 2 : 4
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .brightness(isPressed ? -0.04 : 0)
        }
        .buttonStyle(.plain)
        .contentShape(
            RoundedRectangle(
                cornerRadius: cornerRadius,
                style: .continuous
            )
        )
        .animation(
            .spring(
                response: 0.25,
                dampingFraction: 0.65
            ),
            value: isPressed
        )
        .onLongPressGesture(
            minimumDuration: 0,
            maximumDistance: .infinity,
            pressing: { pressing in
                isPressed = pressing
            },
            perform: {}
        )
    }
}
