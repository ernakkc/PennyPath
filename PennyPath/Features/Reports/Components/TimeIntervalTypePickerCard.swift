//
//  TimeIntervalTypePickerCard.swift
//  PennyPath
//
//  Created by Eren Akkoç on 15.10.2026.
//

import SwiftUI

struct TimeIntervalTypePickerCard: View {
    @Binding var timeIntervalType: TimeIntervalTypes
    
    @Namespace private var animation
    
    var body: some View {
        
        HStack(spacing: 0) {
            ForEach(TimeIntervalTypes.allCases, id: \.self) { secenek in
                Button(action: {withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    timeIntervalType = secenek
                }
                }) {
                    Text(secenek.rawValue)
                        .font(.subheadline)
                        .fontWeight(timeIntervalType == secenek ? .semibold : .medium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundStyle(timeIntervalType == secenek ? .white : .primary.opacity(0.7))
                        .background {
                            if timeIntervalType == secenek {
                                Capsule()
                                    .fill(Color.accentColor)
                                    .matchedGeometryEffect(id: "TimeTab", in: animation)
                            }
                        }
                        .contentShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        
        
    }
}


enum TimeIntervalTypes: String, CaseIterable, Codable, Identifiable {
    case month = "Ay"
    case year = "Yıl"
    
    var id: String { rawValue }
}



#Preview {
    @Previewable @State var previewTimeIntervalType: TimeIntervalTypes = .month
    
    TimeIntervalTypePickerCard(timeIntervalType: $previewTimeIntervalType)
}

