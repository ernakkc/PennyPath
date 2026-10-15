//
//  TimeIntervalTypes.swift
//  PennyPath
//
//  Created by Eren Akkoç on 15.10.2026.
//


enum TimeIntervalTypes: String, CaseIterable, Codable, Identifiable {
    case month = "Ay"
    case year = "Yıl"
    
    var id: String { rawValue }
}
