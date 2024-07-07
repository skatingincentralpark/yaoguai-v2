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

/// On initialisation, will try to fetch "CurrentWorkout" from the documents dir,
/// and decode it as SavedData, and populating name and exercises.
@Observable
final class WorkoutManager {
	var name: String
	var exercises: [ExerciseRecord]
	
	var currentWorkout: WorkoutRecord?
	
	let savePath = URL.documentsDirectory.appending(path: "CurrentWorkout")
	init(modelContext: ModelContext) {
		do {
			let data = try Data(contentsOf: savePath)
			let savedData = try JSONDecoder().decode(SavedData.self, from: data)
			
			print("initialising WorkoutManager")
			print(savedData)
			
			try modelContext.transaction {
				savedData.exercises.forEach { modelContext.insert($0) }
			}
			
			exercises = savedData.exercises
			name = savedData.name
			currentWorkout = savedData.workout
		} catch {
			exercises = []
			name = ""
			currentWorkout = nil
		}
	}
	
	func save(name: String, exercises: [ExerciseRecord]) {
		self.name = name
		self.exercises = exercises
		
		do {
			let data = try JSONEncoder().encode(SavedData(name: name, exercises: exercises, workout: currentWorkout ?? nil))
			try data.write(to: savePath, options: [.atomic, .completeFileProtection])
		} catch {
			print("Unable to save data.")
		}
	}
	func clear() {
		name = ""
		exercises = []
	}
}

extension WorkoutManager {
	struct SavedData: Codable {
		var name: String
		var exercises: [ExerciseRecord]
		var workout: WorkoutRecord?
	}
}
