//
//  LastTransactions.swift
//  PennyPath
//
//  Created by Eren Akkoç on 8.08.2026.
//

import SwiftUI
import SwiftData

struct LastTransactions: View {
    @Query(sort: \Transaction.date, order: .reverse) var transactions: [Transaction]
    
    private var lastFiveTransactions: [Transaction] {
        Array(transactions.prefix(10))
    }
    
    var body: some View {
        ScrollView {
            if lastFiveTransactions.count < 1 {
                ContentUnavailableView("Henüz İşlem Yok", systemImage: "receipt", description: Text("Son işlemleri görüntülemek için işlem ekleyin."))
            }
            ForEach(Array(lastFiveTransactions.enumerated()), id: \.element.id) { index, transaction in
                TransactionCard(transaction: transaction)
                Divider().foregroundColor(AppColor.divider)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity ,alignment: .topLeading)
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


struct TransactionCard: View {
    @State var transaction: Transaction
    
    var body: some View {
        HStack (spacing: Spacing.sm) {
            VStack {
                Text(transaction.title).font(AppFont.callout.weight(.semibold))
                Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(AppColor.secondaryText)
            }
            Spacer()
            if (transaction.type == .income) {
                Text(transaction.amount.formatted(.currency(code: "TRY"))).foregroundStyle(AppColor.income)
            } else {
                Text(transaction.amount.formatted(.currency(code: "TRY"))).foregroundStyle(AppColor.expense)
            }
        }
    }
}

#Preview {
    TransactionCard(transaction: Transaction(title: "Bilgisayar", amount: 45000, type: .expense, category: .shopping))
}
