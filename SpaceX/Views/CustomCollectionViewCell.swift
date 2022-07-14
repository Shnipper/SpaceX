import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var unitLabel: UILabel!
    @IBOutlet var parameterLabel: UILabel!
    @IBOutlet var shortUnitLabel: UILabel!
    
    func configure(with item: Int) {
        setShortUnitLabel(for: item)
        parameterLabel.text = RocketParameters.allCases[item].rawValue
    }
    
    private func setShortUnitLabel(for item: Int) {
        switch RocketParameters.allCases[item] {
        case .height:
            shortUnitLabel.text = SettingsManager.settings.height.rawValue
        case .diameter:
            shortUnitLabel.text = SettingsManager.settings.diameter.rawValue
        case .mass:
            shortUnitLabel.text = SettingsManager.settings.mass.rawValue
        case .payloadWeights:
            shortUnitLabel.text = SettingsManager.settings.payloadWeights.rawValue
        }
    }
}


