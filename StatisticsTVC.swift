import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet
import RxRealm

class StatisticsTVC: UIViewController, UITableViewDelegate {
    
    let tableView = UITableView()
    
    func setTableHeaderView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        let label = UILabel()
        label.text = "Statistics"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        tableView.tableHeaderView = view
    }        
    
    weak var delegate: StatisticsTVCDelegate!
    
    var pairs = Variable([(String,Int)]())
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let lifts = RLM.realm.objects(Lift.self).filter("isWorkout = true").reduce([String:Int]()) { (dict, lift) in
            var new = dict
            new[lift.name] = (dict[lift.name] ?? 0) + 1
            return new
        }
        pairs.value = Array(zip(lifts.keys, lifts.values))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Theme.Colors.darkest
        
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
        
        tableView.delegate = self
        tableView.separatorStyle = .none

        setTableHeaderView()
        
        tableView.register(StatisticsCell.self)
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        
        setupRx()
        
    }
    
    func setupRx() {
        tableView.dataSource = nil
        tableView.delegate = nil
        pairs.asObservable().bindTo(tableView.rx.items(cellIdentifier: StatisticsCell.reuseIdentifier, cellType: StatisticsCell.self)) { index, pair, cell in
            cell.textLabel?.text = pair.0
            cell.detailTextLabel?.text = "\(pair.1)"
        }.addDisposableTo(db)
        
        tableView.rx.modelSelected((String,Int).self).subscribe(onNext: { item in
            self.delegate.statisticsTVC(self, didSelectLiftType: item.0)
        }).addDisposableTo(db)
    }
    let db = DisposeBag()
}


protocol StatisticsTVCDelegate: class {
    func statisticsTVC(_ statisticsTVC: StatisticsTVC, didSelectLiftType liftType: String)
}



extension StatisticsTVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "statistics")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "You havne't done any workouts, yet!")
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "After you've completed a workout, this page will show you statistics on your exercises done.")
    }
    //    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
    //        return NSAttributedString(string: "This is the button title")
    //    }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -70
    }
}
