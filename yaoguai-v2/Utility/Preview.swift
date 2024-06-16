//
//  Preview.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import Foundation
import SwiftData

struct PreviewContainer {
	let container: ModelContainer!
	
	init(
		_ types: [any PersistentModel.Type],
		isStoredInMemoryOnly: Bool = true
	) {
		let schema = Schema(types)
		let config = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
		self.container = try! ModelContainer(for: schema, configurations: [config])
	}
	
	func add(items: [any PersistentModel]) {
		Task { @MainActor in
			items.forEach { container.mainContext.insert($0) }
		}
	}
}
