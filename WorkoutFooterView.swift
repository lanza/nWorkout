import UIKit

class WorkoutFooterView: UIView {
    
    var activeOrFinished: ActiveOrFinished!
    
    let addLiftButton = WorkoutFooterViewButton.create(title: Lets.addLift, type: .addLift)
    var cancelWorkoutButton: WorkoutFooterViewButton!
    var finishWorkoutButton: WorkoutFooterViewButton!
    
    let stackView = UIStackView(axis: .vertical, spacing: 4, distribution: .fillEqually)
    
    static func create(_ activeOrFinished: ActiveOrFinished) -> WorkoutFooterView {
        let view = WorkoutFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: activeOrFinished == .active ? 132 : 40))
        view.activeOrFinished = activeOrFinished
        
        view.addSubview(view.stackView)
        view.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        var buttons: [WorkoutFooterViewButton] = [view.addLiftButton]
        if view.activeOrFinished == .active {
            view.cancelWorkoutButton = WorkoutFooterViewButton.create(title: Lets.cancelWorkout, type: .cancel)
            view.finishWorkoutButton = WorkoutFooterViewButton.create(title: Lets.finishWorkout, type: .finish)
            buttons.append(contentsOf: [view.cancelWorkoutButton, view.finishWorkoutButton])
        }
        
        for button in buttons {
            view.addSubview(button)
            view.stackView.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            view.stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            view.stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            view.stackView.topAnchor.constraint(equalTo: view.topAnchor),
            view.stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
}





