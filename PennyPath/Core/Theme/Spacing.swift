//
//  Spacing.swift
//  PennyPath
//
//  Created by Eren Akkoç on 4.08.2026.
//


import Foundation
import SwiftUI

enum AppSpacing {
    /// Çok yakın elemanlar veya ikon-metin arası boşluklar (4pt)
    static let xs: CGFloat = 4
    
    /// Küçük gruplar veya kart içi dikey boşluklar (12pt)
    static let sm: CGFloat = 12
    
    /// Ekran kenar boşlukları ve ana element mesafeleri (16pt) - Sektör Standardı
    static let md: CGFloat = 16
    
    /// Farklı bölümler (Sections) arası boşluklar (24pt)
    static let lg: CGFloat = 24
    
    /// Büyük ekran boşlukları ve illüstrasyon altı mesafeler (32pt)
    static let xl: CGFloat = 32
}

// SwiftUI Padding ve Stack'lerde (VStack/HStack) hayatı kolaylaştıran dokunuş:
extension CGFloat {
    static let spXS = AppSpacing.xs
    static let spSM = AppSpacing.sm
    static let spMD = AppSpacing.md
    static let spLG = AppSpacing.lg
    static let spXL = AppSpacing.xl
}
