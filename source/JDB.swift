import Foundation

class JDB: ObservableObject {
  static let shared = JDB()
  func write() {
    do {
      let encoded = try JSONEncoder().encode(workouts)
      try encoded.write(
        to: getDocumentsDirectory().appendingPathComponent("data.json"),
        options: .atomicWrite)
    } catch {
      fatalError()
    }
  }

  func getFilePath() -> URL {
    // This database format will never be used again and will only ever be used
    // for serialization. This should always be false below.
    #if false
      return getDocumentsDirectory().appendingPathComponent("data.json")
    #else
      return Bundle.main.bundleURL.appendingPathComponent("data.json")
    #endif
  }

  @Published var workouts: [JWorkout] = []

  func setAllWorkouts(with workouts: [JWorkout]) {
    JDB.shared.workouts = workouts
  }

  func getWorkouts() -> [JWorkout] {
    if workouts.count == 0 {
      do {
        let d = try Data(contentsOf: getFilePath())
        workouts = try JSONDecoder().decode([JWorkout].self, from: d)
        for workout in workouts {
          for lift in workout.lifts {
            for set in lift.sets {
              set.lift = lift
            }
            lift.workout = workout
          }
        }
      } catch {
        workouts = []
      }
    }
    return workouts
  }

  func getLifts() -> [JLift] {
    return getWorkouts().map { $0.lifts }.reduce([], +)
  }

  func addWorkout(_ workout: JWorkout) {
    if workouts.contains(where: { $0 === workout }) {
      return
    } else {
      workouts.append(workout)
      write()
    }
  }

  func removeWorkout(_ workout: JWorkout) {
    if let index = workouts.firstIndex(where: { $0 === workout }) {
      workouts.remove(at: index)
    } else {
      fatalError("There was no workout for \(workout)")
    }
  }
}
