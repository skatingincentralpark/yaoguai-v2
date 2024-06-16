//
//  Record.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import Foundation
import SwiftData

struct SetRecord: Identifiable, Codable, Equatable {
	var id = UUID()
	var value: Double?
	var rpe: Double?
	var reps: Int?
	var complete = false
	
	var valueString: String? {
		guard let value = value else { return nil }
		return String(value)
	}
	
	var rpeString: String? {
		guard let rpe = rpe else { return nil }
		return String(rpe)
	}
	
	var repsString: String? {
		guard let reps = reps else { return nil }
		return String(reps)
	}
}

@Model
final class WorkoutRecord {
	var name: String
	@Relationship(deleteRule: .cascade) var exercises = [ExerciseRecord]()
	
	init(name: String) {
		self.name = name
	}
}

@Model
final class ExerciseRecord {
	var workoutRecord: WorkoutRecord?
	var sets = [SetRecord]()
	var exerciseDetails: Exercise?
	
	init() {
		
	}
}
