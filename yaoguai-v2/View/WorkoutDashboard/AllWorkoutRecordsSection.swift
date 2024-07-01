//
//  AllWorkoutRecordsSection.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 30/6/2024.
//

import SwiftUI
import SwiftData

struct AllWorkoutRecordsSection: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var workoutRecords: [WorkoutRecord]
	
	var body: some View {
		Section {
			if workoutRecords.count > 0 {
				ForEach(workoutRecords) { record in
					NavigationLink {
						WorkoutRecordView(workoutRecord: record, cancelWorkout: {}, completeWorkout: {})
					} label: {
						HStack {
							Text(record.name)
							Spacer()
							Text(record.date.formatted())
								.foregroundStyle(.secondary)
						}
					}
				}
				.onDelete { indexSet in
					indexSet.forEach { idx in
						modelContext.delete(workoutRecords[idx])
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
}

#Preview {
	AllWorkoutRecordsSection()
}
