import UIKit
import CoordinatorKit

class RoutinesCoordinator: Coordinator {
    
    var routinesTVC: RoutinesTVC { return viewController as! RoutinesTVC }
    
    override func loadViewController() {
        viewController = RoutinesTVC()
        
        routinesTVC.didSelectRoutine = { routine in
            let rvc = RoutineCoordinator()
            rvc.routine = routine
            self.show(rvc, sender: self)
        }
    }
}
