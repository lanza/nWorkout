import UIKit
import RxCocoa
import RxSwift

extension SettingsTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "SettingsTVC" }
}

struct ViewInfo: Equatable {
    static func ==(lhs: ViewInfo, rhs: ViewInfo) {
        return lhs.name == rhs.name
    }
    var name: String
    var width: CGFloat
    var isOn: Bool
    
    static func from(array: [Any]) -> ViewInfo {
        return ViewInfo(name: array[0] as! String, width: array[1] as! CGFloat, isOn: array[2] as! Bool)
    }
    var array: [Any] {
        return [name,width,isOn]
    }
    
    static var all: [ViewInfo] {
        return [
            ViewInfo(name: Lets.setNumberKey, width: 10, isOn: true),
            ViewInfo(name: Lets.previousWorkoutKey, width: 25, isOn: true),
            ViewInfo(name: Lets.targetWeightKey, width: 20, isOn: true),
            ViewInfo(name: Lets.targetRepsKey, width: 20, isOn: true),
            ViewInfo(name: Lets.completedWeightKey, width: 20, isOn: true),
            ViewInfo(name: Lets.completedRepsKey, width: 20, isOn: true),
            ViewInfo(name: Lets.doneButtonKey, width: 20, isOn: true),
            ViewInfo(name: Lets.failButtonKey, width: 20, isOn: true)
        ]
    }
}

class SettingsTVC: UIViewController {
    @IBOutlet weak var hideCompletionUntilFailTappedSwitch: UISwitch!
    
    @IBOutlet weak var tableView: UITableView!

    var viewInfos$ = Variable((UserDefaults.standard.value(forKey: Lets.viewInfoKey) as? [[Any]]).map { $0.map { ViewInfo.from(array: $0) } } ?? ViewInfo.all)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setupRx()
        tableView.setEditing(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserDefaults.standard.set(viewInfos$.value.map { $0.array }, forKey: Lets.viewInfoKey)
    }
    
    func setupRx() {
        
        hideCompletionUntilFailTappedSwitch.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] in
            UserDefaults.standard.set(self.hideCompletionUntilFailTappedSwitch.isOn, forKey: Lets.combineFailAndCompletedWeightAndRepsKey)
            if self.hideCompletionUntilFailTappedSwitch.isOn {
            }})
            
//                let cwIndex = self.viewInfos$.value.
//                self.workoutCells$.value[cwIndex] = Lets.doneButtonCompletedWeightCompletedRepsKey
//                let crIndex = self.workoutCells$.value.index(of: Lets.completedRepsKey)!
//                self.workoutCells$.value.remove(at: crIndex)
//                let dbIndex = self.workoutCells$.value.index(of: Lets.doneButtonKey)!
//                self.workoutCells$.value.remove(at: dbIndex)
//                
//            } else {
//                
//                let cIndex = self.workoutCells$.value.index(of: Lets.doneButtonCompletedWeightCompletedRepsKey)!
//                self.workoutCells$.value[cIndex] = Lets.completedWeightKey
//                self.workoutCells$.value.append(contentsOf: [Lets.completedRepsKey,Lets.doneButtonKey])
//            }
//        }).addDisposableTo(db)
//        
//        workoutCells$.asObservable().bindTo(tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { index, string, cell in
//            cell.textLabel?.text = string
//            let swtch = UISwitch()
//            swtch.rx.value.subscribe(onNext: { value in
//                self.
//            }).addDisposableTo(db)
//            cell.accessoryView =
//        }.addDisposableTo(db)
//       
//        tableView.rx.itemMoved.subscribe(onNext: { itemMovedEvent in
//            let item = self.workoutCells$.value.remove(at: itemMovedEvent.sourceIndex.row)
//            self.workoutCells$.value.insert(item, at: itemMovedEvent.destinationIndex.row)
//        }).addDisposableTo(db)
        
//        tableView.rx.setDelegate(self).addDisposableTo(db)
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



















