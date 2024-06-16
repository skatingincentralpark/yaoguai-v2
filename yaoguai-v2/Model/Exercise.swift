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
	var name: String
	var unit: Unit
	var exerciseRecords = [ExerciseRecord]()
	
	init(name: String, unit: Unit) {
		self.name = name
		self.unit = unit
	}
}
