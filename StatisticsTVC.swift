import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet

extension StatisticsTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "StatisticsTVC" }
}

class StatisticsTVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var pairs: [(String,Int)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        
        let lifts = RLM.realm.objects(Lift.self).filter("isWorkout = true").reduce([String:Int]()) { (dict, lift) in
            var new = dict
            new[lift.name] = (dict[lift.name] ?? 0) + 1
            return new
        }
        pairs = Array(zip(lifts.keys, lifts.values))
        
        setupRx()
    }
    
    func setupRx() {
        Observable.just(pairs).bindTo(tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { index, pair, cell in
            cell.textLabel?.text = pair.0
            cell.detailTextLabel?.text = "Done \(pair.1) times"
        }.addDisposableTo(db)
    }
    let db = DisposeBag()

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
