//
//  ContentView.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	var body: some View {
		TabView {
			WorkoutDashboard()
				.tabItem {
					Label("Workouts", systemImage: "list.clipboard.fill")
				}
			
			ExerciseList()
				.tabItem {
					Label("Exercises", systemImage: "figure.run")
				}
		}
	}
}

#Preview {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	modelContainer.mainContext.insert(WorkoutTemplate.example.lower)
	modelContainer.mainContext.insert(WorkoutTemplate.example.upper)
	
	return ContentView()
		.modelContainer(modelContainer)
}
