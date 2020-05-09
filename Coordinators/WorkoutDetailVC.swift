import UIKit

class WorkoutDetailVC: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    // This used to be Eureka
  }

  var newName: String?
  var newStartDate: Date?
  var newFinishDate: Date?
  var newNote: String?

  let workout: NewWorkout

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    if let name = newName {
      workout.name = name
    }
    if let start = newStartDate {
      workout.startDate = start
    }
    if let finish = newFinishDate {
      workout.finishDate = finish
    }
    if let note = newNote {
      workout.note = note
    }

  }

  init(workout: NewWorkout) {
    self.workout = workout
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) { fatalError() }
}

class WorkoutDetailVC2: UIViewController {
  required init?(coder aDecoder: NSCoder) { fatalError() }

  let workout: NewWorkout

  init(workout: NewWorkout) {
    self.workout = workout
    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Theme.Colors.darkest

    setupViews()
    setupDateTextFields()

    startDatePicker.date = workout.startDate
    if let finish = workout.finishDate {
      finishDatePicker.date = finish
    }
  }

  let df: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .long
    df.timeStyle = .long
    return df
  }()

  func setupDateTextFields() {
    startDateLabel.text = df.string(from: workout.startDate)
    if let finish = workout.finishDate {
      finishDateLabel.text = df.string(from: finish)
    }
  }

  let stackView = UIStackView(
    axis: .vertical,
    spacing: 8,
    distribution: .fillEqually
  )

  let startDateLabel = UITextField()
  let finishDateLabel = UITextField()

  let startDatePicker = UIDatePicker()
  let finishDatePicker = UIDatePicker()

  @objc func startDatePickerValueChanged() {
    self.workout.startDate = self.startDatePicker.date
    self.startDateLabel.text = self.df.string(
      from: self.startDatePicker.date
    )
  }

  @objc func finishDatePickerValueChanged() {
    self.workout.finishDate = self.finishDatePicker.date
    self.finishDateLabel.text = self.df.string(
      from: self.finishDatePicker.date
    )
  }

  func setupViews() {
    view.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false

    stackView.addArrangedSubview(startDateLabel)
    startDateLabel.inputView = startDatePicker
    stackView.addArrangedSubview(finishDateLabel)
    finishDateLabel.inputView = finishDatePicker

    startDatePicker.addTarget(
      self, action: #selector(startDatePickerValueChanged), for: .valueChanged)
    finishDatePicker.addTarget(
      self, action: #selector(finishDatePickerValueChanged), for: .valueChanged)

    NSLayoutConstraint.activate(
      [
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
        stackView.rightAnchor.constraint(
          equalTo: view.rightAnchor,
          constant: -30
        ),
        stackView.topAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.topAnchor,
          constant: 20
        ),
        stackView.bottomAnchor.constraint(
          equalTo: view.safeAreaLayoutGuide.bottomAnchor,
          constant: -80
        ),
      ]
    )
  }

  override func viewWillDisappear(_ animated: Bool) {
    startDateLabel.resignFirstResponder()
    finishDateLabel.resignFirstResponder()
    super.viewWillDisappear(animated)
  }
}
