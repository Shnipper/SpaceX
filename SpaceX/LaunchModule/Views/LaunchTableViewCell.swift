import UIKit

final class LaunchTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var launchImageView: UIImageView!
    
    func configure(with index: Int) {
        let launch = DataManager.launches[index]
        if let success = launch.success {
            if success {
                launchImageView.image = UIImage(named: "startUp")
            } else {
                launchImageView.image = UIImage(named: "startDown")
            }
        }
        nameLabel.text = launch.name
        dateLabel.text = launch.dateToPresent
    }
}
