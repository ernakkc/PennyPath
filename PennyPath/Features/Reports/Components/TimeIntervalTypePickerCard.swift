//
//  TimeIntervalTypePickerCard.swift
//  PennyPath
//
//  Created by Eren Akkoç on 15.10.2026.
//

import SwiftUI

struct TimeIntervalTypePickerCard: View {
    @Binding var timeIntervalType: TimeIntervalTypes
    @Binding var selectedDate: (Date, Date)
    
    
    var body: some View {
        VStack(spacing: 30) {
            // Yan Yana Picker (Segmented Style)
            Picker("Zaman Dilimi", selection: $timeIntervalType) {
                ForEach(TimeIntervalTypes.allCases, id: \.self) { secenek in
                    Text(secenek.rawValue).tag(secenek)
                }
            }
            .pickerStyle(.segmented)
            .padding()
               
            
            // silinecek
            Text("Seçilen Süre: \(timeIntervalType.rawValue)")
                .font(.subheadline)
                .foregroundColor(.secondary)
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
    @Previewable @State var previewSelectedDate: (Date, Date) = (.now, .now)
    
    TimeIntervalTypePickerCard(timeIntervalType: $previewTimeIntervalType, selectedDate: $previewSelectedDate)
}

