import UIKit

final class LaunchListViewController: UITableViewController {
    
    var presenter: LaunchListPresenterProtocol? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LaunchTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rocketId = presenter?.rocketID else { return 0 }
        return DataManager.getCurrentLaunches(with: rocketId).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LaunchTableViewCell else { return UITableViewCell() }
        cell.configure(with: indexPath.row)
        return cell
    }
}

extension LaunchListViewController: LaunchListViewControllerProtocol {
    func updateUI() {
        navigationItem.title = presenter?.rocketName
        tableView.reloadData()
    }
}
