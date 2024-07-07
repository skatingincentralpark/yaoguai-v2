//
//  WorkoutDashboard.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import SwiftUI
import SwiftData

struct WorkoutDashboard: View {
	@Environment(\.modelContext) private var modelContext
	@Environment(WorkoutManager.self) private var workoutManager: WorkoutManager
	
	@State private var navigationPath = NavigationPath()
	@State private var workoutSheetVisible = false
	
	var body: some View {
		NavigationStack(path: $navigationPath) {
			List {
//				TemplateSection(startWorkout: startWorkout, currentWorkout: currentWorkout, navigationPath: $navigationPath)
				AllWorkoutRecordsSection()
				NavigationLink("WWW") {
					WorkoutRecordEditor(initialName: workoutManager.name,
										initialExercises: workoutManager.exercises,
										workoutRecord: workoutManager.currentWorkout,
										autosave: workoutManager.save)
				}
			}
			.safeAreaInset(edge: .bottom, content: {
				WorkoutControlsSection(currentWorkout: workoutManager.currentWorkout, startWorkout: startWorkout, cancelWorkout: cancelWorkout)
			})
			.navigationTitle("Yaoguai")
			.navigationDestination(for: WorkoutTemplate.self) { template in
				WorkoutTemplateEditor(existingTemplate: template)
			}
//			.sheet(isPresented: $workoutSheetVisible) {
//				WorkoutRecordEditor(initialName: workoutManager.name,
//									initialExercises: workoutManager.exercises,
//									workoutRecord: workoutManager.currentWorkout,
//									autosave: workoutManager.save)
//			}
			.onChange(of: workoutManager.name) { oldValue, newValue in
				print("Change from \(oldValue) to \(newValue)")
			}
		}
	}
}

extension WorkoutDashboard {
	func startWorkout(_ template: WorkoutTemplate? = nil) {
		if workoutManager.currentWorkout == nil {
			if let template { workoutManager.currentWorkout = WorkoutRecord(from: template) }
			else { workoutManager.currentWorkout = WorkoutRecord() }
		}
		workoutSheetVisible = true
	}
	
	func cancelWorkout() {
		if let currentWorkout = workoutManager.currentWorkout {
			modelContext.delete(currentWorkout)
		}
		workoutManager.currentWorkout = nil
		workoutSheetVisible = false
	}
	
	func completeWorkout() {
		if let currentWorkout = workoutManager.currentWorkout {
			if !currentWorkout.exercises.isEmpty {
				
				currentWorkout.exercises.forEach { record in
					record.sets = record.sets.filter({ $0.complete })
				}
				
				currentWorkout.exercises = currentWorkout.exercises.filter({ $0.sets.count > 0 })
				
				withAnimation {
					modelContext.insert(currentWorkout)
				}
			} else {
				// Since we're autosaving, need to remove from context
				modelContext.delete(currentWorkout)
			}
		}
		
		workoutManager.currentWorkout = nil
		workoutSheetVisible = false
	}
}

#Preview {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	modelContainer.mainContext.insert(WorkoutTemplate.example.lower)
	modelContainer.mainContext.insert(WorkoutTemplate.example.upper)
	
	var workoutManager: WorkoutManager
	workoutManager = WorkoutManager(modelContext: modelContainer.mainContext)
	
	return WorkoutDashboard()
		.modelContainer(modelContainer)
		.environment(workoutManager)
}
