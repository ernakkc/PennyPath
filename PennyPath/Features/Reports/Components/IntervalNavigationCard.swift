//
//  IntervalNavigationCard.swift
//  PennyPath
//
//  Created by Eren Akkoç on 15.10.2026.
//

import SwiftUI

struct IntervalNavigationCard: View {
    @Binding var timeIntervalType: TimeIntervalTypes
    @Binding var selectedDate: (Date, Date)
    @Binding var currentDate: Date
    
    var body: some View {
        HStack {
            Button(action: { changeDate(by: -1) }) {
                Image(systemName: "chevron.left")
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
            }
            
            Spacer()
            Text(intervalTitle)
                .font(.title3.bold())
            Spacer()
            Button(action: { changeDate(by: 1) }) {
                Image(systemName: "chevron.right")
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
            }
        }
        .padding(.vertical, 10)
        .background(AppColor.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(AppColor.border.opacity(0.4), lineWidth: 1)
        )
        .onAppear { updateSelectedDate() }
    }
    
    private var intervalTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        switch timeIntervalType {
        case .month:
            formatter.dateFormat = "LLLL yyyy"
            return formatter.string(from: currentDate).capitalized
        case .year:
            formatter.dateFormat = "yyyy"
            return formatter.string(from: currentDate)
        }
    }
    
    private func changeDate(by value: Int) {
        withAnimation(.easeInOut(duration: 0.2)) {
            let calendar = Calendar.current
            switch timeIntervalType {
            case .month:
                if let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) {
                    currentDate = newDate
                }
            case .year:
                if let newDate = calendar.date(byAdding: .year, value: value, to: currentDate) {
                    currentDate = newDate
                }
            }
            updateSelectedDate()
        }
    }
    private func updateSelectedDate() {
        let calendar = Calendar.current
        switch timeIntervalType {
        case .month:
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) ?? currentDate
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) ?? currentDate
            selectedDate = (startOfMonth, endOfMonth)
        case .year:
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: currentDate)) ?? currentDate
            let endOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear) ?? currentDate
            selectedDate = (startOfYear, endOfYear)
        }
    }
}


#Preview {
    IntervalNavigationCard(timeIntervalType: <#T##TimeIntervalTypes#>, selectedDate: <#T##(Date, Date)#>, currentDate: <#T##Date#>)
}
