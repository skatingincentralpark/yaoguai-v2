//
//  WorkoutDashboardV2.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 6/7/2024.
//

import SwiftUI
import SwiftData

struct WorkoutDashboardV2: View {
	@Environment(\.modelContext) private var modelContext
	
	@State private var workoutRecord: WorkoutRecord? = nil
	@State private var editorSheetPresented = false
	@State private var startTime: Date = Date.now
	
	init() {
		
	}
	
	var body: some View {
		if let workoutRecord {
			WorkoutRecordEditor(workoutRecord: workoutRecord, onComplete: onComplete, onCancel: onCancel)
				.safeAreaInset(edge: .bottom) {
					TimerView(startTime: $startTime)
				}
			ExerciseRecordCount()
		} else {
			NavigationStack {
				ScrollView {
					VStack(spacing: 30) {
						Templates(start: start)
						WorkoutHistory()
						Button("Start Workout") {
							start()
						}
						.buttonStyle(.borderedProminent)
					}	
					.padding()
				}
			}
		}
	}
	
	func start(template: WorkoutTemplate? = nil) {
		if let template {
			workoutRecord = WorkoutRecord(from: template)
		} else {
			workoutRecord = WorkoutRecord()
		}
		
		startTime = Date.now
	}
	
	func onComplete() {
		if let workoutRecord {
			modelContext.insert(workoutRecord)
		}
		workoutRecord = nil
	}
	
	func onCancel() {
		if let workoutRecord {
			modelContext.delete(workoutRecord)
		}
		workoutRecord = nil
	}
	
	struct TimerView: View {
		@Binding var startTime: Date
		@State private var currentTime = Date.now
		let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
		
		var timeIntervalSinceNow: Int {
			Int(currentTime.timeIntervalSince(startTime).rounded())
		}
		
		var body: some View {
			Text("\(timeIntervalSinceNow) seconds")
				.onReceive(timer) { input in
					currentTime = input
				}
		}
	}
	
	struct Templates: View {
		@Query private var template: [WorkoutTemplate]
		var start: (WorkoutTemplate?) -> Void
		
		var body: some View {
			VStack(alignment: .leading) {
				Text("Templates")
					.bold()
				ForEach(template) { template in
					Button(template.name) {
						start(template)
					}
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
		}
	}
	
	struct WorkoutHistory: View {
		@Query private var workoutRecords: [WorkoutRecord]
		@State private var editingWorkout: WorkoutRecord? = nil
		
		var body: some View {
			VStack(alignment: .leading) {
				Text("Workout History")
					.bold()
				ForEach(workoutRecords) { record in
					Button {
						editingWorkout = record
					} label: {
						HStack {
							Text(record.name).bold()
							Text(record.date.formatted()).foregroundStyle(.secondary)
						}
					}
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.sheet(item: $editingWorkout) { workout in
				WorkoutRecordEditor(workoutRecord: workout)
			}
		}
	}
	
	struct ExerciseRecordCount: View {
		@Query private var exerciseRecords: [ExerciseRecord]
		var body: some View {
			VStack {
				ForEach(exerciseRecords) { record in
					Text("record")
				}
			}
		}
	}
}

#Preview {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, 
											 configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	modelContainer.mainContext.insert(WorkoutTemplate.example.lower)
	modelContainer.mainContext.insert(WorkoutTemplate.example.upper)
	
	return WorkoutDashboardV2()
		.modelContainer(modelContainer)
}
