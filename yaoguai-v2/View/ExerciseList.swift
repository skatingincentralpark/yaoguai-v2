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
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(exercises) { exercise in
					Section {
						Text(exercise.name)
							.bold()
						
						ForEach(exercise.exerciseRecords) { record in
							NavigationLink("Exercise Record") {
								ExerciseRecordView(exerciseRecord: record, deleteExerciseRecord: { _ in })
									.padding()
							}
						}
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
