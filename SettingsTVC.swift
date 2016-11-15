import UIKit
import RxCocoa
import RxSwift

extension SettingsTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "SettingsTVC" }
}

class SettingsTVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var workoutCells = ["Last Workout Weight","Last Workout Reps", "Failure Weight", "Failure Reps", "Break timer", "Note", "Status"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupRx()
    }
    
    func setupRx() {
        
        Observable.just(workoutCells).bindTo(tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { index, string, cell in
            cell.textLabel?.text = string
        }.addDisposableTo(db)
       
        tableView.rx.itemMoved.subscribe(onNext: { itemMovedEvent in
            let item = self.workoutCells.remove(at: itemMovedEvent.sourceIndex.row)
            self.workoutCells.insert(item, at: itemMovedEvent.destinationIndex.row)
        }).addDisposableTo(db)
    }

    let db = DisposeBag()
}
