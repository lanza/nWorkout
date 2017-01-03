import UIKit
import CoordinatorKit
import RxSwift
import RxCocoa

class SelectWorkoutCoordinator: Coordinator {
    
    var selectWorkoutVC: SelectWorkoutVC { return viewController as! SelectWorkoutVC }
    
    override func loadViewController() {
        viewController = SelectWorkoutVC()
        selectWorkoutVC.delegate = self
    }
    
    var didSelectRoutine: ((Workout?) -> (ActiveWorkoutCoordinator))!
    let db = DisposeBag()
}

extension SelectWorkoutCoordinator: SelectWorkoutDelegate {
    func cancelSelected(for selectWorkoutVC: SelectWorkoutVC) {
        navigationCoordinator?.parentCoordinator?.dismiss(animated: true)
    }
    func startBlankWorkoutSelected(for selectWorkoutVC: SelectWorkoutVC) {
        let awc = self.didSelectRoutine(Workout())
        self.show(awc, sender: self)
    }
    
    func selectWorkoutVC(_ selectWorkoutVC: SelectWorkoutVC, selectedRoutine routine: Workout) {
        let awc = self.didSelectRoutine(routine)
        self.show(awc, sender: self)
    }
}

