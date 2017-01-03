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
    override func viewControllerDidLoad() {
        super.viewControllerDidLoad()

        selectWorkoutVC.tableView.rx.modelSelected(Workout.self).subscribe(onNext: { routine in
            let awc = self.didSelectRoutine(routine)
            self.show(awc, sender: self)
        }).addDisposableTo(db)
        selectWorkoutVC.blankWorkoutButton.rx.tap.subscribe(onNext: {
            let awc = self.didSelectRoutine(Workout())
            self.show(awc, sender: self)
        }).addDisposableTo(db)
        
    }
    
    var didSelectRoutine: ((Workout?) -> (ActiveWorkoutCoordinator))!
    let db = DisposeBag()
}

extension SelectWorkoutCoordinator: SelectWorkoutDelegate {
    func cancelSelected(for selectWorkoutVC: SelectWorkoutVC) {
        navigationCoordinator?.parentCoordinator?.dismiss(animated: true)
    }
}

