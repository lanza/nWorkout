import RxCocoa
import RxSwift
import UIKit

class WorkoutsTVC: BaseWorkoutsTVC<WorkoutCell> {
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    shareAction(url: JDB.getFilePath())
  }
  
  let documentInteractionController = UIDocumentInteractionController()
  func share(url: URL) {
    documentInteractionController.url = url
    documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
    documentInteractionController.name = url.localizedName ?? url.lastPathComponent
    documentInteractionController.presentOptionsMenu(from: view.frame, in: view, animated: true)
  }
  func shareAction(url: URL) {
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data, error == nil else { return }
      let tmpURL = FileManager.default.temporaryDirectory
        .appendingPathComponent(response?.suggestedFilename ?? "fileName.json")
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

  func setTableHeaderView() {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
    let label = UILabel()
    label.text = "History"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 28)

    view.addSubview(label)

    label.translatesAutoresizingMaskIntoConstraints = false

    label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive =
      true
    label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    tableView.tableHeaderView = view
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)

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
    tableView.tableFooterView = UIView()

    setTableHeaderView()

    navigationItem.leftBarButtonItem = editButtonItem
  }

  //mark: - Swift is so fucking stupid
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let workout = workouts[indexPath.row]
    delegate!.workoutsTVC(self, didSelectWorkout: workout)
  }
}
