import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import DZNEmptyDataSet

class BaseTVC: UIViewController {
    
    let tableView = UITableView()
    
    override func loadView() {
        view = tableView
    }
    
}

