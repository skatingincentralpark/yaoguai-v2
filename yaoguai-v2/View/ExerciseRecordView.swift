//
//  ExerciseRecordView.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import SwiftUI
import SwiftData

struct ExerciseRecordView: View {
	@Bindable var exerciseRecord: ExerciseRecord
	var deleteExerciseRecord: (ExerciseRecord) -> Void
	
    var body: some View {
		VStack {
			HStack {
				Text(exerciseRecord.exerciseDetails?.name ?? "")
					.bold()
				
				Spacer()
				
				Button("Add Set") {
					exerciseRecord.sets.append(SetRecord())
				}
				.buttonStyle(.bordered)
				
				Button(role: .destructive) {
					deleteExerciseRecord(exerciseRecord)
				} label: {
					Image(systemName: "xmark")
				}
				.buttonStyle(.bordered)
				.tint(.red)
			}
			
			ExerciseRecordHeaderRow()
			
			ForEach($exerciseRecord.sets) { $set in
				SetRecordRow(set: $set, deleteSet: deleteSet)
			}
		}
    }
	
	func deleteSet(target: SetRecord) {
		exerciseRecord.sets = exerciseRecord.sets.filter { $0.id != target.id }
	}
}

#Preview {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	let record = ExerciseRecord.example
	modelContainer.mainContext.insert(record)
	
	return ExerciseRecordView(exerciseRecord: record, deleteExerciseRecord: { _ in })
		.modelContainer(modelContainer)
}
