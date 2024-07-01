//
//  ExerciseList.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 19/6/2024.
//

import SwiftUI
import SwiftData

struct ExerciseList: View {
	@Query private var exercises: [Exercise]
	@Environment(\.modelContext) private var modelContext
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(exercises) { exercise in
					NavigationLink("\(exercise.name) (\(exercise.exerciseRecords.count))") {
						ExerciseHistory(exercise: exercise)
					}
				}
			}
			.navigationTitle("Exercise List")
		}
	}
}

#Preview {
	
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	modelContainer.mainContext.insert(WorkoutRecord.example)
	modelContainer.mainContext.insert(WorkoutRecord.example)
	Exercise.example.all.forEach { exercise in
		modelContainer.mainContext.insert(exercise)
	}
	
	return ExerciseList()
		.modelContainer(modelContainer)
}
