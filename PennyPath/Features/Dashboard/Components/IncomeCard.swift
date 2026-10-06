//
//  IncomeCard.swift
//  PennyPath
//
//  Created by Eren Akkoç on 6.10.2026.
//

import SwiftUI
import SwiftData

struct IncomeCard: View {
    @Query()
    var transactions: [Transaction]
    var income: Decimal {transactions.filter{$0.type == .income}.reduce(0) { $0 + $1.amount}}
    
    
    var body: some View {
        AppCard {
            VStack (alignment: .leading) {
                Text("Gelir").foregroundStyle(AppColor.secondaryText).padding(.spXS)
                Text(income, format: .currency(code: "TRY")).font(AppFont.headline).foregroundStyle(AppColor.income).lineLimit(1)
            }
            .padding(.spXS)
        }
        
    }
}

#Preview {
    IncomeCard()
}
