//
//  DeleteTransaction.swift
//  PennyPath
//
//  Created by Eren Akkoç on 19.08.2026.
//

import SwiftData

func deleteTransaction(transaction: Transaction, in modelContext: ModelContext) {
    modelContext.delete(transaction)

    do {
        try modelContext.save()
    } catch {
        print("Delete error: \(error)")
    }
}
