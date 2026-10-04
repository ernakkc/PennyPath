//
//  SeedData.swift
//  PennyPath
//
//  Created by Assistant on 8.08.2026.
//

import Foundation
import SwiftData

enum SeedData {
    private static let seededKey = "com.pennypath.seeded"

    static func seedIfNeeded(using container: ModelContainer) {
        let defaults = UserDefaults.standard
        guard defaults.bool(forKey: seededKey) == false else { return }

        let context = ModelContext(container)
        let calendar = Calendar.current
        let now = Date()

        let samples: [Transaction] = [
            Transaction(title: "Maaş", amount: 25000, date: calendar.date(byAdding: .day, value: -30, to: now)!, type: .income, category: .salary),
            Transaction(title: "Market", amount: 1200, date: calendar.date(byAdding: .day, value: -28, to: now)!, type: .expense, category: .food),
            Transaction(title: "Kira", amount: 8000, date: calendar.date(byAdding: .day, value: -25, to: now)!, type: .expense, category: .transport),
            Transaction(title: "Freelance", amount: 6000, date: calendar.date(byAdding: .day, value: -20, to: now)!, type: .income, category: .salary),
            Transaction(title: "Ulaşım", amount: 450, date: calendar.date(byAdding: .day, value: -18, to: now)!, type: .expense, category: .transport),
            Transaction(title: "Yemek", amount: 300, date: calendar.date(byAdding: .day, value: -15, to: now)!, type: .expense, category: .food),
            Transaction(title: "Elektrik", amount: 900, date: calendar.date(byAdding: .day, value: -12, to: now)!, type: .expense, category: .bills),
            Transaction(title: "Su", amount: 250, date: calendar.date(byAdding: .day, value: -10, to: now)!, type: .expense, category: .bills),
            Transaction(title: "İnternet", amount: 350, date: calendar.date(byAdding: .day, value: -9, to: now)!, type: .expense, category: .bills),
            Transaction(title: "Hediye", amount: 1500, date: calendar.date(byAdding: .day, value: -7, to: now)!, type: .expense, category: .other),
            Transaction(title: "Prim", amount: 3000, date: calendar.date(byAdding: .day, value: -5, to: now)!, type: .income, category: .investment),
            Transaction(title: "Sinema", amount: 220, date: calendar.date(byAdding: .day, value: -3, to: now)!, type: .expense, category: .entertainment),
            Transaction(title: "Kahve", amount: 80, date: calendar.date(byAdding: .day, value: -1, to: now)!, type: .expense, category: .salary)
        ]

        for t in samples { context.insert(t) }

        do {
            try context.save()
            defaults.set(true, forKey: seededKey)
        } catch {
            // If seeding fails, do not flip the flag so we can try again next launch
            print("SeedData error: \(error)")
        }
    }
}
