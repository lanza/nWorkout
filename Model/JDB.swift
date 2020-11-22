import Foundation

class JDB: ObservableObject {
  static let shared = JDB()
  func write() {
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

  func getFilePath() -> URL {
    #if true
      return getDocumentsDirectory().appendingPathComponent("data.json")
    #else
      return Bundle.main.bundleURL.appendingPathComponent("data.json")
    #endif
  }

  @Published var workouts: [NewWorkout]? = nil

  func setAllWorkouts(with workouts: [NewWorkout]) {
    JDB.shared.workouts = workouts
  }

  func getWorkouts() -> [NewWorkout] {
    if workouts == nil {
      do {
        let d = try Data(contentsOf: getFilePath())
        workouts = try JSONDecoder().decode([NewWorkout].self, from: d)
        for workout in workouts! {
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
    return workouts!
  }

  func getLifts() -> [NewLift] {
    return getWorkouts().map { $0.lifts }.reduce([], +)
  }

  func addWorkout(_ workout: NewWorkout) {
    guard let wos = workouts else { fatalError("addWorkout") }
    if wos.contains(where: { $0 === workout }) {
      return
    } else {
      workouts!.append(workout)
      write()
    }
  }

  func removeWorkout(_ workout: NewWorkout) {
    guard let wos = workouts else { fatalError("addWorkout") }
    if let index = wos.firstIndex(where: { $0 === workout }) {
      workouts!.remove(at: index)
    } else {
      fatalError("There was no workout for \(workout)")
    }
  }
}
