import UIKit
import RxSwift
import RxCocoa

protocol WorkoutFooterViewDelegate: class {
    func addLiftTapped()
    func cancelWorkoutTapped()
    func finishWorkoutTapped()
    func workoutDetailTapped()
}

class WorkoutFooterView: UIView {
    
    weak var delegate: WorkoutFooterViewDelegate!
    
    var activeOrFinished: ActiveOrFinished!
    
    let addLiftButton = WorkoutFooterViewButton.create(title: Lets.addLift, type: .addLift)
    var cancelWorkoutButton: WorkoutFooterViewButton!
    var finishWorkoutButton: WorkoutFooterViewButton!
    var workoutDetailButton = WorkoutFooterViewButton.create(title: Lets.viewWorkoutDetails, type: .details)
    
    let stackView = UIStackView(axis: .vertical, spacing: 4, distribution: .fillEqually)
    
    static func create(_ activeOrFinished: ActiveOrFinished) -> WorkoutFooterView {
        let view = WorkoutFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: activeOrFinished == .active ? (28*4+8*3) : 70  ))
        view.activeOrFinished = activeOrFinished
        
        view.addSubview(view.stackView)
        view.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        var buttons: [WorkoutFooterViewButton] = [view.addLiftButton]
        if view.activeOrFinished == .active {
            view.cancelWorkoutButton = WorkoutFooterViewButton.create(title: Lets.cancelWorkout, type: .cancel)
            view.finishWorkoutButton = WorkoutFooterViewButton.create(title: Lets.finishWorkout, type: .finish)
            buttons.append(contentsOf: [view.cancelWorkoutButton, view.finishWorkoutButton])
        }
        
        buttons.append(view.workoutDetailButton)
        
        for button in buttons {
            view.addSubview(button)
            view.stackView.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            view.stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            view.stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            view.stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            view.stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
        
        view.setupRx()
        return view
    }
    
    func setupRx() {
        addLiftButton.rx.tap.subscribe(onNext: {
            self.delegate.addLiftTapped()
        }).addDisposableTo(db)
        finishWorkoutButton?.rx.tap.subscribe(onNext: {
            self.delegate.finishWorkoutTapped()
        }).addDisposableTo(db)
        cancelWorkoutButton?.rx.tap.subscribe(onNext: {
            self.delegate.cancelWorkoutTapped()
        }).addDisposableTo(db)
        workoutDetailButton.rx.tap.subscribe(onNext: {
            self.delegate.workoutDetailTapped()
        }).addDisposableTo(db)
    }
    let db = DisposeBag()
}





