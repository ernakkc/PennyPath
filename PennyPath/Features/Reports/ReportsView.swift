//
//  ReportsView.swift
//  PennyPath
//
//  Created by Eren Akkoç on 12.10.2026.
//

import SwiftUI
import SwiftData
import Charts

struct ReportsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.date)
    private var allTransactions: [Transaction]
    
    @State private var timeIntervalType: TimeIntervalTypes = .month
    @State private var selectedDate: (Date, Date) = (.now, .now)
    @State private var currentDate: Date = .now
    
    // MARK: - Computed Properties
    private var filteredTransactions: [Transaction] {
        allTransactions.filter { $0.date >= selectedDate.0 && $0.date <= selectedDate.1 }
    }
    private var totalIncome: Decimal {
        filteredTransactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    private var totalExpense: Decimal {
        filteredTransactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    private var balance: Decimal { totalIncome - totalExpense }
    
    private var categoryBreakdown: [(category: Category, total: Decimal)] {
        let dict = Dictionary(grouping: filteredTransactions, by: { $0.category })
        return dict
            .map { ($0.key, $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.total > $1.total }
    }
    
    private var trendData: [(label: String, income: Decimal, expense: Decimal)] {
        // Group by month/year depending on selection type
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredTransactions) { (tx: Transaction) -> String in
            switch timeIntervalType {
            case .month:
                let comps = calendar.dateComponents([.year, .month], from: tx.date)
                return String(format: "%04d-%02d", comps.year ?? 0, comps.month ?? 0)
            case .year:
                let comps = calendar.dateComponents([.year], from: tx.date)
                return String(format: "%04d", comps.year ?? 0)
            }
        }
        return grouped.keys.sorted().compactMap { key in
            let groupTxs = grouped[key] ?? []
            let income = groupTxs.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
            let expense = groupTxs.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
            return (key, income, expense)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                /// HEADER
                Text("Raporlar")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(AppColor.primaryText)
                    .padding(.bottom, 8)
                
                /// INTERVAL BUTTONS
                TimeIntervalTypePickerCard(timeIntervalType: $timeIntervalType)
                    .padding(.bottom, 8)
                
                /// INTERVAL PICKER & NAVIGATION
                IntervalNavigationCard(
                    timeIntervalType: $timeIntervalType,
                    selectedDate: $selectedDate,
                    currentDate: $currentDate
                )
                
                /// SUMMARY CARDS
                HStack(spacing: 16) {
                    SummaryCard(title: "Gelir", value: totalIncome, icon: "arrow.down.circle", color: AppColor.income)
                    SummaryCard(title: "Gider", value: totalExpense, icon: "arrow.up.circle", color: AppColor.expense)
                    SummaryCard(title: "Bakiye", value: balance, icon: "equal.circle", color: AppColor.accent)
                }
                .padding(.vertical, 4)
                
                /// TREND CHART
                if !trendData.isEmpty {
                    GroupBox {
                        Chart {
                            ForEach(trendData, id: \.label) { item in
                                BarMark(
                                    x: .value("Dönem", item.label),
                                    y: .value("Gelir", NSDecimalNumber(decimal: item.income).doubleValue)
                                )
                                .foregroundStyle(AppColor.income)
                                BarMark(
                                    x: .value("Dönem", item.label),
                                    y: .value("Gider", NSDecimalNumber(decimal: item.expense).doubleValue)
                                )
                                .foregroundStyle(AppColor.expense)
                            }
                        }
                        .frame(height: 200)
                        .padding(.top, 8)
                    } label: {
                        HStack { Image(systemName: "chart.bar"); Text("Dönemsel Gelir & Gider") }
                    }
                    .padding(.bottom, 12)
                }
                
                /// CATEGORY BREAKDOWN
                if !categoryBreakdown.isEmpty {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(categoryBreakdown, id: \.category) { cat, total in
                                HStack(spacing: 8) {
                                    Image(systemName: cat.iconName)
                                        .foregroundStyle(AppColor.accent)
                                        .frame(width: 28)
                                    Text(cat.rawValue)
                                        .font(.body)
                                    Spacer()
                                    Text(total, format: .currency(code: "TRY"))
                                        .bold()
                                        .foregroundStyle(cat == .salary || cat == .investment ? AppColor.income : AppColor.expense)
                                }
                            }
                        }
                        .padding(.top, 2)
                    } label: {
                        HStack { Image(systemName: "list.bullet.rectangle"); Text("Kategoriye Göre Dağılım") }
                    }
                }
                else {
                    Text("Bu dönemde kayıt bulunamadı.")
                        .foregroundStyle(.secondary)
                        .padding(.top, 24)
                }
            }
            .padding()
        }
        .background(AppColor.background)
        .animation(.easeInOut, value: timeIntervalType)
        .animation(.easeInOut, value: selectedDate.0)
        .animation(.easeInOut, value: selectedDate.1)
    }
}

// MARK: - Summary Card
struct SummaryCard: View {
    var title: String
    var value: Decimal
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
                .shadow(radius: 4, x: 0, y: 2)
                .padding(10)
                .background(color.gradient)
                .clipShape(Circle())
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
            Text(value, format: .currency(code: "TRY"))
                .font(.title3.bold())
                .foregroundStyle(color)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: color.opacity(0.09), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Interval Navigation Card (Custom for this screen)
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
    ReportsView()
}
