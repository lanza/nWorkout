import Combine
import Foundation

class NewWorkout: ObservableObject, Codable, Identifiable {
  @Published var note = ""
  var isWorkout = false
  var lifts: [NewLift] = []
  var name = ""
  var isComplete = false
  @Published var startDate = Date()
  @Published var finishDate: Date?

  let id = UUID()

  public enum CodingKeys: String, CodingKey {
    case note
    case isWorkout
    case name
    case isComplete
    case lifts
    case startDate
    case finishDate
  }

  init() {}

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    note = try container.decode(String.self, forKey: .note)
    isWorkout = try container.decode(Bool.self, forKey: .isWorkout)
    name = try container.decode(String.self, forKey: .name)
    isComplete = try container.decode(Bool.self, forKey: .isComplete)
    lifts = try container.decode(Array<NewLift>.self, forKey: .lifts)
    startDate = try container.decode(Date.self, forKey: .startDate)
    finishDate = try? container.decode(Date.self, forKey: .finishDate)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(note, forKey: .note)
    try container.encode(isWorkout, forKey: .isWorkout)
    try container.encode(name, forKey: .name)
    try container.encode(isComplete, forKey: .isComplete)
    try container.encode(lifts, forKey: .lifts)
    try container.encode(startDate, forKey: .startDate)
    try container.encode(finishDate, forKey: .finishDate)
  }

  var activeOrFinished: ActiveOrFinished {
    return isComplete ? .finished : .active
  }

  var isFinished: Bool { return activeOrFinished == .finished }

  func addNewSet(for lift: NewLift) -> NewSet {
    let last = lift.sets.last
    let set = NewSet.new(
      isWorkout: isWorkout,
      isWarmup: false,
      weight: last?.weight ?? 45,
      reps: last?.reps ?? 6,
      completedWeight: 0,
      completedReps: 0,
      lift: lift
    )
    lift.sets.append(set)
    return set
  }

  func addNewLift(name: String) -> NewLift {
    let lift = NewLift.new(isWorkout: isWorkout, name: name, workout: self)
    lifts.append(lift)
    return lift
  }

  static func new(isWorkout: Bool, isComplete: Bool, name: String) -> NewWorkout
  {
    let workout = NewWorkout()
    workout.name = name
    workout.isWorkout = isWorkout
    workout.isComplete = isComplete
    JDB.shared.addWorkout(workout)
    return workout
  }

  func deleteSelf() {
    fatalError("This just needs to be removed from JDB array")
  }
}

extension NewWorkout {
  func makeWorkoutWorkout() -> NewWorkout {
    let workout = NewWorkout.new(isWorkout: true, isComplete: false, name: name)

    for lift in lifts {
      let new = lift.makeWorkoutLift(workout: workout)
      workout.lifts.append(new)
    }
    return workout
  }
}

extension NewWorkout: DataProvider {
  func append(_ object: NewLift) {
    lifts.append(object)
  }

  func numberOfItems() -> Int {
    return lifts.count
  }

  func object(at index: Int) -> NewLift {
    return lifts[index]
  }

  func index(of object: NewLift) -> Int? {
    return lifts.firstIndex(where: { $0 === object })
  }

  func insert(_ object: NewLift, at index: Int) {
    lifts.insert(object, at: index)
  }

  func remove(at index: Int) {
    lifts.remove(at: index)
  }

  func move(from sourceIndex: Int, to destinationIndex: Int) {
    let lift = lifts[sourceIndex]
    lifts.remove(at: sourceIndex)
    lifts.insert(lift, at: destinationIndex)
  }
}
