import UIKit

final class SettingsViewController: UIViewController {

    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var heightSegmentedControl: UISegmentedControl!
    @IBOutlet var diameterSegmentedControl: UISegmentedControl!
    @IBOutlet var massSegmentedControl: UISegmentedControl!
    @IBOutlet var payloadWeightsSegmentedControl: UISegmentedControl!
    @IBOutlet var segmentedControls: [UISegmentedControl]!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControls.forEach { customise($0) }
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        saveSettings()
        delegate?.updateUI()
    }
    
    private func configure() {
        
        heightSegmentedControl.selectedSegmentIndex = SettingsManager.settings.height == .meters ? 0 : 1
        diameterSegmentedControl.selectedSegmentIndex = SettingsManager.settings.diameter == .meters ? 0 : 1
        massSegmentedControl.selectedSegmentIndex = SettingsManager.settings.mass == .kg ? 0 : 1
        payloadWeightsSegmentedControl.selectedSegmentIndex = SettingsManager.settings.payloadWeights == .kg ? 0 : 1
        
    }
    
    private func customise(_ segmentedControl: UISegmentedControl) {
           segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.darkGray], for: .normal)
           segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
    
    private func saveSettings() {
        let settings = Settings(
            height: heightSegmentedControl.selectedSegmentIndex == 0 ? .meters : .feet,
            diameter: diameterSegmentedControl.selectedSegmentIndex == 0 ? .meters : .feet,
            mass: massSegmentedControl.selectedSegmentIndex == 0 ? .kg : .lb,
            payloadWeights: payloadWeightsSegmentedControl.selectedSegmentIndex == 0 ? .kg : .lb)
        SettingsManager.settings = settings
    }
}


