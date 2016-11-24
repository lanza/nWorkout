import UIKit
import RxCocoa
import RxSwift

extension SettingsTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "SettingsTVC" }
}

class SettingsTVC: UIViewController {
    @IBOutlet weak var hideCompletionUntilFailTappedSwitch: UISwitch!

    @IBOutlet weak var tableView: UITableView!
    var workoutCells$ = Variable(UserDefaults.standard.value(forKey: Lets.selectedColumnViewTypesKey) as? [String] ?? ["Last Workout Weight","Last Workout Reps", "Completion Weight", "Completione Reps", "Break timer", "Note", "Status"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupRx()
        tableView.setEditing(true, animated: false)
    }
    
    func setupRx() {
        
        hideCompletionUntilFailTappedSwitch.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] in
            UserDefaults.standard.set(self.hideCompletionUntilFailTappedSwitch.isOn, forKey: Lets.combineFailAndCompletedWeightAndRepsKey)
            if self.hideCompletionUntilFailTappedSwitch.isOn {
                
            }
        }).addDisposableTo(db)
        
        workoutCells$.asObservable().bindTo(tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { index, string, cell in
            cell.textLabel?.text = string
        }.addDisposableTo(db)
       
        tableView.rx.itemMoved.subscribe(onNext: { itemMovedEvent in
            let item = self.workoutCells$.value.remove(at: itemMovedEvent.sourceIndex.row)
            self.workoutCells$.value.insert(item, at: itemMovedEvent.destinationIndex.row)
        }).addDisposableTo(db)
        
        tableView.rx.setDelegate(self).addDisposableTo(db)
    }
    
    
    let db = DisposeBag()
}


extension SettingsTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
}



















