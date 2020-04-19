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
          print(error)
        }
      }.resume()
    }

  @objc func saveButtonTapped() {
    shareAction(url: JDB.getFilePath())
  }
  #endif

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    workouts = JDB.getWorkouts().filter { $0.isWorkout == true }
      .sorted(by: { $0.startDate > $1.startDate })

    dataSource = WorkoutsDataSource(tableView: tableView, workouts: workouts)
    dataSource.name = Lets.workout
    dataSource.displayAlert = { alert in
      self.present(alert, animated: true, completion: nil)
    }

  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "History"
#if !targetEnvironment(macCatalyst)
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Save Data", style: .plain, target: self,
      action: #selector(saveButtonTapped))
#endif
  }

  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let workout = workouts[indexPath.row]
    delegate!.workoutsTVC(self, didSelectWorkout: workout)
  }
}
