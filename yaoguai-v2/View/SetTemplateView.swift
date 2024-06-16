//
//  SetTemplateView.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import SwiftUI
import SwiftData

struct SetTemplateView: View {
	@Binding var set: SetTemplate
	var deleteSet: (SetTemplate) -> Void
	
    var body: some View {
		HStack {
			TextField("Value", value: $set.value, format: .number)
				.textFieldStyle(.roundedBorder)
			
			TextField("Reps", value: $set.reps, format: .number)
				.textFieldStyle(.roundedBorder)
			
			TextField("RPE", value: $set.rpe, format: .number)
				.textFieldStyle(.roundedBorder)
			
			Button(role: .destructive) {
				deleteSet(set)
			} label: {
				Image(systemName: "xmark")
			}
			.buttonStyle(.bordered)
			.tint(.red)
		}
    }
}


#Preview("Empty", traits: .fixedLayout(width: 400, height: 50)) {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	return NavigationStack {
		SetTemplateView(set: .constant(SetTemplate()), deleteSet: { _ in })
			.modelContainer(modelContainer)
	}
}

#Preview("Prefilled", traits: .fixedLayout(width: 400, height: 50)) {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	return NavigationStack {
		SetTemplateView(set: .constant(SetTemplate(value: 10, reps: 10, rpe: 5)), deleteSet: { _ in })
			.modelContainer(modelContainer)
	}
}
