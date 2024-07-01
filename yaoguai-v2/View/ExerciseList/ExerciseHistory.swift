//
//  ExerciseHistory.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 1/7/2024.
//

import SwiftUI
import SwiftData

struct ExerciseHistory: View {
	let exercise: Exercise
	
	var body: some View {
		ScrollView {
			ForEach(exercise.exerciseRecords) { record in
				ExerciseHistoryItem(exerciseRecord: record)
			}
			
		}
		.navigationTitle(exercise.name)
		.onAppear {
			print(exercise.exerciseRecords)
		}
		
	}
}

#Preview {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	let exerciseRecord = ExerciseRecord.example
	modelContainer.mainContext.insert(exerciseRecord)
	
	return ExerciseHistory(exercise: exerciseRecord.exerciseDetails!)
		.modelContainer(modelContainer)
}
