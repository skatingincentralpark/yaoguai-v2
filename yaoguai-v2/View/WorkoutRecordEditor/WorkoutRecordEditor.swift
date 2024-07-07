//
//  WorkoutRecordEditor.swift
//  yaoguai-v2
//
//  Created by Charles Zhao on 5/7/2024.
//

import SwiftUI
import SwiftData

/// This view does not mutate the given WorkoutRecord directly.  Instead it copies
/// the properties into it's own local state, to force the WorkoutRecord to be
/// explicitly overriden.
struct WorkoutRecordEditor: View {
	let workoutRecord: WorkoutRecord?
	
	@Environment(\.scenePhase) private var scenePhase
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext

	@State private var name = ""
	@State private var exercises: [ExerciseRecord] = []
	
	@State private var exerciseSelectorPresented = false
	
	var autosave: ((String, [ExerciseRecord]) -> Void)?
	var onComplete: (() -> Void)?
	var onCancel: (() -> Void)?
	
	private var editorTitle: String {
		workoutRecord == nil ? "Blank Workout" : "Edit Workout"
	}
	
	var body: some View {
		NavigationStack {
			VStack {
				ScrollView {
					ForEach(exercises) { exercise in
						ExerciseRecordEditor(exercise: exercise, delete: deleteExercise)
							.padding(.bottom)
					}
				}
				.padding()
			}
			.safeAreaInset(edge: .top, content: {
				VStack {
					Text(editorTitle).bold()

					LabeledContent {
						TextField("Workout Name", text: $name)
							.textFieldStyle(.roundedBorder)
					} label: {
						Text("Name")
					}
					
					HStack {
						Button {
							exerciseSelectorPresented = true
						} label: {
							Text("Add")
								.frame(maxWidth: .infinity)
						}
						.frame(maxWidth: .infinity)
						.buttonStyle(.bordered)
						.tint(.blue)
						
						Button {
							if name.isEmpty {
								print("Name is empty!")
								return
							}
							
							if exercises.count == 0 {
								print("Exercise are empty!")
								return
							}
							
							workoutRecord?.name = name
							workoutRecord?.exercises = exercises
							onComplete?()
						} label: {
							Text("Finish")
								.frame(maxWidth: .infinity)
						}
						.frame(maxWidth: .infinity)
						.buttonStyle(.bordered)
						.tint(.green)
						
						Button(role: .destructive) {
							try? modelContext.transaction {
								exercises.forEach { exercise in
									modelContext.delete(exercise)
								}
							}
							
							onCancel?()
							dismiss()
						} label: {
							Text("Cancel")
								.frame(maxWidth: .infinity)
						}
						.frame(maxWidth: .infinity)
						.buttonStyle(.bordered)
						.tint(.red)
					}
				}
				.padding()
				.background(.bar)
			})
			.sheet(isPresented: $exerciseSelectorPresented) {
				ExerciseSelector(addExercise: addExercise)
			}
		}
		.onDisappear {
			autosave?(name, exercises)
		}
		.onChange(of: scenePhase) { before, after in
			if after == .background {
				autosave?(name, exercises)
			}
		}
	}
	
	func addExercise(_ exercise: Exercise) {
		let exerciseRecord = ExerciseRecord()
		exerciseRecord.exerciseDetails = exercise
		exercises.append(exerciseRecord)
	}
	
	func deleteExercise(exercise: ExerciseRecord) {
		if let idx = exercises.firstIndex(of: exercise) {
			exercises.remove(at: idx)
		}
	}
	
	/// For editing an existing WorkoutRecord.  We copy all the properties
	/// to local state, allowing for intentional modification.
	init(workoutRecord: WorkoutRecord? = nil, onComplete: (() -> Void)? = nil, onCancel: (() -> Void)? = nil) {
		self.workoutRecord = workoutRecord
		self.onComplete = onComplete
		self.onCancel = onCancel
		
		if let workoutRecord {
			self._name = State(initialValue: workoutRecord.name)
			let initialExercises = workoutRecord.exercises.map({ ExerciseRecord(sets: $0.sets, exerciseDetails: $0.exerciseDetails) })
			self._exercises = State(initialValue: initialExercises)
		}
	}
	
	/// For continuing a workout that has started.  You are expected to have
	/// stored the name and exercises outside this View.  We are making
	/// the `autosave` closure required as that will allow us to pass
	/// the `name` and `exercises` to be persisted.
	init(initialName: String, initialExercises: [ExerciseRecord], workoutRecord: WorkoutRecord?,
		 /** 🚨🚨🚨    TO-DO: I'M NOT SURE WHAT `@escaping` FIGURE THAT OUT! */
		 /// autosave fires everytime user closes the app or the view disappears
		 autosave: @escaping (String, [ExerciseRecord]) -> Void,
		 onComplete: (() -> Void)? = nil,
		 onCancel: (() -> Void)? = nil
	) {
		self.workoutRecord = workoutRecord
		self._name = State(initialValue: initialName)
		self._exercises = State(initialValue: initialExercises)
		self.autosave = autosave
		self.onComplete = onComplete
		self.onCancel = onCancel
	}
}

struct ExerciseRecordEditor: View {
	@Bindable var exercise: ExerciseRecord
	var delete: (ExerciseRecord) -> Void
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(exercise.exerciseDetails?.name ?? "").bold()
				
				Spacer()
				
				Button("Delete", role: .destructive) {
					delete(exercise)
				}
				.buttonStyle(.bordered)
				.tint(.red)
				
				Button("Add Set") {
					exercise.sets.append(SetRecord())
				}
				.buttonStyle(.bordered)
				.tint(.blue)
			}
			.padding(.bottom)
			
			ForEach($exercise.sets) { $set in
				SetRecordEditor(set: $set, delete: deleteSet)
			}
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	func deleteSet(set: SetRecord) {
		if let idx = exercise.sets.firstIndex(of: set) {
			exercise.sets.remove(at: idx)
		}
	}
}

struct SetRecordEditor: View {
	@Binding var set: SetRecord
	
	var delete: (SetRecord) -> Void
	
	@FocusState private var valueFocused: Bool
	@FocusState private var repsFocused: Bool
	@FocusState private var rpeFocused: Bool
	
	var body: some View {
		HStack {
			TextField("\(set.template?.valueString ?? "Value")", value: $set.value, format: .number)
				.keyboardType(.numberPad)
				.focused($valueFocused)
				.textFieldStyle(.specialFocus(focused: valueFocused))
			
			
			TextField("\(set.template?.repsString ?? "Reps")", value: $set.reps, format: .number)
				.keyboardType(.numberPad)
				.focused($repsFocused)
				.textFieldStyle(.specialFocus(focused: repsFocused))
			
			
			TextField("\(set.template?.rpeString ?? "RPE")", value: $set.rpe, format: .number)
				.keyboardType(.numberPad)
				.focused($rpeFocused)
				.textFieldStyle(.specialFocus(focused: rpeFocused))
			
			Button(role: .destructive) {
				delete(set)
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

#Preview {
	do {
		let modelContainer: ModelContainer
		modelContainer = try ModelContainer(for: ExerciseRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
		
		let exerciseDetail1 = Exercise(name: "Pullups", unit: .kg)
		let exerciseDetail2 = Exercise(name: "Squats", unit: .kg)
		
		modelContainer.mainContext.insert(exerciseDetail1)
		modelContainer.mainContext.insert(exerciseDetail2)
		
		let exercise1 = ExerciseRecord(sets: [SetRecord(), SetRecord(), SetRecord()], exerciseDetails: exerciseDetail1)
		let exercise2 = ExerciseRecord(sets: [SetRecord(), SetRecord(), SetRecord()], exerciseDetails: exerciseDetail2)
		
		modelContainer.mainContext.insert(exercise1)
		modelContainer.mainContext.insert(exercise2)
		
		let workoutRecord = WorkoutRecord(name: "Full Body")
		workoutRecord.exercises = [
			exercise1,
			exercise2,
		]
		
		return WorkoutRecordEditor(workoutRecord: workoutRecord)
			.modelContainer(modelContainer)
	} catch {
		return Text("Problem Building ModelContainer for #Preview")
	}
}
