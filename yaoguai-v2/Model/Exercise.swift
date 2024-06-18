//
//  Exercise.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import Foundation
import SwiftData

enum Unit: String, Codable, CaseIterable, Identifiable {
	case kg
	case seconds
	case km
	
	var id: Self { self }
}

@Model
final class Exercise {
	@Attribute(.unique) var name: String
	var unit: Unit
	var exerciseRecords = [ExerciseRecord]()
	
	init(name: String, unit: Unit) {
		self.name = name
		self.unit = unit
	}
}

extension Exercise {
	enum Example {
		static var pullups: Exercise {
			Exercise(name: "Pullups", unit: .kg)
		}
		
		static var pushups: Exercise {
			Exercise(name: "Pushups", unit: .kg)
		}
		
		static var squats: Exercise {
			Exercise(name: "Squats", unit: .kg)
		}
		
		static var deadlifts: Exercise {
			Exercise(name: "Deadlifts", unit: .kg)
		}
		
		static var all: [Exercise] {
			return [pullups, pushups, squats, deadlifts]
		}
	}

	static var example: Example.Type {
		return Example.self
	}
}
