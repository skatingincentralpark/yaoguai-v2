//
//  WorkoutControlsSection.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 30/6/2024.
//

import SwiftUI

struct WorkoutControlsSection: View {
	let currentWorkout: WorkoutRecord?
	let startWorkout: (WorkoutTemplate?) -> Void
	let cancelWorkout: () -> Void
	
    var body: some View {
		HStack {
			Button(currentWorkout == nil ? "Start Blank Workout" : "Continue Workout") {
				startWorkout(nil)
			}
			.buttonStyle(.borderedProminent)
			if currentWorkout != nil {
				Button("Cancel") {
					cancelWorkout()
				}
				.buttonStyle(.bordered)
			}
		}
    }
}

#Preview {
    WorkoutControlsSection(currentWorkout: WorkoutRecord(), startWorkout: {_ in }, cancelWorkout: {})
}
