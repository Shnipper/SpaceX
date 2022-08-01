import UIKit

class SettingsViewController: UIViewController, SettingsViewControllerProtocol {
    
    let presenter: SettingsPresenterProtocol
    
    required init(presenter: SettingsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "SettingsViewController", bundle: nil)
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var heightSegmentedControl: UISegmentedControl!
    @IBOutlet var diameterSegmentedControl: UISegmentedControl!
    @IBOutlet var massSegmentedControl: UISegmentedControl!
    @IBOutlet var payloadWeightsSegmentedControl: UISegmentedControl!
    @IBOutlet var segmentedControls: [UISegmentedControl]!
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        presenter.backButtonPressed()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControls.forEach { customise($0) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.delegate.updateRocketDetailInfo()
        saveSettings()
        super.viewWillDisappear(true)
    }
    
    private func configure() {
        heightSegmentedControl.selectedSegmentIndex = presenter.getHightIndex()
        diameterSegmentedControl.selectedSegmentIndex = presenter.getDiameterIndex()
        massSegmentedControl.selectedSegmentIndex = presenter.getMassIndex()
        payloadWeightsSegmentedControl.selectedSegmentIndex = presenter.getPayloadWeightIndex()
    }
    
    private func saveSettings() {
        presenter.saveSettings(heightSegmentedControl.selectedSegmentIndex,
                               diameterSegmentedControl.selectedSegmentIndex,
                               massSegmentedControl.selectedSegmentIndex,
                               payloadWeightsSegmentedControl.selectedSegmentIndex)
    }
    
    private func customise(_ segmentedControl: UISegmentedControl) {
           segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.darkGray], for: .normal)
           segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
}
