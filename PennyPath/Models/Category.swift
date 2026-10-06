//
//  Category.swift
//  PennyPath
//
//  Created by Eren Akkoç on 5.08.2026.
//


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
    case housing = "Ev & Kira"
    case education = "Eğitim"
    case clothing = "Giyim"
    case travel = "Seyahat"
    case personalCare = "Kişisel Bakım"
    case subscriptions = "Abonelikler"
    case pets = "Evcil Hayvan"
    case gifts = "Hediye & Bağış"
    case savings = "Birikim"
    
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
        case .housing: return "house.fill"
        case .education: return "graduationcap.fill"
        case .clothing: return "tshirt.fill"
        case .travel: return "airplane"
        case .personalCare: return "sparkles"
        case .subscriptions: return "repeat.circle.fill"
        case .pets: return "pawprint.fill"
        case .gifts: return "gift.fill"
        case .savings: return "bag.fill"
            
        case .other: return "ellipsis.circle.fill"
        }
    }
}
