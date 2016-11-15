import UIKit
import CoordinatorKit

class RoutineCoordinator: Coordinator {
    var routineTVC: RoutineTVC { return viewController as! RoutineTVC }
    var routine: Workout!
    
    override func loadViewController() {
        viewController = RoutineTVC.new()
        routineTVC.routine = routine
    }
}
