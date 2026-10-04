//
//  AppFont.swift
//  PennyPath
//
//  Created by Eren Akkoç on 4.08.2026.
//

import SwiftUI

enum AppFont {
    /// Ekran başlıkları ve büyük vurgular (Boyut: ~28pt, Kalın)
    static let title = Font.title.bold()
    
    /// Kart başlıkları, butonlar ve liste başlıkları (Boyut: ~17pt, Yarı Kalın)
    static let headline = Font.headline
    
    /// Ana okuma metinleri ve açıklamalar (Boyut: ~17pt, Düzenli)
    static let body = Font.body
    
    /// İkincil metinler ve form etiketleri (Boyut: ~15pt, Düzenli)
    static let subtext = Font.callout
    
    /// En küçük bilgilendirmeler, tarihler ve dipnotlar (Boyut: ~12pt, Düzenli)
    static let caption = Font.caption
}
