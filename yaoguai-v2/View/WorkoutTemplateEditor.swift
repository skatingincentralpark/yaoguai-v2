//
//  WorkoutTemplateEditor.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import SwiftUI
import SwiftData

struct WorkoutTemplateEditor: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(\.dismiss) private var dismiss

	@Query private var exerciseTemplates: [ExerciseTemplate]
	
	@State private var name: String = ""
	@State private var exercises = [ExerciseTemplate]()
	@State private var exerciseSelectorPresented = false
	
    var body: some View {
		List {
			Section {
				TextField("Name", text: $name)
			}
						
			ForEach(exercises) { template in
				Section {
					ExerciseTemplateView(exerciseTemplate: template, deleteExerciseTemplate: deleteExerciseTemplate)
				}
			}
			
			Section {
				Button("Add Exercise") {
					exerciseSelectorPresented = true
				}
				Button("Save", action: saveTemplate)
			}
		}
		.navigationTitle("Workout Template")
		.sheet(isPresented: $exerciseSelectorPresented) {
			ExerciseSelector(addExercise: addExercise)
		}
    }
	
	func addExercise(_ exercise: Exercise) {
		let exerciseTemplate = ExerciseTemplate()
		exerciseTemplate.exerciseDetails = exercise
		exercises.append(exerciseTemplate)
	}
	
	func deleteExerciseTemplate(template: ExerciseTemplate) {
		exercises = exercises.filter { $0.id != template.id }
	}
	
	func saveTemplate() {
		guard name.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
			print ("Can't save with an empty name")
			return
		}
		
		guard exercises.count > 0 else {
			print ("Can't save with no exercises")
			return
		}
		
		dismiss()
		
		let newTemplate = WorkoutTemplate(name: name)
		modelContext.insert(newTemplate)
		newTemplate.exercises = exercises
	}
}

#Preview {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	return NavigationStack {
		WorkoutTemplateEditor()
			.modelContainer(modelContainer)
	}
}
