//
//  ExerciseRecordViewHeader.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 16/6/2024.
//

import SwiftUI

struct ExerciseRecordHeaderRow: View {
	var body: some View {
		HStack {
			Group {
				Text("KG")
					.frame(maxWidth: .infinity, alignment: .leading)
				Text("Reps")
					.frame(maxWidth: .infinity, alignment: .leading)
				Text("RPE")
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			.font(.caption)
			
			Spacer()
			
			Button {} label: {
				Image(systemName: "checkmark")
			}
			.buttonStyle(.bordered)
			.tint(.white)
			.opacity(0)
			
			Button {} label: {
				Image(systemName: "xmark")
			}
			.buttonStyle(.bordered)
			.tint(.white)
			.opacity(0)
		}
		.foregroundStyle(.secondary)
	}
}

#Preview {
	ExerciseRecordHeaderRow()
}
