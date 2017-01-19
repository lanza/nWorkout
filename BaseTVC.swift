import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import DZNEmptyDataSet

class BaseTVC: UIViewController, UITableViewDelegate {
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    let tableView = UITableView()
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIResponder.currentFirstResponder?.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}

