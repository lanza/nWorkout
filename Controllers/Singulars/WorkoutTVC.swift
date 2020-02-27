import RxCocoa
import RxSwift
import UIKit

protocol WorkoutTVCDelegate: class {
  func hideTapped(for workoutTVC: WorkoutTVC)
  func showWorkoutDetailTapped(for workoutTVC: WorkoutTVC)

  func workoutCancelled(for workoutTVC: WorkoutTVC)
  func workoutFinished(for workoutTVC: WorkoutTVC)
}

class WorkoutTVC: BaseWorkoutTVC<WorkoutLiftCell> {

  weak var delegate: WorkoutTVCDelegate!

  var activeOrFinished: ActiveOrFinished { return workout.activeOrFinished }

  override func setDataSource() {
    dataSource = WorkoutDataSource(
      tableView: tableView,
      provider: workout,
      activeOrFinished: activeOrFinished
    )
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = Lets.workoutStartTimeDF.string(from: workout.startDate)

    if activeOrFinished == .active {
      navigationItem.leftBarButtonItem = UIBarButtonItem(
        title: Lets.hide,
        style: .plain,
        target: nil,
        action: nil
      )
      navigationItem.leftBarButtonItem!.rx.tap.subscribe(
        onNext: {
          self.delegate.hideTapped(for: self)
        }
      ).disposed(by: db)
    }
  }

  override func cancelWorkoutTapped() {
    let a = UIAlertController.confirmAction(
      title: "Cancel Workout?",
      message: "Are you sure you want to cancel this workout?"
    ) { _ in
      self.delegate.workoutCancelled(for: self)
    }
    present(a, animated: true)
  }

  override func finishWorkoutTapped() {
    let a = UIAlertController.confirmAction(
      title: "Finish Workout?",
      message: "Are you sure you want to finish this workout?"
    ) { _ in
      self.delegate.workoutFinished(for: self)
    }
    present(a, animated: true)
  }

  override func workoutDetailTapped() {
    delegate.showWorkoutDetailTapped(for: self)
  }
}

class NoteView<Type: Base, View: UIView>: UIView {
  var view: View!
  var type: Type!

  static func new(for type: Type, view: View) -> NoteView {
    let n = NoteView(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
    n.type = type
    n.view = view
    n.textView.text = n.type.note
    n.setupViews()
    return n
  }

  let textView = UITextView()

  func setupViews() {
    textView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(textView)

    NSLayoutConstraint.activate(
      [
        textView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4),
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
      ]
    )
  }
}
