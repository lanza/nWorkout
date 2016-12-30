import UIKit

class WorkoutFooterView: UIView {
    
    let addLiftButton = TableFooterViewButton.create(title: "Add Lift")
    let cancelWorkoutButton = TableFooterViewButton.create(title: "Cancel Workout")
    let finishWorkoutButton = TableFooterViewButton.create(title: "Finish Workout")
    
    let stackView = UIStackView(axis: .vertical, spacing: 10, distribution: .fillEqually)
    
    static func create() -> WorkoutFooterView {
        let view = WorkoutFooterView(frame: CGRect(x: 0, y: 0, width: 0, height: 200))
        
        view.addSubview(view.stackView)
        view.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let buttons = [view.addLiftButton, view.cancelWorkoutButton, view.finishWorkoutButton]
        
        for button in buttons {
            view.addSubview(button)
            view.stackView.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            view.stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            view.stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            view.stackView.topAnchor.constraint(equalTo: view.topAnchor),
            view.stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
}

class TableFooterViewButton: UIButton {
    static func create(title: String) -> TableFooterViewButton {
        let b = TableFooterViewButton()
        b.setTitleColor(.black)
        b.setTitle(title)
        
        b.layer.borderColor = .blue
        b.layer.borderWidth = 5
        b.layer.cornerRadius = 5
        
        return b
    }
}


extension CGColor {
    static var blue: CGColor {
        return UIColor.blue.cgColor
    }
    static var white: CGColor {
        return UIColor.white.cgColor
    }
}
