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
		Section {
			Button(currentWorkout == nil ? "Start Blank Workout" : "Continue Workout") {
				startWorkout(nil)
			}
			if currentWorkout != nil {
				Button("Cancel") {
					cancelWorkout()
				}
			}
		}
    }
}

#Preview {
    WorkoutControlsSection(currentWorkout: WorkoutRecord(), startWorkout: {_ in }, cancelWorkout: {})
}
