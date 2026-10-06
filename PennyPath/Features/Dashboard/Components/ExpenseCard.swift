//
//  ExpenseCard.swift
//  PennyPath
//
//  Created by Eren Akkoç on 6.10.2026.
//

import SwiftUI
import SwiftData

struct ExpenseCard: View {
    @Query()
    var transactions: [Transaction]
    var income: Decimal {transactions.filter{$0.type == .expense}.reduce(0) { $0 + $1.amount}}
    
    var body: some View {
        AppCard {
            VStack (alignment: .leading) {
                Text("Gider").foregroundStyle(AppColor.secondaryText).padding(.spXS)
                Text(income, format: .currency(code: "TRY")).font(AppFont.headline).foregroundStyle(AppColor.expense).lineLimit(1)
            }
            .padding(.spXS)
        }
        
    }
}

#Preview {
    ExpenseCard()
}
