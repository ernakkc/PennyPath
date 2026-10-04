//
//  TransactionType.swift
//  PennyPath
//
//  Created by Eren Akkoç on 5.08.2026.
//


import Foundation

enum TransactionType: String, Codable, CaseIterable {
    case income
    case expense
    case transfer
}
