//
//  Category.swift
//  PennyPath
//
//  Created by Eren Akkoç on 5.08.2026.
//


import Foundation
import SwiftUI

enum Category: String, CaseIterable, Codable, Identifiable {
    case food = "Yemek"
    case transport = "Ulaşım"
    case shopping = "Alışveriş"
    case bills = "Faturalar"
    case salary = "Maaş"
    case investment = "Yatırım"
    case entertainment = "Eğlence"
    case health = "Sağlık"
    case other = "Diğer"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .shopping: return "cart.fill"
        case .bills: return "doc.text.fill"
        case .salary: return "briefcase.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .entertainment: return "popcorn.fill"
        case .health: return "heart.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
}
