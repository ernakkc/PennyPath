//
//  GraphCard.swift
//  PennyPath
//
//  Created by Eren Akkoç on 5.10.2026.
//

import SwiftUI
import SwiftData
import Charts

struct GraphCard: View {
    @Query(sort: \Transaction.date, order: .forward)
    private var transactions: [Transaction]
    
    var balance: Decimal { balanceCalc(transactions: transactions) }
    var balanceHistory: [BalanceHistory] { balancePoints(transactions: transactions)}
    
    var body: some View {
        AppCard {
            VStack (alignment: .leading){
                Text("Toplam Bakiye").font(AppFont.headline).foregroundStyle(AppColor.secondaryText).padding(.spXS)
                Text(balance.formatted(.currency(code: "TRY"))).font(.system(size: 35).bold()).padding(.spXS)
                BalanceChartView(balanceHistory: balanceHistory).padding(.spXS)
            }
            
            
        }
        .foregroundColor(AppColor.primaryText)
    }
}

//MARK: - CHART
struct BalanceChartView: View {
    let balanceHistory: [BalanceHistory]
    private var minBalance: Decimal { balanceHistory.map(\.balance).min() ?? 0 }
    private var maxBalance: Decimal { balanceHistory.map(\.balance).max() ?? 0 }
    private var chartMin: Decimal { minBalance - max((minBalance - maxBalance) * 0.18, 500)}
    private var chartMax: Decimal { maxBalance + max((minBalance - maxBalance) * 0.18, 500)}
    
    var body: some View {
        if balanceHistory.isEmpty { EmptyChartView()}
        else {
            Chart {
                ForEach(balanceHistory) { history in
                    AreaMark(
                        x: .value("Tarih", history.date),
                        yStart: .value("Alt", chartMin),
                        yEnd: .value("Bakiye", history.balance)
                    )
                    .interpolationMethod(.monotone)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    AppColor.accent.opacity(0.52),
                                    AppColor.accent.opacity(0.25),
                                    AppColor.accent.opacity(0.12),
                                    AppColor.accent.opacity(0)
                                    ]
                            ),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    LineMark(
                        x: .value("Tarih", history.date),
                        y: .value("Bakiye", history.balance)
                    )
                    .interpolationMethod(.monotone)
                    .lineStyle(
                        StrokeStyle(
                            lineWidth: 2.5,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundStyle(AppColor.accent)
                }
            }
            .chartYScale(domain: chartMin...chartMax)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartPlotStyle{ plotArea in plotArea.background(Color.clear)}
            .clipped()
        }
    }
}

//MARK: - EMPTY CHART
struct EmptyChartView: View {
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(AppFont.title)
                .foregroundStyle(AppColor.accent.opacity(0.7))
            Text("Henüz İşlem Yok")
                .font(AppFont.headline)
                .foregroundStyle(AppColor.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}



//MARK: - CALCULATIONS
private func balanceCalc(transactions: [Transaction]) -> Decimal {
    let income = transactions.filter { $0.type == .income}.reduce(0) { $0 + $1.amount}
    let expense = transactions.filter { $0.type == .expense}.reduce(0) { $0 - $1.amount}
    return income - expense
}


//MARK: - BALANCE HISTORY
struct BalanceHistory: Identifiable {
    let id = UUID()
    let date: Date
    let balance: Decimal
}

private func balancePoints(transactions: [Transaction]) -> [BalanceHistory] {
    var currentBalance: Decimal = 0
    var history: [BalanceHistory] = []
    
    for transaction in transactions {
        if transaction.type == .income { currentBalance += transaction.amount}
        else { currentBalance -= transaction.amount}
        history.append(BalanceHistory(date: transaction.date, balance: transaction.amount))
    }
    
    return history
}


#Preview {
    GraphCard()
}
