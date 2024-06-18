//
//  ExerciseTemplateSection.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import SwiftUI
import SwiftData

struct ExerciseTemplateView: View {
	@Bindable var exerciseTemplate: ExerciseTemplate
	var deleteExerciseTemplate: (ExerciseTemplate) -> Void
	
	var body: some View {
		VStack {
			HStack {
				Text(exerciseTemplate.exerciseDetails?.name ?? "")
					.bold()
				
				Spacer()
				
				Button("Add Set") {
					exerciseTemplate.sets.append(SetTemplate())
				}
				.buttonStyle(.bordered)
				
				Button(role: .destructive) {
					deleteExerciseTemplate(exerciseTemplate)
				} label: {
					Image(systemName: "xmark")
				}
				.buttonStyle(.bordered)
				.tint(.red)
			}
			
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
					Image(systemName: "xmark")
				}
				.buttonStyle(.bordered)
				.tint(.white)
				.opacity(0)
			}
			.foregroundStyle(.secondary)
			
			ForEach($exerciseTemplate.sets) { $set in
				SetTemplateView(set: $set, deleteSet: deleteSet)
			}
		}
	}
	
	func deleteSet(target: SetTemplate) {
		exerciseTemplate.sets = exerciseTemplate.sets.filter { $0.id != target.id }
	}
}

#Preview("Main", traits: .fixedLayout(width: 400, height: 400)) {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	let template = ExerciseTemplate()
	
	modelContainer.mainContext.insert(template)
	
	template.exerciseDetails = Exercise(name: "Pullups", unit: .kg)
	template.sets = [
		SetTemplate(value: 10, reps: 10, rpe: 5),
		SetTemplate(value: 10, reps: 10, rpe: 5),
	]
	
	return NavigationStack {
		ExerciseTemplateView(exerciseTemplate: template, deleteExerciseTemplate: { _ in })
			.modelContainer(modelContainer)
	}
}
