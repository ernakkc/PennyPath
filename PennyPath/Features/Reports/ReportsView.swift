//
//  ReportsView.swift
//  PennyPath
//
//  Created by Eren Akkoç on 12.10.2026.
//

import SwiftUI
import SwiftData

struct ReportsView: View {
    @State private var timeIntervalType: TimeIntervalTypes = .month
    @State private var selectedDate: (Date, Date) = (.now,.now)
    @State private var currentDate: Date = .now
    
    var body: some View {
        VStack {
            /// HEADER
            Text("Raporlar")
                .font(.system(size: 32)).bold()
                .foregroundStyle(AppColor.primaryText)
                .padding(.bottom, 16)
            
            /// INTERVAL BUTTONS
            TimeIntervalTypePickerCard(timeIntervalType: $timeIntervalType, selectedDate: $selectedDate)
            
            /// INTERVAL PICKER
            HStack {
                Button(action: { ayDegistir(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Text(formattedDate(currentDate: currentDate))
                    .font(.title3)
                    .fontWeight(.bold)
                    .id(formattedDate(currentDate: currentDate))
                    .transition(.opacity)
                
                Button(action: { ayDegistir(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
            }
        }
    }
    
    private func ayDegistir(by deger: Int) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if let yeniTarih = Calendar.current.date(byAdding: .month, value: deger, to: currentDate) {
                currentDate = yeniTarih
            }
        }
    }
}
