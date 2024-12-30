//
//  HANGRRApp.swift
//  HANGRR
//
//  Created by Work on 30/12/2024.
//

import SwiftUI
import SwiftData

@main
struct HANGRRApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                WardrobeItem.self,
                TryOnSession.self,
                TryOnResult.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema)
            container = try ModelContainer(for: schema, configurations: modelConfiguration)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            WardrobeView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
}
