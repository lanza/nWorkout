import Foundation

enum JDB {
  static func write() {
    guard let workouts = workouts else { return }
    do {
      let encoded = try JSONEncoder().encode(workouts)
      try encoded.write(
        to: getDocumentsDirectory().appendingPathComponent("data.json"),
        options: .atomicWrite)
    } catch {
      fatalError()
    }
  }

  static func getFilePath() -> URL {
    return getDocumentsDirectory().appendingPathComponent("data.json")
  }

  private static var workouts: [NewWorkout]! = nil

  static func getWorkouts() -> [NewWorkout] {
    if workouts == nil {
      let d = try! Data(contentsOf: getFilePath())
      workouts = try! JSONDecoder().decode([NewWorkout].self, from: d)
      for workout in workouts {
        for lift in workout.lifts {
          for set in lift.sets {
            set.lift = lift
          }
          lift.workout = workout
        }
      }
    }
    return workouts
  }

  static func getLifts() -> [NewLift] {
    return getWorkouts().map { $0.lifts }.reduce([], +)
  }

  static func addWorkout(_ workout: NewWorkout) {
    if JDB.workouts.contains(where: { $0 === workout }) {
      return
    } else {
      JDB.workouts.append(workout)
      JDB.write()
    }
  }
}
