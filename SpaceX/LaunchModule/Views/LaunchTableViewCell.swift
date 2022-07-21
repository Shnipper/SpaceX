import UIKit

final class LaunchTableViewCell: UITableViewCell {

    @IBOutlet var launchName: UILabel!
    @IBOutlet var launchDate: UILabel!
    @IBOutlet var launchStatusImage: UIImageView!
    
    func configure(with index: Int) {
        let launch = DataManager.launches[index]
        if let success = launch.success {
            if success {
                launchStatusImage.image = UIImage(named: "startUp")
            } else {
                launchStatusImage.image = UIImage(named: "startDown")
            }
        }
        launchName.text = launch.name
        launchDate.text = launch.dateToPresent
    }
}
