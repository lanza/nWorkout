import UIKit
import RxSwift
import RxCocoa

extension StatisticsTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "StatisticsTVC" }
}

class StatisticsTVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var pairs: [(String,Int)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       
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
