//
//  SummaryCard.swift
//  PennyPath
//
//  Created by Eren Akkoç on 15.10.2026.
//

import SwiftUI

struct SummaryItemCard: View {
    var title: String
    var value: Decimal
    var icon: String
    var color: Color
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.white)
                    .shadow(radius: 4, x: 0, y: 2)
                    .padding(5)
                    .background(color.gradient)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            
            Text(value, format: .currency(code: "TRY"))
                .font(.title3.bold())
                .foregroundStyle(color)
            
        }
        .padding()
        .shadow(color: color.opacity(0.09), radius: 6, x: 0, y: 3)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    SummaryItemCard(title: "Gelir", value: 20555, icon: "arrow.up", color: .accentColor)
}
