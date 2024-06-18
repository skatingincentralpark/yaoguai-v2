//
//  WorkoutView.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import SwiftUI
import SwiftData

struct WorkoutView: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	
	@Query private var exercises: [Exercise]
	
	@Bindable var workoutRecord: WorkoutRecord
	var workoutTemplate: WorkoutTemplate?
	
	@State private var exerciseSelectorPresented = false
	
	var cancelWorkout: () -> Void
	var completeWorkout: () -> Void
	
    var body: some View {
		List {
			Section {
				TextField("Name", text: $workoutRecord.name)
			}
			
			ForEach(workoutRecord.exercises) { exercise in
				Section {
					ExerciseRecordView(exerciseRecord: exercise, deleteExerciseRecord: deleteExerciseRecord)
				}
			}
			
			Section {
				Button("Add Exercise") {
					exerciseSelectorPresented = true
				}
				
				Button("Finish", action: completeWorkout)
				Button("Cancel", action: cancelWorkout)
			}
		}
		.sheet(isPresented: $exerciseSelectorPresented) {
			ExerciseSelector(addExercise: addExercise)
		}	
    }
	
	func finishWorkout() {
		dismiss()
	}
	
	func addExercise(_ exercise: Exercise) {
		let exerciseRecord = ExerciseRecord()
		exerciseRecord.exerciseDetails = exercise
		workoutRecord.exercises.append(exerciseRecord)
	}
	
	func deleteExerciseRecord(record: ExerciseRecord) {
		workoutRecord.exercises = workoutRecord.exercises.filter { $0.id != record.id }
	}
	
//	func deleteExerciseTemplate(template: ExerciseTemplate) {
//		exerciseTemplates = exerciseTemplates.filter { $0.id != template.id }
//	}
}

#Preview {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	Exercise.Example.all.forEach { exercise in
		modelContainer.mainContext.insert(exercise)
	}

	let record = WorkoutRecord.example
	modelContainer.mainContext.insert(record)
	
	return NavigationStack {
		WorkoutView(workoutRecord: record, cancelWorkout: {}, completeWorkout: {})
			.modelContainer(modelContainer)
	}
}
