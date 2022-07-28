import UIKit

final class UnitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var unitLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    func configure(with rocketDetailInfo: RocketDetailInfo?) {
        guard let rocketDetailInfo = rocketDetailInfo else { return }
        titleLabel.text = rocketDetailInfo.parameterTitle
        unitLabel.text = rocketDetailInfo.unit
    }
}


