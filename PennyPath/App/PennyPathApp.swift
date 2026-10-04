//
//  PennyPathApp.swift
//  PennyPath
//

import SwiftUI
import SwiftData
import Observation

@main
struct PennyPathApp: App {
    
    // MARK: - Theme
    @State private var themeManager = ThemeManager()
    
    
    // MARK: - Model Container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Transaction.self,
            Settings.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            SeedData.seedIfNeeded(
                using: container
            )
            return container
            
        } catch {
            fatalError(
                "Could not create ModelContainer: \(error)"
            )
        }
    }()
    
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
                .tint(AppColor.accent)
                .background(AppColor.background)
                .task {loadTheme()}
        }
        .modelContainer(
            sharedModelContainer
        )
        .windowResizability(.contentSize)
        
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowIdealSize(.fitToContent)
        #endif
    }
    
    
    // MARK: - Load Theme
    private func loadTheme() {
        let context = sharedModelContainer.mainContext
        let descriptor = FetchDescriptor<Settings>()
        
        do {
            let storedSettings = try context.fetch(descriptor)
            
            if let settings = storedSettings.first {
                themeManager.theme = settings.theme
            } else {
                let settings = Settings(theme: .system)
                context.insert(settings)
                try context.save()
                themeManager.theme = .system
            }
        } catch {
            print("Theme loading error: \(error)")
        }
    }
}
