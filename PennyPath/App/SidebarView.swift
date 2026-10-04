//
//  SidebarView.swift
//  PennyPath
//
//  Created by Eren Akkoç on 16.08.2026.
//

import SwiftUI


struct SidebarView: View {
    @Binding var selection: SidebarItem?
    
    var body: some View {
        List {
            Section {
                ForEach(SidebarItem.allCases) { item in
                    SidebarRow(
                        item: item,
                        isSelected: selection == item
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selection = item
                        }
                    }
                }
                
            }
        }
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
        .background(AppColor.background)
    }
}


// MARK: - Sidebar Row

private struct SidebarRow: View {
    
    let item: SidebarItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isHovering = false
    
    var body: some View {
        
        Button(action: action) {
            
            HStack(spacing: 12) {
                
                Image(systemName: item.systemImage)
                    .font(.system(size: 15, weight: .medium))
                    .frame(
                        width: 20,
                        height: 20
                    )
                
                Text(item.title)
                    .font(.system(
                        size: 13,
                        weight: isSelected ? .semibold : .regular
                    ))
                
                Spacer()
            }
            .foregroundStyle(
                isSelected
                    ? AppColor.accent
                    : AppColor.primaryText
            )
            .frame(maxWidth: .infinity)
            .frame(height: 34)
            .padding(.horizontal, 10)
            .contentShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .background {
            
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    isSelected
                        ? AppColor.accent.opacity(0.14)
                        : isHovering
                            ? AppColor.primaryText.opacity(0.06)
                            : Color.clear
                )
        }
        .overlay {
            
            if isSelected {
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        AppColor.accent.opacity(0.18),
                        lineWidth: 1
                    )
            }
        }
        .onHover { hovering in
            
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
        .animation(
            .easeInOut(duration: 0.15),
            value: isSelected
        )
    }
}

#Preview {
    @Previewable @State var selection: SidebarItem? = .dashboard
    SidebarView(selection: $selection)
}
