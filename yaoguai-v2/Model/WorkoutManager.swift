//
//  WorkoutManager.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 17/6/2024.
//

import Foundation
import SwiftData
import SwiftUI

final class WorkoutManager: ObservableObject {
	@Published var currentWorkout: WorkoutRecord?
	@Published var currentWorkoutTemplate: WorkoutTemplate?
	
	func startWorkout(with template: WorkoutTemplate) {
		let workout = WorkoutRecord(from: template)
		currentWorkout = workout
		currentWorkoutTemplate = template
		// Additional logic to start the workout can be added here
	}
	
	func endWorkout() {
		currentWorkout = nil
		currentWorkoutTemplate = nil
		// Additional logic to end the workout can be added here
	}
	
	// Add more methods as needed to manage workouts
}
