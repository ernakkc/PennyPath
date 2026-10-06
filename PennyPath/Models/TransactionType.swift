//
//  TransactionType.swift
//  PennyPath
//
//  Created by Eren Akkoç on 5.08.2026.
//


import Foundation

enum TransactionType: String, Codable, CaseIterable {
    case expense
    case income
    
    var title: String {
        switch self {
        case .income: return "Gelir"
        case .expense: return "Gider"
        }
    }
}
