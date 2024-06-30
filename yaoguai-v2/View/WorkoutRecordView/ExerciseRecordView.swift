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

extension ExerciseRecordView {
	struct ExerciseRecordHeaderRow: View {
		var body: some View {
			HStack {
				Group {
					Text("KG")
						.frame(maxWidth: .infinity, alignment: .leading)
					Text("Reps")
						.frame(maxWidth: .infinity, alignment: .leading)
					Text("RPE")
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				.font(.caption)
				
				Spacer()
				
				Button {} label: {
					Image(systemName: "checkmark")
				}
				.buttonStyle(.bordered)
				.tint(.white)
				.opacity(0)
				
				Button {} label: {
					Image(systemName: "xmark")
				}
				.buttonStyle(.bordered)
				.tint(.white)
				.opacity(0)
			}
			.foregroundStyle(.secondary)
		}
	}
}

#Preview {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	let record = ExerciseRecord.example
	modelContainer.mainContext.insert(record)
	
	return ExerciseRecordView(exerciseRecord: record, deleteExerciseRecord: { _ in })
		.modelContainer(modelContainer)
}
