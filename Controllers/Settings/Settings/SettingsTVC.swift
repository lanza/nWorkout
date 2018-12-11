import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Reuse

class SettingsTVC: UIViewController, UITableViewDelegate, CellSettingsCellDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    let tableView = UITableView()
    var viewInfos = ViewInfo.saved
    
  var dataSource: RxTableViewSectionedAnimatedDataSource<SettingsSectionsModel>! = nil
  
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
        tableView.register(CellSettingsCell.self)
        
        setupTableView()
    }
    
    var sections: [SettingsSectionsModel] = []
    
    func setupTableView() {
        
        tableView.separatorStyle = .none
        
      dataSource = RxTableViewSectionedAnimatedDataSource<SettingsSectionsModel>(configureCell: { [unowned self] ds, tv, ip, item in
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
      })
        dataSource.titleForHeaderInSection = { ds, index in
            return index == 0 ? "" : "Cells"
        }
        dataSource.canMoveRowAtIndexPath = { _, info in
            switch info.section {
            case 0:
                return false
            default:
                return true
            }
        }
        dataSource.canEditRowAtIndexPath = { _, info in
            switch info.section {
            case 0:
                return false
            default:
                return true
            }
        }
        
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .automatic)
        
      Observable.just(sections).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: db)
        
        tableView.rx.itemMoved.subscribe(onNext: { event in
            guard event.destinationIndex.section == 1 else { return }
            
            var items = self.sections[1].items
            let moved = items.remove(at: event.sourceIndex.row)
            items.insert(moved, at: event.destinationIndex.row)
            self.sections[1] = SettingsSectionsModel(original: self.sections[1], items: items)
            
            let viewInfo = self.viewInfos.remove(at: event.sourceIndex.row)
            self.viewInfos.insert(viewInfo, at: event.destinationIndex.row)
            
        }).disposed(by: db)
        
      tableView.rx.setDelegate(self).disposed(by: db)
        
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
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else { return nil }
        let view = SettingsSectionHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        return view
    }
    
    class SettingsSectionHeaderView: UIView {
        let cellTypeLabel: UILabel = {
            let l = UILabel()
            
            l.backgroundColor = .clear
            l.textColor = .white
            l.text = "Cell Type"
            l.font = UIFont.systemFont(ofSize: 13)
            l.translatesAutoresizingMaskIntoConstraints = false
            
            return l
        }()
        let widthLabel: UILabel = {
            let l = UILabel()
            
            l.backgroundColor = .clear
            l.textColor = .white
            l.text = "Width"
            l.font = UIFont.systemFont(ofSize: 13)
            l.translatesAutoresizingMaskIntoConstraints = false
            l.textAlignment = .right
            
            return l
        }()
        let isOnLabel: UILabel = {
            let l = UILabel()
            
            l.backgroundColor = .clear
            l.textColor = .white
            l.text = "Enabled"
            l.font = UIFont.systemFont(ofSize: 13)
            l.translatesAutoresizingMaskIntoConstraints = false
            
            return l
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(cellTypeLabel)
            addSubview(widthLabel)
            addSubview(isOnLabel)
            
          widthLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 5), for: .horizontal)
            
            NSLayoutConstraint.activate([
                cellTypeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
                cellTypeLabel.rightAnchor.constraint(equalTo: widthLabel.leftAnchor),
                cellTypeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                widthLabel.rightAnchor.constraint(equalTo: isOnLabel.leftAnchor, constant: -13),
                widthLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                isOnLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                isOnLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40)
                ])
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.section == 0 {
            return IndexPath(row: 0, section: 1)
        } else {
            return proposedDestinationIndexPath
        }
    }
    
    func widthDidChange(to value: CGFloat, for cell: CellSettingsCell) {
        let indexPath = tableView.indexPath(for: cell)!
        if indexPath.section == 0 {
            //
        } else if indexPath.section == 1 {
            viewInfos[indexPath.row].width = value
        }
        
    }
    func switchDidChange(to bool: Bool, for cell: CellSettingsCell) {
        let indexPath = tableView.indexPath(for: cell)!
        if indexPath.section == 0 {
            ViewInfo.setUsesCombinedView(bool)
            
            viewInfos = ViewInfo.saved
            let items = viewInfos.map { $0.name }
            sections[1] = SettingsSectionsModel(original: sections[1], items: items)
            dataSource.setSections(sections)
            
            
            tableView.reloadSections([1], with: .automatic)
            
        } else if indexPath.section == 1 {
            viewInfos[indexPath.row].isOn = !viewInfos[indexPath.row].isOn
        }
    }
    
    func broadcastSettingsDidChange() {
        let notification = Notification(name: Notification.Name("settingsDidChange"))
        NotificationCenter.default.post(notification)
    }
}



















