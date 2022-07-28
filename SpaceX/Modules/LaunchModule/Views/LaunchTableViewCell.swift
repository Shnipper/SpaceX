import UIKit

final class LaunchTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var launchImageView: UIImageView!
    @IBOutlet var statusImageView: UIImageView!
    
    func configure(with launchInfo: LaunchInfo) {
        
        nameLabel.text = launchInfo.launchName
        dateLabel.text = launchInfo.launchDate
        
        if launchInfo.launchStatus {
            launchImageView.image = UIImage(named: "startUp")
            statusImageView.image = UIImage(systemName: "checkmark.circle.fill")
            statusImageView.tintColor = .green
        } else {
            launchImageView.image = UIImage(named: "startDown")
            statusImageView.image = UIImage(systemName: "xmark.circle.fill")
            statusImageView.tintColor = .red
        }
    }
}
