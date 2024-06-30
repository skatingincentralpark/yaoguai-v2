//
//  yaoguai_v2App.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import SwiftUI
import SwiftData

@main
struct yaoguai_v2App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
			WorkoutTemplate.self,
			WorkoutRecord.self,
			Exercise.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationView()
        }
        .modelContainer(sharedModelContainer)
    }
}
