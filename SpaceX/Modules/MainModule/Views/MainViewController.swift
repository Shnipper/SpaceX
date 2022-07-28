import UIKit

final class MainViewController: UIViewController, MainViewControllerProtocol {
    
    let presenter: MainPresenterProtocol
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "MainViewController", bundle: nil)
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet var rocketNameLabel: UILabel!
    @IBOutlet var rocketImageView: UIImageView!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var firstFlightLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var costPerLaunchLabel: UILabel!
    
    @IBOutlet var firstEnginesCount: UILabel!
    @IBOutlet var firstFuel: UILabel!
    @IBOutlet var firstTimeToBurn: UILabel!
    
    @IBOutlet var secondEnginesCount: UILabel!
    @IBOutlet var secondFuel: UILabel!
    @IBOutlet var secondTimeToBurn: UILabel!
    
    @IBAction func launchButtonPressed() {
        let launchListVC = ModuleBuilder.createLaunchList(with: presenter.getCurrentRocketID, and: presenter.getCurrentRocketName)
        navigationController?.pushViewController(launchListVC, animated: true)
    }
    
    @IBAction func settingsButtonPressed() {
        let settingsVC = ModuleBuilder.createSettingsModule(with: presenter)
        navigationController?.present(settingsVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "UnitCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "UnitCollectionViewCell")
        
        presenter.updateRocket(by: pageControl.currentPage)
        
        customiseScrollView()
        customiseNavigationController()
        
        pageControl.addTarget(self,
                              action: #selector(pageControlValueChanged),
                              for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        rocketImageView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rocketImageView.isHidden = true
        navigationController?.isNavigationBarHidden = false
    }
    
    func update(pageCount: Int) {
        pageControl.numberOfPages = pageCount
    }
    
    func set(_ rocketMainInfo: RocketMainInfo) {
        rocketNameLabel.text = rocketMainInfo.name
        firstFlightLabel.text = rocketMainInfo.firstFlight
        countryLabel.text = rocketMainInfo.country
        costPerLaunchLabel.text = rocketMainInfo.costPerLaunch
        firstEnginesCount.text = rocketMainInfo.firstStageEngines
        firstFuel.text = rocketMainInfo.firstStageFuelAmountTons
        firstTimeToBurn.text = rocketMainInfo.firstStageBurnTimeSec
        secondEnginesCount.text = rocketMainInfo.secondStageEngines
        secondFuel.text = rocketMainInfo.secondStageFuelAmountTons
        secondTimeToBurn.text = rocketMainInfo.secondStageBurnTimeSec
    }
    
    func setRocketImage(with data: Data) {
        rocketImageView.image = UIImage(data: data)
    }
    
    func updateRocketDetailInfo() {
        collectionView.reloadData()
    }
    
    @objc
    private func pageControlValueChanged() {
        presenter.updateRocket(by: pageControl.currentPage)
    }
    
    private func customiseNavigationController() {
        navigationController?.navigationBar.barTintColor = .black
        let backButton = UIBarButtonItem(title: "Назад", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
    }
    
    private func customiseScrollView() {
        contentView.addGestureRecognizer(createSwipeGestureRecognizer(for: .left))
        contentView.addGestureRecognizer(createSwipeGestureRecognizer(for: .right))
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        RocketParameters.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("back")
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "UnitCollectionViewCell",
            for: indexPath
        ) as? UnitCollectionViewCell else { return UICollectionViewCell() }
        
        print("back with cell")
        
        cell.configure(with: presenter.getRocketDetailInfo(by: indexPath.row))
        
        return cell
    }
}

// MARK: - SwipeGestureRecognizer

extension MainViewController {
    
    private func createSwipeGestureRecognizer(
        for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
            
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self,
                                                              action: #selector(didSwipe(_:)))
        swipeGestureRecognizer.direction = direction
        return swipeGestureRecognizer
    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case .left:
            if pageControl.currentPage != pageControl.numberOfPages - 1 {
                pageControl.currentPage += 1
                pageControlValueChanged()
            }
        case .right:
            if pageControl.currentPage != 0 {
                pageControl.currentPage -= 1
                pageControlValueChanged()
            }
        default: break
        }
    }
}
