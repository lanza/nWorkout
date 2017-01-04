import UIKit
import RxCocoa
import RxSwift
import DZNEmptyDataSet



class LiftTypeTVC: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Hide", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Lift", style: .plain, target: nil, action: nil)
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    var liftTypes = Variable(UserDefaults.standard.value(forKey: "liftTypes") as? [String] ?? [])
    
    let tableView = UITableView()
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self)
        setupRx()
    }
    
    func setupRx() {
        liftTypes.asObservable().bindTo(tableView.rx.items(cellIdentifier: UITableViewCell.reuseIdentifier, cellType: UITableViewCell.self)) { index, string, cell in
            cell.textLabel?.text = string
            }.addDisposableTo(db)
        
        navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: {
            let alert = UIAlertController.alert(title: "Add new lift type", message: nil)
            
            let okay = UIAlertAction(title: "Okay", style: .default) { _ in
                guard let name = alert.textFields?.first?.text else { fatalError() }
                self.liftTypes.value.append(name)
                self.save()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
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
        UserDefaults.standard.setValue(self.liftTypes.value, forKey: "liftTypes")
    }
    
    
    var didSelectLiftName: ((String) -> ())!
    let db = DisposeBag()
}


extension LiftTypeTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "workout")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "You have no exercise types, yet!")
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Click the + in the top right to add a new exercise type.")
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
}
