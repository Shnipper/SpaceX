import UIKit

final class LaunchListViewController: UITableViewController,
                                      LaunchListViewControllerProtocol {
    
    private let presenter: LaunchListPresenterProtocol
    
    init(presenter: LaunchListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LaunchTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = presenter.rocketName
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        guard let launchesCount = presenter.launches?.count else { return 10 }
        return launchesCount
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath
                ) as? LaunchTableViewCell else { return UITableViewCell() }
        
        if let launchInfo = presenter.getLaunchInfo(from: indexPath.row) {
            cell.configure(with: launchInfo)
        }
        
        return cell
    }
    
    func updateUI() {
        tableView.reloadData()
    }
}
