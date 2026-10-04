//
//  ExpenseCard.swift
//  PennyPath
//
//  Created by Eren Akkoç on 8.08.2026.
//

import SwiftUI
import SwiftData

struct ExpenseCard: View{
    @Query(sort: \Transaction.date, order: .forward) var transactions: [Transaction]
    var expense: Double {transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount}}
    
    var body: some View {
        VStack {
            Text("Gider").foregroundColor(AppColor.secondaryText)
            Text(expense, format: .currency(code: "TRY")).font(.system(size: 25)).foregroundColor(AppColor.expense).lineLimit(1)
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

#Preview {
    ExpenseCard()
}

