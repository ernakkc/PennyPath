//
//  PennyPathApp.swift
//  PennyPath
//

import SwiftUI
import SwiftData
import Observation

@main
struct PennyPathApp: App {
    
    // MARK: - Model Container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Transaction.self,
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
                using: container.mainContext
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
                .tint(AppColor.accent)
                .background(AppColor.background)
        }
        .modelContainer(sharedModelContainer)
        .windowResizability(.contentSize)
        
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowIdealSize(.fitToContent)
        #endif
    }
}
