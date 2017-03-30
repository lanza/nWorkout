import UIKit
import RxCocoa
import RxSwift
import DZNEmptyDataSet
import BonMot

class LiftTypeCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = Theme.Colors.Cell.contentBackground
//        contentView.setShadow(offsetWidth: 1, offsetHeight: 1, radius: 1, opacity: 0.7, color: .black)
        textLabel?.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
}


class LiftTypeTVC: BaseTVC {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Lets.hide, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Lets.newLift, style: .plain, target: nil, action: nil)
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    var liftTypes = Variable(UserDefaults.standard.value(forKey: Lets.liftTypesKey) as? [String] ?? [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Lift"
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        
        tableView.register(LiftTypeCell.self)
        setupRx()
    }
    
    func setupRx() {
        liftTypes.asObservable().bindTo(tableView.rx.items(cellIdentifier: LiftTypeCell.reuseIdentifier, cellType: LiftTypeCell.self)) { index, string, cell in
            cell.textLabel?.text = string
            }.addDisposableTo(db)
        
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {
            let alert = UIAlertController.alert(title: Lets.addNewLiftType, message: nil)
            
            let okay = UIAlertAction(title: Lets.done, style: .default) { _ in
                guard let name = alert.textFields?.first?.text else { fatalError() }
                self.liftTypes.value.append(name)
                self.save()
            }
            let cancel = UIAlertAction(title: Lets.cancel, style: .cancel, handler: nil)
            alert.addAction(okay)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }).addDisposableTo(db)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: { name in
            self.didSelectLiftName(name)
        }).addDisposableTo(db)
        
        tableView.rx.itemDeleted.subscribe(onNext: { indexPath in
            self.liftTypes.value.remove(at: indexPath.row)
            self.save()
        }).addDisposableTo(db)
    }
    
    func save() {
        UserDefaults.standard.setValue(self.liftTypes.value, forKey: Lets.liftTypesKey)
    }
    
    
    var didSelectLiftName: ((String) -> ())!
    let db = DisposeBag()
}


extension LiftTypeTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "workout")
    }
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .white
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let s = StringStyle(.color(.white))
        return "You have no exercise types, yet!".styled(with: s)
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let s = StringStyle(.color(.white))
        return "Click the + in the top right to add a new exercise type.".styled(with: s)
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
}
