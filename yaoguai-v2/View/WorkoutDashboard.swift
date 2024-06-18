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
	
	@Query private var workoutTemplates: [WorkoutTemplate]
	@Query private var workoutRecords: [WorkoutRecord]
	
	@State private var navigationPath = NavigationPath()
	@State private var currentWorkout: WorkoutRecord?
	@State private var workoutSheetVisible = false

	var body: some View {
		NavigationStack(path: $navigationPath) {
			List {
				Section {
					ForEach(workoutTemplates) { template in
						HStack {
							Button(template.name) {
								startWorkout(from: template)
							}
							.foregroundStyle(currentWorkout != nil ? .secondary : .primary)
							.disabled(currentWorkout != nil)
							
							Spacer()
							
							Button("Edit") {
								print("2222")
								navigationPath.append(template)
							}
							.buttonStyle(.bordered)
						}
					}
					.onDelete { indexSet in
						indexSet.forEach { index in
							modelContext.delete(workoutTemplates[index])
						}
					}
					
					NavigationLink("Add New") {
						WorkoutTemplateEditor()
					}
				} header: {
					Text("Start from template")
				} footer: {
					Text("A template allows you to start a workout with predetermined exercises and sets.  Weight and metrics can be set too - allowing you to 'autofill' exercise data.")
				}
				
				Section {
					Button(currentWorkout == nil ? "Start Blank Workout" : "Continue Workout") {
						startWorkout()
					}
					
					if currentWorkout != nil {
						Button("Cancel") {
							cancelWorkout()
						}
					}
				}
				Section {
					if workoutRecords.count > 0 {
						ForEach(workoutRecords) { record in
							HStack {
								Text(record.name)
								Spacer()
								Text(record.date.formatted())
									.foregroundStyle(.secondary)
							}
						}
					} else {
						Text("No workouts yet")
							.foregroundStyle(.secondary)
					}
				} header: {
					Text("Workout Records")
				}
			}
			.navigationTitle("Yaoguai")
			.navigationDestination(for: WorkoutTemplate.self) { template in
				WorkoutTemplateEditor(existingTemplate: template)
			}
			.sheet(isPresented: $workoutSheetVisible) {
				if let currentWorkout {
					WorkoutView(workoutRecord: currentWorkout, cancelWorkout: cancelWorkout, completeWorkout: completeWorkout)
				}
			}
		}
	}
	
	func startWorkout(from template: WorkoutTemplate? = nil) {
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
			currentWorkout = nil
		}
		workoutSheetVisible = false
	}
	
	func completeWorkout() {
		if let currentWorkout {
			withAnimation {
				modelContext.insert(currentWorkout)
			}
		}
		
		currentWorkout = nil
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
