//
//  AppCard.swift
//  PennyPath
//
//  Created by Eren Akkoç on 5.08.2026.
//


import SwiftUI

struct AppCard<Content: View>: View {

    @ViewBuilder
    let content: Content

    var body: some View {
        content
            .padding(Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColor.backgroundSecondary)
            .overlay {
                RoundedRectangle(cornerRadius: CornerRadius.medium)
                    .stroke(AppColor.border, lineWidth: 1)
            }
            .clipShape(
                RoundedRectangle(cornerRadius: CornerRadius.medium)
            )
    }
}
