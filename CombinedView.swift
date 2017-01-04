import UIKit

class CombinedView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .clear
        isOpaque = false
        
        completedWeightTextField.translatesAutoresizingMaskIntoConstraints = false
        completedRepsTextField.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(completedWeightTextField)
        addSubview(completedRepsTextField)
        addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            completedWeightTextField.leftAnchor.constraint(equalTo: leftAnchor),
            completedWeightTextField.topAnchor.constraint(equalTo: topAnchor),
            completedWeightTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            completedWeightTextField.rightAnchor.constraint(equalTo: completedRepsTextField.leftAnchor, constant: -1),
            completedRepsTextField.topAnchor.constraint(equalTo: topAnchor),
            completedRepsTextField.bottomAnchor.constraint(equalTo: bottomAnchor),
            completedRepsTextField.rightAnchor.constraint(equalTo: rightAnchor),
            completedWeightTextField.widthAnchor.constraint(equalTo: completedRepsTextField.widthAnchor),
            
            completeButton.leftAnchor.constraint(equalTo: leftAnchor),
            completeButton.topAnchor.constraint(equalTo: topAnchor),
            completeButton.rightAnchor.constraint(equalTo: rightAnchor),
            completeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            completeButton.widthAnchor.constraint(equalTo: widthAnchor)
            ])
        
        completedWeightTextField.setBorder(color: .gray, width: 0.8, radius: 0)
        completedRepsTextField.setBorder(color: .gray, width: 0.8, radius: 0)
    }
    
    let completedWeightTextField = CompletedWeightAndRepsTextField()
    let completedRepsTextField = CompletedWeightAndRepsTextField()
    let completeButton = CompleteButton()
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
