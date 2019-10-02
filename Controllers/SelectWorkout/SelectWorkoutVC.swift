import UIKit
import RxSwift
import RxCocoa
//import RealmSwift
import DZNEmptyDataSet
import BonMot

protocol SelectWorkoutDelegate: class {
    func cancelSelected(for selectWorkoutVC: SelectWorkoutVC)
    func startBlankWorkoutSelected(for selectWorkoutVC: SelectWorkoutVC)
    func selectWorkoutVC(_ selectWorkoutVC: SelectWorkoutVC, selectedRoutine routine: Workout)
}

class SelectWorkoutVC: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    weak var delegate: SelectWorkoutDelegate!
    
    var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var startBlankWorkoutButton = StartBlankWorkoutButton.create()
    
    override func loadView() {
        automaticallyAdjustsScrollViewInsets = false
        view = UIView(frame: AppDelegate.main.window!.frame)
        view.backgroundColor = Theme.Colors.darkest
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
    
    let objects = RLM.objects(type: Workout.self).filter("isWorkout = false")
    
    func setupTableView() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self

        tableView.register(SelectWorkoutCell.self)
        
        Observable.collection(from: objects).bind(to: tableView.rx.items(cellIdentifier: SelectWorkoutCell.reuseIdentifier, cellType: SelectWorkoutCell.self)) { index, workout, cell in
            cell.configure(for: workout, at: IndexPath(row: index, section: 0))
        }.disposed(by: db)
        
        tableView.rx.modelSelected(Workout.self).subscribe(onNext: { routine in
            self.delegate.selectWorkoutVC(self, selectedRoutine: routine)
        }).disposed(by: db)
        
//        tableView.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        
        startBlankWorkoutButton.rx.tap.subscribe(onNext: {
            self.delegate.startBlankWorkoutSelected(for: self)
        }).disposed(by: db)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Lets.cancel, style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem!.rx.tap.subscribe(onNext: {
            self.delegate.cancelSelected(for: self)
        }).disposed(by: db)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        tableView.reloadData()
    }
    
    let db = DisposeBag()
    
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "workout")
    }
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .white
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let s = StringStyle(.color(.white))
        return "Create a routine to be able to select a routine to format your workout.".styled(with: s)
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let s = StringStyle(.color(.white))
        return "To add a routine, close this page and click the \"Routines\" tab.".styled(with: s)
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
}
