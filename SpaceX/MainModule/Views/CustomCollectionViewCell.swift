import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var unitLabel: UILabel!
    @IBOutlet var parameterLabel: UILabel!
    
    var parameterType: RocketParameters!
    
    func configure(with item: Int, and settings: Settings) {
        
        parameterLabel.text = RocketParameters.allCases[item].rawValue
    }
}


