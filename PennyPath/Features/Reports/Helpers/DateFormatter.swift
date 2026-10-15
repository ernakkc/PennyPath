//
//  DateFormatter.swift
//  PennyPath
//
//  Created by Eren Akkoç on 12.10.2026.
//

import SwiftUI

func formattedDate(currentDate: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "tr_TR")
    formatter.dateFormat = "MMMM yyyy"
    return formatter.string(from: currentDate).capitalized
}
