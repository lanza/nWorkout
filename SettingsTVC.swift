import UIKit
import RxCocoa
import RxSwift
import RxDataSources

enum SettingsSectionsModel {
    case top
    case cells(items: [String])
}
extension SettingsSectionsModel: SectionModelType {
    typealias Item = String
    var items: [String] {
        switch self {
        case .top:
            return ["Hide completed reps and weight until the fail button was tapped?"]
        case .cells(items: let strings):
            return strings
        }
    }
    init(original: SettingsSectionsModel, items: [String]) {
        switch original {
        case .top:
            self = .top
        case .cells(let strings):
            self = .cells(items: strings)
        }
    }
}

class SettingsTVC: UIViewController, UITableViewDelegate {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    let viewInfos$ = Variable<[ViewInfo]>([])
    
    let dataSource = RxTableViewSectionedReloadDataSource<SettingsSectionsModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.Colors.darkest
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: UIApplication.shared.windows[0].frame.width, height: 20))
        v.backgroundColor = Theme.Colors.darkest
        view.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: view.topAnchor),
            v.leftAnchor.constraint(equalTo: view.leftAnchor),
            v.rightAnchor.constraint(equalTo: view.rightAnchor),
            v.heightAnchor.constraint(equalToConstant: 20),
            
            tableView.topAnchor.constraint(equalTo: v.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        tableView.tableFooterView = UIView()
        
        setTableHeaderView()
        
        viewInfos$.value = ViewInfo.saved
        setupTableView()
        tableView.setEditing(true, animated: false)
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self)
        let sections: [SettingsSectionsModel] = [.top, .cells(items: ["hi"])]
        Observable.just(sections).bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(db)
        tableView.rx.setDelegate(self).addDisposableTo(db)
        
        dataSource.configureCell = { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(for: ip)
            cell.textLabel?.text = item
            return cell
        }
        dataSource.titleForHeaderInSection = { ds, index in
            return index == 0 ? "Settings" : "Cells"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let ci = tableView.contentInset
        tableView.contentInset = UIEdgeInsets(top: ci.top, left: ci.left, bottom: 49, right: ci.right)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserDefaults.standard.set(viewInfos$.value.map { $0.array }, forKey: Lets.viewInfoKey)
    }
    
    func setTableHeaderView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        tableView.tableHeaderView = view
    }

    
    //
    //    func setupRx() {
    
    //        hideCompletionUntilFailTappedSwitch.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] in
    //
    //            ViewInfo.setUsesCombinedView(self.hideCompletionUntilFailTappedSwitch.isOn)
    //
    //            if self.hideCompletionUntilFailTappedSwitch.isOn {
    //
    //                let cwIndex = self.viewInfos$.value.index { $0.name == Lets.completedWeightKey }!
    //                self.viewInfos$.value[cwIndex].name = Lets.doneButtonCompletedWeightCompletedRepsKey
    //                let crIndex = self.viewInfos$.value.index { $0.name == Lets.completedRepsKey }!
    //                self.viewInfos$.value.remove(at: crIndex)
    //                let dbIndex = self.viewInfos$.value.index { $0.name == Lets.doneButtonKey }!
    //                self.viewInfos$.value.remove(at: dbIndex)
    //
    //            } else {
    //
    //                let value = self.viewInfos$.value
    //                let cIndex = value.index { $0.name == Lets.doneButtonCompletedWeightCompletedRepsKey }!
    //
    //                self.viewInfos$.value[cIndex].name = Lets.completedWeightKey
    //                self.viewInfos$.value.append(contentsOf: [ViewInfo(name: Lets.completedRepsKey, width: 20, isOn: true), ViewInfo(name: Lets.doneButtonKey, width: 20, isOn: true)])
    //            }
    //        }).addDisposableTo(db)
    
    //        viewInfos$.asObservable().bindTo(tableView.rx.items(cellIdentifier: "cell", cellType: SettingsCell.self)) { index, viewInfo, cell in
    //            cell.db = DisposeBag()
    //            cell.nameLabel.text = viewInfo.name
    //            cell.widthTextField.text = viewInfo.width.remainder(dividingBy: 1) == 0 ? String(describing: Int(viewInfo.width)) : String(describing: viewInfo.width)
    //            cell.widthTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [unowned self] in
    //                self.viewInfos$.value[index].width = CGFloat(Double(cell.widthTextField.text ?? "20")!)
    //            }).addDisposableTo(cell.db)
    //
    //
    //            cell.isOnSwitch.isOn = viewInfo.isOn
    //            cell.isOnSwitch.rx.controlEvent(.valueChanged).subscribe(onNext: { [unowned self] in
    //                self.viewInfos$.value[index].isOn = cell.isOnSwitch.isOn
    //            }).addDisposableTo(cell.db)
    //
    //        }.addDisposableTo(db)
    //
    //        tableView.rx.itemMoved.subscribe(onNext: { itemMovedEvent in
    //            let item = self.viewInfos$.value.remove(at: itemMovedEvent.sourceIndex.row)
    //            self.viewInfos$.value.insert(item, at: itemMovedEvent.destinationIndex.row)
    //        }).addDisposableTo(db)
    //
    //        tableView.rx.setDelegate(self).addDisposableTo(db)
    //    }
    
    
    let db = DisposeBag()

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



















