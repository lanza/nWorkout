import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import DZNEmptyDataSet

protocol SelectWorkoutDelegate: class {
    func cancelSelected(for selectWorkoutVC: SelectWorkoutVC)
    func startBlankWorkoutSelected(for selectWorkoutVC: SelectWorkoutVC)
    func selectWorkoutVC(_ selectWorkoutVC: SelectWorkoutVC, selectedRoutine routine: Workout)
}

class SelectWorkoutVC: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    weak var delegate: SelectWorkoutDelegate!
    
    var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var startBlankWorkoutButton = StartBlankWorkoutButton.create()
    
    override func loadView() {
        automaticallyAdjustsScrollViewInsets = false
        view = UIView(frame: AppDelegate.main.window!.frame)
        view.backgroundColor = .white
    }
    
    func setupView() {
        view.addSubview(tableView)
        view.addSubview(startBlankWorkoutButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        startBlankWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startBlankWorkoutButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            startBlankWorkoutButton.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            startBlankWorkoutButton.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            tableView.topAnchor.constraint(equalTo: startBlankWorkoutButton.bottomAnchor, constant: 8),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func setupTableView() {
        tableView.isScrollEnabled = false
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        let realm = try! Realm()
        let objects = Array(realm.objects(Workout.self).filter("isWorkout = false"))
        
        tableView.register(SelectWorkoutCell.self)
        
        Observable.just(objects).bindTo(tableView.rx.items(cellIdentifier: SelectWorkoutCell.reuseIdentifier, cellType: SelectWorkoutCell.self)) { index, workout, cell in
            cell.configure(for: workout, at: IndexPath(row: index, section: 0))
            }.addDisposableTo(db)
        
        tableView.rx.modelSelected(Workout.self).subscribe(onNext: { routine in
            self.delegate.selectWorkoutVC(self, selectedRoutine: routine)
        }).addDisposableTo(db)
        
//        tableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        
        startBlankWorkoutButton.rx.tap.subscribe(onNext: {
            self.delegate.startBlankWorkoutSelected(for: self)
        }).addDisposableTo(db)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Lets.cancel, style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem!.rx.tap.subscribe(onNext: {
            self.delegate.cancelSelected(for: self)
        }).addDisposableTo(db)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    let db = DisposeBag()
    
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "workout")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Create a routine to be able to select a routine to format your workout.")
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "To add a routine, close this page and click the \"Routines\" tab.")
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
}
