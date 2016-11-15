import UIKit
import RxCocoa
import RxSwift

extension LiftTypeTVC: ViewControllerFromStoryboard {
    static var storyboardIdentifier: String { return "LiftTypeTVC" }
}

class LiftTypeTVC: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    
    var liftTypes = UserDefaults.standard.value(forKey: "liftTypes") as? [String] ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
   
    func setupRx() {
        Observable.just(liftTypes).bindTo(tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { index, string, cell in
            cell.textLabel?.text = string
        }.addDisposableTo(db)
    }
    
    let db = DisposeBag()
}

