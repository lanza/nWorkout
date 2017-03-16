import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Reuse

enum SettingsSectionsModel {
    case top
    case cells(items: [String])
}
extension SettingsSectionsModel: AnimatableSectionModelType {
    var identity: String {
        switch self {
        case .top: return "top"
        case .cells(items: _): return "cells"
        }
    }
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
        case .cells(_):
            self = .cells(items: items)
        }
    }
}

class SettingsTVC: UIViewController, UITableViewDelegate, CellSettingsCellDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    let tableView = UITableView()
    var viewInfos = ViewInfo.saved
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<SettingsSectionsModel>()
    
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
        
        sections = [.top, .cells(items: viewInfos.map { $0.name })]
        setupTableView()
    }
    
    var sections: [SettingsSectionsModel] = []
    
    func setupTableView() {
        tableView.register(CellSettingsCell.self)
        dataSource.configureCell = { [unowned self] ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(for: ip) as CellSettingsCell
            if ip.section == 1 {
                let vi = self.viewInfos[ip.row]
                cell.onSwitch.isOn = vi.isOn
                cell.widthTextField.text = "\(vi.width)"
            } else {
                cell.onSwitch.isOn = ViewInfo.usesCombinedView
            }
            cell.titleLabel.text = item
            cell.delegate = self
            
            return cell
        }
        dataSource.titleForHeaderInSection = { ds, index in
            return index == 0 ? "Settings" : "Cells"
        }
        dataSource.canMoveRowAtIndexPath = { info in
            return true
        }
        dataSource.canEditRowAtIndexPath = { _ in return true }
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .automatic)
        
        
        
        Observable.just(sections).bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(db)
        tableView.rx.itemMoved.subscribe(onNext: { event in
            
            var items = self.sections[1].items
            let moved = items.remove(at: event.sourceIndex.row)
            items.insert(moved, at: event.destinationIndex.row)
            self.sections[1] = SettingsSectionsModel(original: self.sections[1], items: items)
            
            let viewInfo = self.viewInfos.remove(at: event.sourceIndex.row)
            self.viewInfos.insert(viewInfo, at: event.destinationIndex.row)
            
        }).addDisposableTo(db)
        
        tableView.rx.setDelegate(self).addDisposableTo(db)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let ci = tableView.contentInset
        tableView.contentInset = UIEdgeInsets(top: ci.top, left: ci.left, bottom: 49, right: ci.right)
        
        setEditing(true, animated: true)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ViewInfo.saveViewInfos(viewInfos)
        broadcastSettingsDidChange()
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
    
    let db = DisposeBag()
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func widthDidChange(to value: CGFloat, for cell: CellSettingsCell) {
        let indexPath = tableView.indexPath(for: cell)!
        if indexPath.section == 0 {
            //
        } else if indexPath.section == 1 {
            viewInfos[indexPath.row].width = value
            broadcastSettingsDidChange()
        }
        
    }
    func switchDidChange(to bool: Bool, for cell: CellSettingsCell) {
        let indexPath = tableView.indexPath(for: cell)!
        if indexPath.section == 0 {
            ViewInfo.setUsesCombinedView(bool)
           
            viewInfos = ViewInfo.saved
            var items = viewInfos.map { $0.name }
            
            self.sections[1] = SettingsSectionsModel(original: self.sections[1], items: items)
            
            tableView.reloadSections([1], with: .automatic)
        } else if indexPath.section == 1 {
            viewInfos[indexPath.row].isOn = !viewInfos[indexPath.row].isOn
        }
        broadcastSettingsDidChange()
    }
    
    func broadcastSettingsDidChange() {
        let notification = Notification(name: Notification.Name("settingsDidChange"))
        NotificationCenter.default.post(notification)
    }
}



















