//
//  ExerciseHistoryItem.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 1/7/2024.
//

import SwiftUI
import SwiftData

struct ExerciseHistoryItem: View {
	let exerciseRecord: ExerciseRecord
	
    var body: some View {
		VStack(alignment: .leading) {
			Text(exerciseRecord.exerciseDetails?.name ?? "")
			ForEach(exerciseRecord.sets) { set in
				Text("\(set.valueString) \(exerciseRecord.exerciseDetails?.unit.rawValue ?? "") x \(set.repsString)")
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding()
    }
}

#Preview {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	let record = ExerciseRecord.example
	modelContainer.mainContext.insert(record)
	
	return ExerciseHistoryItem(exerciseRecord: record)
		.modelContainer(modelContainer)
}

