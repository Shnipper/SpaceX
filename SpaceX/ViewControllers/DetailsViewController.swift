import UIKit

class DetailsViewController: UITableViewController {
    
    var rocketId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rocketId = rocketId else { return 0 }
        return DataManager.getCurrentLaunches(with: rocketId).count
       
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "launchCell", for: indexPath) as? LaunchTableViewCell else { return UITableViewCell() }

        cell.configure(with: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
