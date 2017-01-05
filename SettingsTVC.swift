import UIKit
import RxCocoa
import RxSwift

extension SettingsTVC: ViewControllerFromStoryboard {
}

class SettingsTVC: UIViewController {
    @IBOutlet weak var hideCompletionUntilFailTappedSwitch: UISwitch!
    
    @IBOutlet weak var tableView: UITableView!

    var viewInfos$ = Variable<[ViewInfo]>([])    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewInfos$.value = ViewInfo.saved
        hideCompletionUntilFailTappedSwitch.isOn = ViewInfo.usesCombinedView

        setupRx()

        tableView.setEditing(true, animated: false)
        tableView.isScrollEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserDefaults.standard.set(viewInfos$.value.map { $0.array }, forKey: Lets.viewInfoKey)
    }
    
    func setupRx() {
        
        hideCompletionUntilFailTappedSwitch.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] in
            
            ViewInfo.setUsesCombinedView(self.hideCompletionUntilFailTappedSwitch.isOn)
            
            if self.hideCompletionUntilFailTappedSwitch.isOn {
            
                let cwIndex = self.viewInfos$.value.index { $0.name == Lets.completedWeightKey }!
                self.viewInfos$.value[cwIndex].name = Lets.doneButtonCompletedWeightCompletedRepsKey
                let crIndex = self.viewInfos$.value.index { $0.name == Lets.completedRepsKey }!
                self.viewInfos$.value.remove(at: crIndex)
                let dbIndex = self.viewInfos$.value.index { $0.name == Lets.doneButtonKey }!
                self.viewInfos$.value.remove(at: dbIndex)
                
            } else {
                
                let value = self.viewInfos$.value
                let cIndex = value.index { $0.name == Lets.doneButtonCompletedWeightCompletedRepsKey }!
            
                self.viewInfos$.value[cIndex].name = Lets.completedWeightKey
                self.viewInfos$.value.append(contentsOf: [ViewInfo(name: Lets.completedRepsKey, width: 20, isOn: true), ViewInfo(name: Lets.doneButtonKey, width: 20, isOn: true)])
            }
        }).addDisposableTo(db)
        
        viewInfos$.asObservable().bindTo(tableView.rx.items(cellIdentifier: "cell", cellType: SettingsCell.self)) { index, viewInfo, cell in
            cell.db = DisposeBag()
            cell.nameLabel.text = viewInfo.name
            cell.widthTextField.text = viewInfo.width.remainder(dividingBy: 1) == 0 ? String(describing: Int(viewInfo.width)) : String(describing: viewInfo.width)
            cell.widthTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [unowned self] in
                self.viewInfos$.value[index].width = CGFloat(Double(cell.widthTextField.text ?? "20")!)
            }).addDisposableTo(cell.db)

            
            cell.isOnSwitch.isOn = viewInfo.isOn
            cell.isOnSwitch.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] in
                self.viewInfos$.value[index].isOn = cell.isOnSwitch.isOn
            }).addDisposableTo(cell.db)
            
        }.addDisposableTo(db)
    
        tableView.rx.itemMoved.subscribe(onNext: { itemMovedEvent in
            let item = self.viewInfos$.value.remove(at: itemMovedEvent.sourceIndex.row)
            self.viewInfos$.value.insert(item, at: itemMovedEvent.destinationIndex.row)
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
        return 42
    }
}



















