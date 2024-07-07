//
//  ExerciseSelector.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import SwiftUI
import SwiftData

struct ExerciseSelector: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss
	
	@Query private var exercises: [Exercise]
	
	var addExercise: (Exercise) -> Void
	
    var body: some View {
		List {
			Section("Existing") {
				Button("Add dummy workouts") {
					modelContext.insert(Exercise(name: "Pullups", unit: .kg))
					modelContext.insert(Exercise(name: "Pushups", unit: .kg))
					modelContext.insert(Exercise(name: "Squats", unit: .kg))
					modelContext.insert(Exercise(name: "Deadlifts", unit: .kg))
				}
				.onChange(of: exercises.count) { oldValue, newValue in
					print(newValue)
				}
				
				Button("Delete all") {
					do {
						try! modelContext.delete(model: Exercise.self)
						print("Success")
					} catch {
						print("Failed")
					}
				}
				
				if exercises.count > 1 {
					Text("Total Exercises: \(exercises.count)")
					.bold()
				}
				
				ForEach(exercises) { exercise in
					Button {
						addExercise(exercise)
						dismiss()
					} label: {
						HStack(spacing: 20) {
							Image(systemName: "plus")
							
							VStack(alignment: .leading) {
								Text(exercise.name).bold()
								Group {
									Text("Unit: \(exercise.unit.rawValue)")
								}
								.foregroundStyle(.secondary)
							}
						}
					}
				}
			}
		}
		.navigationTitle("Exercise Selector")
    }
}

#Preview {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	return NavigationStack {
		ExerciseSelector(addExercise: { _ in })
			.modelContainer(modelContainer)
	}
}
