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
	var reps: Int?
	var rpe: Double?
	var template: SetTemplate?
	
	private var _complete = false
	
	var complete: Bool {
		get {
			_complete
		}
		set {
			autofill()
			template = nil
			_complete = newValue
		}
	}
	
	private mutating func autofill() {
		if value == nil { value = template?.value ?? 0 }
		if reps == nil { reps = template?.reps ?? 0 }
		if rpe == nil { rpe = template?.rpe ?? 0 }
	}
	
	var valueString: String {
		guard let value = value else { return "" }
		return String(value)
	}
	
	var rpeString: String {
		guard let rpe = rpe else { return "" }
		return String(rpe)
	}
	
	var repsString: String {
		guard let reps = reps else { return "" }
		return String(reps)
	}
}

extension SetRecord {
	init(from template: SetTemplate) {
		self.template = template
	}
}

@Model
final class ExerciseRecord {
	var workoutRecord: WorkoutRecord?
	var sets = [SetRecord]()
	var exerciseDetails: Exercise?
	
	init(sets: [SetRecord]? = nil, exerciseDetails: Exercise? = nil) {
		if let sets {
			self.sets = sets
		}
		
		if let exerciseDetails {
			self.exerciseDetails = exerciseDetails
		}
	}
	
	init(from template: ExerciseTemplate) {
		self.exerciseDetails = template.exerciseDetails
		self.sets = template.sets.map { setTemplate in
			SetRecord(from: setTemplate)
		}
	}
}

@Model
final class WorkoutRecord {
	var name = ""
	var date: Date = Date()
	@Relationship(deleteRule: .cascade) var exercises = [ExerciseRecord]()
	
	init(name: String, exercises: [ExerciseRecord]? = nil) {
		self.name = name
		
		if let exercises {
			self.exercises = exercises
		}
	}
	
	init(from template: WorkoutTemplate) {
		self.name = template.name
		self.exercises = template.exercises.map { template in
			ExerciseRecord(from: template)
		}
	}
	
	init() {
		
	}
}

// MARK: - Example Extensions

extension SetRecord {
	enum Example {
		static var complete: SetRecord {
			var record = SetRecord(value: 100.0, reps: 10, rpe: 8.0)
			record.complete = true
			return record
		}
		
		static var incomplete: SetRecord {
			SetRecord(value: 100.0, reps: 10, rpe: 8.0)
		}
		
		static var withTemplate: SetRecord {
			SetRecord(template: SetTemplate(value: 20.0, reps: 5, rpe: 5.0))
		}
	}
	
	static var example: Example.Type {
		Example.self
	}
}

extension ExerciseRecord {
	static var example: ExerciseRecord {
		ExerciseRecord(
			sets: [SetRecord.example.incomplete, SetRecord.example.incomplete],
			exerciseDetails: Exercise.example.pullups
		)
	}
}

extension WorkoutRecord {
	static var example: WorkoutRecord {
		WorkoutRecord(name: "Upper", exercises: [ExerciseRecord.example])
	}
}
