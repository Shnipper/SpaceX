import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var unitLabel: UILabel!
    @IBOutlet var parameterLabel: UILabel!
    @IBOutlet var shortUnitLabel: UILabel!
    
    func configure(with item: Int, and settings: Settings) {
        setShortUnitLabel(for: item, with: settings)
        parameterLabel.text = RocketParameters.allCases[item].rawValue
    }
    
    private func setShortUnitLabel(for item: Int, with settings: Settings) {
        
        switch RocketParameters.allCases[item] {
        case .height:
            shortUnitLabel.text = settings.height.rawValue
        case .diameter:
            shortUnitLabel.text = settings.diameter.rawValue
        case .mass:
            shortUnitLabel.text = settings.mass.rawValue
        case .payloadWeights:
            shortUnitLabel.text = settings.payloadWeights.rawValue
        }
    }
}


