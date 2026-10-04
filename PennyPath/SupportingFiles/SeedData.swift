//
//  SeedData.swift
//  PennyPath
//
//  Created by Eren Akkoç on 5.08.2026.
//

import Foundation
import SwiftData
import os // 1. Profesyonel loglama için OSLog kullanımı

@MainActor // 2. SwiftData context işlemlerinin ana thread'de güvenle yapılması için
enum SeedData {
    private static let seededKey = "com.pennypath.seeded"
    private static let logger = Logger(subsystem: "com.pennypath", category: "SeedData")

    // Container yerine doğrudan ModelContext almak daha esnektir
    static func seedIfNeeded(using context: ModelContext) {
        let defaults = UserDefaults.standard
        
        // Eğer daha önce seed yapıldıysa işlemi erken bitir
        guard !defaults.bool(forKey: seededKey) else { return }

        logger.info("İlk kurulum: Örnek veriler (seed data) yükleniyor...")

        let samples = generateSamples()

        for transaction in samples {
            context.insert(transaction)
        }

        do {
            try context.save()
            defaults.set(true, forKey: seededKey)
            logger.info("Örnek veriler başarıyla veritabanına kaydedildi. (Toplam: \(samples.count) kayıt)")
        } catch {
            // Sadece print yerine sistem loglarına hata detayını bırakıyoruz
            logger.error("SeedData hatası: Örnek veriler kaydedilemedi -> \(error.localizedDescription)")
        }
    }

    // 3. Veri kümesini asıl fonksiyondan ayırarak okunabilirliği artırıyoruz
    private static func generateSamples() -> [Transaction] {
        return [
            Transaction(title: "Aylık Maaş", amount: 45000, date: date(daysAgo: 30), type: .income, category: .salary, note: "Ağustos maaşı"),
            Transaction(title: "Ev Kirası", amount: 12000, date: date(daysAgo: 28), type: .expense, category: .housing), // Yeni kategori: housing
            Transaction(title: "Haftalık Market", amount: 1540.50, date: date(daysAgo: 25, hoursAgo: 2), type: .expense, category: .food),
            Transaction(title: "Freelance Yazılım", amount: 8500, date: date(daysAgo: 20), type: .income, category: .salary, note: "Upwork - API Entegrasyon projesi"),
            Transaction(title: "Akaryakıt", amount: 1200, date: date(daysAgo: 18), type: .expense, category: .transport),
            Transaction(title: "Dışarıda Yemek", amount: 450, date: date(daysAgo: 15, hoursAgo: 5), type: .expense, category: .food, note: "Arkadaşlarla akşam yemeği"),
            Transaction(title: "Elektrik Faturası", amount: 850.25, date: date(daysAgo: 12), type: .expense, category: .bills),
            Transaction(title: "Netflix & Spotify", amount: 320, date: date(daysAgo: 10), type: .expense, category: .subscriptions), // Yeni kategori: subscriptions
            Transaction(title: "İnternet", amount: 350, date: date(daysAgo: 9), type: .expense, category: .bills),
            Transaction(title: "Doğum Günü Hediyesi", amount: 1500, date: date(daysAgo: 7), type: .expense, category: .gifts), // Yeni kategori: gifts
            Transaction(title: "Hisse Senedi Temettü", amount: 850, date: date(daysAgo: 5), type: .income, category: .investment),
            Transaction(title: "Sinema", amount: 280, date: date(daysAgo: 3, hoursAgo: 4), type: .expense, category: .entertainment),
            Transaction(title: "Kahve", amount: 125, date: date(daysAgo: 1, hoursAgo: 1), type: .expense, category: .food)
        ]
    }

    // 4. Tarihleri geriye dönük hesaplamak için tekrarlayan kodları temizleyen yardımcı (helper) fonksiyon
    private static func date(daysAgo: Int, hoursAgo: Int = 0) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = -daysAgo
        components.hour = -hoursAgo // Saat farkı ekleyerek listelemede daha doğal durmasını sağlarız
        return calendar.date(byAdding: components, to: .now) ?? .now
    }
}
