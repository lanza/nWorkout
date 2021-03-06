import UIKit

class WorkoutsTVC: BaseWorkoutsTVC<WorkoutCell> {

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  #if !targetEnvironment(macCatalyst)
    let documentInteractionController = UIDocumentInteractionController()

    func share(url: URL) {
      documentInteractionController.url = url
      documentInteractionController.uti =
        url.typeIdentifier
        ?? "public.data, public.content"
      documentInteractionController.name =
        url.localizedName
        ?? url.lastPathComponent
      documentInteractionController.presentOptionsMenu(
        from: view.frame, in: view, animated: true)
    }

    func shareAction(url: URL) {
      URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else { return }
        let tmpURL = FileManager.default.temporaryDirectory
          .appendingPathComponent(
            response?.suggestedFilename ?? "fileName.json")
        do {
          try data.write(to: tmpURL)
          DispatchQueue.main.async {
            self.share(url: tmpURL)
          }
        } catch {
          fatalError(error.localizedDescription)
        }
      }.resume()
    }

    @objc func saveButtonTapped() {
      guard
        let result = try? coreDataStack.getContext().fetch(
          NWorkout.getFetchRequest())
      else { return }

      let jworkouts = result.map { $0.convertToJWorkout() }
      let sorted = jworkouts.sorted { (first, second) -> Bool in
        return first.startDate < second.startDate
      }
      JDB.shared.setAllWorkouts(with: sorted)
      JDB.shared.write()

      shareAction(url: JDB.shared.getFilePath())
    }
  #endif

  func reloadData() {
    // TODO: Implement this properly once I learn coredata
    guard
      let result = try? coreDataStack.getContext().fetch(
        NWorkout.getFetchRequest())
    else { return }
    workouts =
      result
      .filter { $0.isComplete }
      .sorted(by: { $0.startDate! > $1.startDate! })

    dataSource = WorkoutsDataSource(tableView: tableView, workouts: workouts)
    dataSource.name = Lets.workout
    dataSource.displayAlert = { alert in
      self.present(alert, animated: true, completion: nil)
    }

    tableView.reloadData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "History"
    #if !targetEnvironment(macCatalyst)
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        title: "Save Data", style: .plain, target: self,
        action: #selector(saveButtonTapped))
    #endif

    NotificationCenter.default.addObserver(
      self, selector: #selector(activeWorkoutDidFinish),
      name: Notification.activeWorkoutDidFinish, object: nil)
  }

  @objc func activeWorkoutDidFinish(object: Any) {
    reloadData()
  }

  var finishedWorkout: NWorkout?

  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let workout = workouts[indexPath.row]

    let workoutTVC = WorkoutTVC()
    workoutTVC.workout = workout

    navigationController?.pushViewController(workoutTVC, animated: true)
  }
}
