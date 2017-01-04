import UIKit

class DataSource<Provider: DataProvider, Cell: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate where Cell: ConfigurableCell, Cell: ReusableView, Provider.Object == Cell.Object {
    
    let tableView: UITableView
    let provider: Provider
    
    init(tableView: UITableView, provider: Provider) {
        self.tableView = tableView
        self.provider = provider
        super.init()
        
        initialSetup()
    }
    
    func initialSetup() {
        tableView.dataSource = self
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provider.numberOfItems()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as! Cell
        let object = provider.object(at: indexPath.row)
        cell.configure(for: object, at: indexPath)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        fatalError()
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        fatalError()
    }
}

