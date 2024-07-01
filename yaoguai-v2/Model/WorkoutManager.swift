//
//  WorkoutManager.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 17/6/2024.
//

import Foundation
import SwiftData
import SwiftUI
import Observation

@Observable
final class WorkoutManager {
	var currentWorkout: WorkoutRecord?
	var context: ModelContext
	
	init(context: ModelContext) {
		self.context = context
	}
	
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
		
//		workoutSheetVisible = true
	}
	
	func cancelWorkout() {
		withAnimation {
			if let currentWorkout {
				context.delete(currentWorkout)
			}
			currentWorkout = nil
		}
//		workoutSheetVisible = false
	}
	
	func completeWorkout() {
		if let currentWorkout {
			if !currentWorkout.exercises.isEmpty {
				withAnimation {
					context.insert(currentWorkout)
				}
			} else {
				// Since we're autosaving, need to remove from context
				context.delete(currentWorkout)
			}
		}
		
		self.currentWorkout = nil
//		workoutSheetVisible = false
	}
}
