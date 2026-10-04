//
//  BalanceCard.swift
//  PennyPath
//
//  Created by Eren Akkoç on 7.08.2026.
//

import SwiftUI
import SwiftData
import Charts

struct GraphCard: View {
    
    @Query(sort: \Transaction.date, order: .forward)
    private var transactions: [Transaction]
    
    // MARK: - Calculations
    
    private var income: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var expense: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    private var balance: Double {
        income - expense
    }
    
    private var balanceHistory: [BalanceHistory] {
        balancePoints(transactions: transactions)
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            // MARK: Header
            
            VStack(alignment: .leading, spacing: 7) {
                
                Text("Toplam Bakiye")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AppColor.secondaryText)
                
                Text(
                    balance.formatted(
                        .currency(code: "TRY")
                    )
                )
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(AppColor.primaryText)
                .contentTransition(.numericText())
            }
            
            // MARK: Chart
            
            BalanceChartView(balanceHistory: balanceHistory)
                .frame(height: 95)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(AppColor.backgroundSecondary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(AppColor.border, lineWidth: 2)
        )
    }
}


// MARK: - Balance History

struct BalanceHistory: Identifiable {
    let id = UUID()
    let date: Date
    let balance: Double
}


// MARK: - Balance Calculation

private func balancePoints(
    transactions: [Transaction]
) -> [BalanceHistory] {
    
    var currentBalance: Double = 0
    var history: [BalanceHistory] = []
    
    for transaction in transactions {
        
        if transaction.type == .income {
            currentBalance += transaction.amount
        } else {
            currentBalance -= transaction.amount
        }
        
        history.append(
            BalanceHistory(
                date: transaction.date,
                balance: currentBalance
            )
        )
    }
    
    return history
}


// MARK: - Balance Chart

struct BalanceChartView: View {
    
    let balanceHistory: [BalanceHistory]
    
    private var minimumBalance: Double {
        balanceHistory.map(\.balance).min() ?? 0
    }
    
    private var maximumBalance: Double {
        balanceHistory.map(\.balance).max() ?? 0
    }
    
    private var chartMinimum: Double {
        let range = maximumBalance - minimumBalance
        
        // Veri birbirine çok yakınsa da grafiğin
        // düz bir çizgi gibi görünmesini engeller.
        let padding = max(range * 0.18, 500)
        
        return minimumBalance - padding
    }
    
    private var chartMaximum: Double {
        let range = maximumBalance - minimumBalance
        let padding = max(range * 0.18, 500)
        
        return maximumBalance + padding
    }
    
    var body: some View {
        
        if balanceHistory.isEmpty {
            
            EmptyChartView()
            
        } else {
            
            Chart {
                
                // MARK: Gradient Area
                
                ForEach(balanceHistory) { item in
                    
                    AreaMark(
                        x: .value("Tarih", item.date),
                        yStart: .value("Alt", chartMinimum),
                        yEnd: .value("Bakiye", item.balance)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color.accentColor.opacity(0.12),
                                    Color.accentColor.opacity(0.035),
                                    Color.clear
                                ]
                            ),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                
                // MARK: Main Line
                
                ForEach(balanceHistory) { item in
                    
                    LineMark(
                        x: .value("Tarih", item.date),
                        y: .value("Bakiye", item.balance)
                    )
                    .interpolationMethod(.catmullRom)
                    .lineStyle(
                        StrokeStyle(
                            lineWidth: 2.5,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .foregroundStyle(Color.accentColor)
                }
            }
            .chartYScale(
                domain: chartMinimum...chartMaximum
            )
            
            // MARK: Remove Everything Around Chart
            
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            
            .chartPlotStyle { plotArea in
                plotArea
                    .background(Color.clear)
            }
            
            .clipped()
        }
    }
}


// MARK: - Empty State

private struct EmptyChartView: View {
    
    var body: some View {
        VStack(spacing: 8) {
            
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 22))
                .foregroundStyle(Color.accentColor.opacity(0.7))
            
            Text("Henüz işlem yok")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(AppColor.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


// MARK: - Preview

#Preview {
    GraphCard()
        .padding()
        .background(AppColor.backgroundSecondary)
}
