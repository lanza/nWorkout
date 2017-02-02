import UIKit
import RxSwift
import RxCocoa
import Eureka

class WorkoutDetailVC: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.titleLabel?.textColor = .white
            cell.textField.textColor = .white
            cell.backgroundColor = Theme.Colors.dark
        }
        TextRow.defaultOnCellHighlightChanged = { cell, row in
            if row.isHighlighted {
                cell.titleLabel?.textColor = Theme.Colors.main
            } else {
                cell.titleLabel?.textColor = .white
            }
        }
        
        DateTimeRow.defaultCellUpdate = { cell, row in
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = .white
            cell.backgroundColor = Theme.Colors.dark
        }
        DateTimeRow.defaultOnCellHighlightChanged = { cell, row in
            if row.isHighlighted {
                cell.textLabel?.textColor = Theme.Colors.main
            } else {
                cell.textLabel?.textColor = .white
            }
        }
        
        TextAreaRow.defaultCellUpdate = { cell, row in
            cell.backgroundColor = Theme.Colors.darker
            cell.textView.backgroundColor = Theme.Colors.dark
            
            cell.textView.textColor = .white
        }
        
        
        form +++ Section("Details")
            <<< TextRow() {
                $0.title = "Workout Name"
                $0.tag = "name"
                $0.value = workout.name
                }.onChange {
                    self.newName = $0.value ?? "none"
            }
            <<< DateTimeRow() {
                $0.title = "Start Time"
                $0.tag = "start"
                $0.value = workout.startDate
                }.onChange {
                    guard let new = $0.value else { fatalError() }
                    self.newStartDate = new
            }
            <<< DateTimeRow() {
                $0.title = "End Time"
                $0.value = workout.finishDate
                }.onChange {
                    guard let new = $0.value else { fatalError() }
                    self.newFinishDate = new
            }
            +++ Section("Note")
            <<< TextAreaRow() {
                $0.value = workout.note
                }.onChange {
                    self.newNote = $0.value ?? ""
        }
        
    }
    
    var newName: String?
    var newStartDate: Date?
    var newFinishDate: Date?
    var newNote: String?
    
    let workout: Workout
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        RLM.write {
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
    }
    
    init(workout: Workout) {
        self.workout = workout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}

class WorkoutDetailVC2: UIViewController {
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    let workout: Workout
    
    init(workout: Workout) {
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
    
    
    let stackView = UIStackView(axis: .vertical, spacing: 8, distribution: .fillEqually)
    let startDateLabel = UITextField()
    let finishDateLabel = UITextField()
    
    let startDatePicker = UIDatePicker()
    let finishDatePicker = UIDatePicker()
    
    func setupViews() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(startDateLabel)
        startDateLabel.inputView = startDatePicker
        stackView.addArrangedSubview(finishDateLabel)
        finishDateLabel.inputView = finishDatePicker
        
        startDatePicker.rx.controlEvent(.valueChanged).subscribe(onNext: {
            print("hi")
            RLM.write {
                self.workout.startDate = self.startDatePicker.date
            }
            
            self.startDateLabel.text = self.df.string(from: self.startDatePicker.date)
        }).addDisposableTo(db)
        
        finishDatePicker.rx.controlEvent(.valueChanged).subscribe(onNext: {
            RLM.write {
                self.workout.finishDate = self.finishDatePicker.date
            }
            self.finishDateLabel.text = self.df.string(from: self.finishDatePicker.date)
        }).addDisposableTo(db)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -80)
            ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        startDateLabel.resignFirstResponder()
        finishDateLabel.resignFirstResponder()
        super.viewWillDisappear(animated)
    }
    let db = DisposeBag()
}


