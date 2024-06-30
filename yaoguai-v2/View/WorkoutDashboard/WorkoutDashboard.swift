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
	
	@State private var navigationPath = NavigationPath()
	@State private var currentWorkout: WorkoutRecord?
	@State private var workoutSheetVisible = false

	var body: some View {
		NavigationStack(path: $navigationPath) {
			List {
				TemplateSection(startWorkout: startWorkout, currentWorkout: currentWorkout, navigationPath: $navigationPath)
				WorkoutControlsSection(currentWorkout: currentWorkout, startWorkout: startWorkout, cancelWorkout: cancelWorkout)
				AllWorkoutRecordsSection()
			}
			.navigationTitle("Yaoguai")
			.navigationDestination(for: WorkoutTemplate.self) { template in
				WorkoutTemplateEditor(existingTemplate: template)
			}
			.sheet(isPresented: $workoutSheetVisible) {
				if let currentWorkout {
					WorkoutRecordView(workoutRecord: currentWorkout, cancelWorkout: cancelWorkout, completeWorkout: completeWorkout)
				}
			}
		}
	}
}

extension WorkoutDashboard {
	func startWorkout(_ template: WorkoutTemplate? = nil) {
		withAnimation {
			if currentWorkout == nil {
				if let template {
					currentWorkout = WorkoutRecord(from: template)
				} else {
					currentWorkout = WorkoutRecord()
				}
			}
		}
		
		workoutSheetVisible = true
	}
	func cancelWorkout() {
		withAnimation {
			if let currentWorkout {
				modelContext.delete(currentWorkout)
			}
			currentWorkout = nil
		}
		workoutSheetVisible = false
	}
	func completeWorkout() {
		if let currentWorkout {
			if !currentWorkout.exercises.isEmpty {
				withAnimation {
					modelContext.insert(currentWorkout)
				}
			} else {
				// Since we're autosaving, need to remove from context
				modelContext.delete(currentWorkout)
			}
		}
		
		self.currentWorkout = nil
		workoutSheetVisible = false
	}
}

#Preview {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	modelContainer.mainContext.insert(WorkoutTemplate.example.lower)
	modelContainer.mainContext.insert(WorkoutTemplate.example.upper)

	return WorkoutDashboard()
		.modelContainer(modelContainer)
}
