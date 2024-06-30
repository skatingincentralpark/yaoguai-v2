//
//  TemplateSection.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 30/6/2024.
//

import SwiftUI
import SwiftData

struct TemplateSection: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var workoutTemplates: [WorkoutTemplate]
	let startWorkout: (WorkoutTemplate?) -> Void
	let currentWorkout: WorkoutRecord?
	@Binding var navigationPath: NavigationPath
	
	var body: some View {
		Section {
			ForEach(workoutTemplates) { template in
				HStack {
					Button(template.name) {
						startWorkout(template)
					}
					.foregroundStyle(currentWorkout != nil ? .secondary : .primary)
					.disabled(currentWorkout != nil)
					
					Spacer()
					
					Button("Edit") {
						navigationPath.append(template)
					}
					.buttonStyle(.bordered)
				}
			}
			.onDelete { indexSet in
				indexSet.forEach { index in
					modelContext.delete(workoutTemplates[index])
				}
			}
			
			NavigationLink("Add New") {
				WorkoutTemplateEditor()
			}
		} header: {
			Text("Start from template")
		} footer: {
			Text("A template allows you to start a workout with predetermined exercises and sets.  Weight and metrics can be set too - allowing you to 'autofill' exercise data.")
		}
		
	}
}

#Preview {
	List {
		TemplateSection(startWorkout: {_ in }, currentWorkout: nil, navigationPath: .constant(NavigationPath()))
	}
}
