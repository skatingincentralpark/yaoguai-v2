//
//  SetRecordRow.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import SwiftUI
import SwiftData

struct SetRecordRow: View {
	@Binding var set: SetRecord
	var deleteSet: (SetRecord) -> Void
	
	var body: some View {
		HStack {
			TextField("\(set.template?.valueString ?? "Value")", value: $set.value, format: .number)
				.textFieldStyle(.roundedBorder)
			
			TextField("\(set.template?.repsString ?? "Reps")", value: $set.reps, format: .number)
				.textFieldStyle(.roundedBorder)
			
			TextField("\(set.template?.rpeString ?? "RPE")", value: $set.rpe, format: .number)
				.textFieldStyle(.roundedBorder)
			
			Button(role: .destructive) {
				deleteSet(set)
			} label: {
				Image(systemName: "xmark")
			}
			.buttonStyle(.bordered)
			.tint(.red)
			
			Toggle(isOn: $set.complete) {
				Image(systemName: "checkmark")
			}
			.toggleStyle(.button)
			.buttonStyle(.bordered)
			.tint(set.complete ? .green : .black)
		}
	}
}

#Preview("Incomplete", traits: .fixedLayout(width: 400, height: 50)) {
	SetRecordRow(set: .constant(SetRecord.example.incomplete), deleteSet: { _ in })
}

#Preview("Complete", traits: .fixedLayout(width: 400, height: 50)) {
	SetRecordRow(set: .constant(SetRecord.example.complete), deleteSet: { _ in })
}

#Preview("With Placeholder", traits: .fixedLayout(width: 400, height: 50)) {
	SetRecordRow(set: .constant(SetRecord.example.withTemplate), deleteSet: { _ in })
}
