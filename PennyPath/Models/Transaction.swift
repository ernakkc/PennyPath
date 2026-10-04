//
//  Transaction.swift
//  PennyPath
//
//  Created by Eren Akkoç on 5.08.2026.
//


import Foundation
import SwiftData

@Model
final class Transaction {

    // 1. Veritabanında çakışmaları önlemek için unique (benzersiz) kıldık
    @Attribute(.unique) var id: UUID
    var title: String
    
    // 2. Parasal hesaplamalarda kuruş kayıplarını önlemek için Decimal'e geçtik
    var amount: Decimal
    
    var date: Date
    var type: TransactionType
    var category: Category
    var note: String?

    init(
        title: String,
        amount: Decimal,
        date: Date = .now,
        type: TransactionType,
        category: Category,
        note: String? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.date = date
        self.type = type
        self.category = category
        self.note = note
    }
}
