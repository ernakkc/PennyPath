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
                Text("Toplam Bakiye").font(AppFont.headline).foregroundStyle(AppColor.secondaryText)
                Text(balance.formatted(.currency(code: "TRY")))
            }
            
            BalanceChartView(BalanceHistory: balanceHistory)
        }
        .foregroundColor(AppColor.primaryText)
    }
}






//MARK: - CALCULATIONS
private func balanceCalc(transactions: [Transaction]) -> Decimal {
    var income = transactions.filter { $0.type == .income}.reduce(0) { $0 + $1.amount}
    var expense = transactions.filter { $0.type == .expense}.reduce(0) { $0 - $1.amount}
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
