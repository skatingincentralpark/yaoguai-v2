//
//  ContentView.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
	
	@Query private var workoutTemplates: [WorkoutTemplate]
	@Query private var workoutRecords: [WorkoutRecord]

    var body: some View {
		NavigationStack {
			List {
				Section("Templates") {
					ForEach(workoutTemplates) { template in
						HStack {
							Text(template.name)
						}
					}
					
					NavigationLink("Add New") {
						WorkoutTemplateEditor()
					}
				}
			}
			.navigationTitle("Yaoguai")
		}
    }
}

#Preview {
	let modelContainer = try! ModelContainer(for: WorkoutTemplate.self, WorkoutRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
	
	let templateUpper = WorkoutTemplate(name: "Upper")
	let templateLower = WorkoutTemplate(name: "Lower")
	
	modelContainer.mainContext.insert(templateUpper)
	modelContainer.mainContext.insert(templateLower)
	
    return ContentView()
		.modelContainer(modelContainer)
}
