import UIKit
import RxSwift
import RxCocoa

class WorkoutDetailVC: UIViewController {
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    let workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupWorkout()
    }
    
    func setupWorkout() {
        let df = DateFormatter()
        startDateLabel.text = df.string(from: workout.startDate)
        if let finish = workout.finishDate {
            finishDateLabel.text = df.string(from: finish)
        }
    }
    
    
    let stackView = UIStackView(axis: .vertical, spacing: 8, distribution: .fillEqually)
    let startDateLabel = UILabel()
    let finishDateLabel = UILabel()
    
    let thingie = UIDatePicker()
    
    func setupViews() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(startDateLabel)
        stackView.addArrangedSubview(finishDateLabel)
        stackView.addArrangedSubview(thingie)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -80)
            ])
    }
    
}


