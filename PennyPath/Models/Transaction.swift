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

    var id: UUID
    var title: String
    var amount: Double
    var date: Date
    var type: TransactionType
    var category: Category
    var note: String?

    init(
        title: String,
        amount: Double,
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
