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
final class ExerciseTemplate {
	var workoutTemplate: WorkoutTemplate?
	var sets = [SetTemplate]()
	var exerciseDetails: Exercise?
	
	init(sets: [SetTemplate]? = nil, exerciseDetails: Exercise? = nil) {
		if let sets {
			self.sets = sets
		}
		if let exerciseDetails {
			self.exerciseDetails = exerciseDetails
		}
	}
}

@Model
final class WorkoutTemplate {
	var name: String
	@Relationship(deleteRule: .cascade) var exercises = [ExerciseTemplate]()
	
	init(name: String, exercises: [ExerciseTemplate]? = nil) {
		self.name = name
		
		if let exercises {
			self.exercises = exercises
		}
	}
}

// MARK: - Example Extensions

extension SetTemplate {
	static var example: SetTemplate {
		SetTemplate(value: 100.0, reps: 10, rpe: 8.0)
	}
}

extension ExerciseTemplate {
	enum Example {
		static var pullups: ExerciseTemplate {
			ExerciseTemplate(sets: [SetTemplate.example, SetTemplate.example], exerciseDetails: Exercise.example.pullups)
		}
		
		static var pushups: ExerciseTemplate {
			ExerciseTemplate(sets: [SetTemplate.example, SetTemplate.example], exerciseDetails: Exercise.example.pushups)
		}
		
		static var squats: ExerciseTemplate {
			ExerciseTemplate(sets: [SetTemplate.example, SetTemplate.example], exerciseDetails: Exercise.example.squats)
		}
		
		static var deadlifts: ExerciseTemplate {
			ExerciseTemplate(sets: [SetTemplate.example, SetTemplate.example], exerciseDetails: Exercise.example.deadlifts)
		}
	}
	
	static var example: Example.Type {
		return Example.self
	}
}

extension WorkoutTemplate {
	enum Example {
		static var upper: WorkoutTemplate {
			WorkoutTemplate(name: "Upper", exercises: [ExerciseTemplate.example.pullups, ExerciseTemplate.example.pushups])
		}
		
		static var lower: WorkoutTemplate {
			WorkoutTemplate(name: "Lower", exercises: [ExerciseTemplate.example.squats, ExerciseTemplate.example.deadlifts])
		}
	}
	
	static var example: Example.Type {
		return Example.self
	}
}
