//
//  Template.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import Foundation
import SwiftData

struct SetTemplate: Identifiable, Codable, Equatable {
	var id = UUID()
	var value: Double?
	var reps: Int?
	var rpe: Double?
	
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
final class WorkoutTemplate {
	var name: String
	@Relationship(deleteRule: .cascade) var exercises = [ExerciseTemplate]()
	
	init(name: String) {
		self.name = name
	}
}

@Model
final class ExerciseTemplate {
	var workoutTemplate: WorkoutTemplate?
	var sets = [SetTemplate]()
	var exerciseDetails: Exercise?
	
	init() {
		
	}
}
