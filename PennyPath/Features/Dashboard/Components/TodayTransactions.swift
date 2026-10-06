//
//  TodayTransactions.swift
//  PennyPath
//
//  Created by Eren Akkoç on 6.10.2026.
//

import SwiftUI
import SwiftData


struct TodayTransactions: View {
    @Query var transactions: [Transaction]
        
    init() {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
            let predicate = #Predicate<Transaction> { transaction in transaction.date >= startOfDay && transaction.date < endOfDay}
        _transactions = Query(filter: predicate, sort: \Transaction.date, order: .reverse)
    }
    
    var body: some View {
        AppCard {
            ScrollView{
                Text("Bugünkü İşlemler").font(AppFont.title).foregroundStyle(AppColor.primaryText)
                Divider().foregroundStyle(AppColor.primaryText)
                
                ForEach(transactions) { transaction in
                    TransactionRow(transaction: transaction)
                }
            }
        }
    }
}


// TransactionRow
struct TransactionRow: View {
    @State var transaction: Transaction
    
    var body: some View {
        HStack{
            Image(systemName: transaction.category.iconName)
            
            VStack (alignment: .leading){
                Text(transaction.title).font(AppFont.subtext).foregroundStyle(AppColor.primaryText)
                Text(transaction.type == .income ? "Gelir" : "Gider" ).font(AppFont.caption).foregroundStyle(AppColor.secondaryText)
            }.padding(.spXS)
            Spacer()
            
            Text(transaction.amount , format: .currency(code: "TRY")).foregroundStyle(transaction.type == .income ? AppColor.income : AppColor.expense)
        }
        Divider()
    }
}

