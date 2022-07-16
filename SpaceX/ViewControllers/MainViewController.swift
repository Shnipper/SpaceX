import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func updateUI()
}

final class MainViewController: UIViewController {
    
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
    
    private var currentRocket: Rocket {
        DataManager.rockets[pageControl.currentPage]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeScrollView()
        downloadData()
        pageControl.addTarget(self,
                              action: #selector(pageControlValueChanged),
                              for: .valueChanged)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        rocketImageView.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailsVC = segue.destination as? DetailsViewController {
            rocketImageView.isHidden = true
            detailsVC.rocketId = currentRocket.id
            detailsVC.navigationItem.title = currentRocket.name
        } else if let settingsVC = segue.destination as? SettingsViewController {
            settingsVC.delegate = self
        }
    }
    
    @objc private func pageControlValueChanged() {
        configure()
    }
    
    private func setUpRocketDetails(with rocket: Rocket) {
        rocketNameLabel.text = rocket.name
    }
    
    private func configure() {
        setUpRocketDetails(with: currentRocket)
        setUpScrollView(with: currentRocket)
        setUpCollectionView(with: currentRocket)
        setImage(with: currentRocket)
    }
    
    private func setImage(with rocket: Rocket) {
        
        let randomImageStringURL = rocket.flickrImages.randomElement()
        
        if let imageData = DataManager.images[randomImageStringURL] {
            
            self.rocketImageView.image = UIImage(data: imageData)
            
        } else {
            NetworkManager.fetchImage(
                from: rocket.flickrImages.randomElement()) { [weak self] result in

                switch result {
                case .success(let imageData):
                    DataManager.images[randomImageStringURL] = imageData
                    self?.rocketImageView.image = UIImage(data: imageData)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func downloadData() {
        
        NetworkManager.fetchRocketData() { [weak self] rockets in
            DataManager.rockets = rockets
            self?.pageControl.numberOfPages = DataManager.rockets.count
            self?.configure()
        }
        
        NetworkManager.fetchLaunchesData { launches in
            DataManager.launches = launches
        }
    }
    
    private func setUpCollectionView(with rocket: Rocket) {
        
        for index in 0 ..< collectionView.numberOfItems(inSection: 0) {
            guard let cell = collectionView.cellForItem(
                at: IndexPath(item: index, section: 0)) as? CustomCollectionViewCell else { return }
            
            let settings = SettingsManager.shared.getSettings()
            
            switch cell.parameterLabel.text {
                
            case RocketParameters.mass.rawValue:
                if settings.mass == .kg {
                    cell.unitLabel.text = "\(rocket.mass.kg)"
                } else {
                    cell.unitLabel.text = "\(rocket.mass.lb)"
                }
                
            case RocketParameters.diameter.rawValue:
                if settings.diameter == .meters {
                    cell.unitLabel.text = "\(rocket.diameter.meters ?? 0)"
                }  else {
                    cell.unitLabel.text = "\(rocket.diameter.feet ?? 0)"
                }
                
            case RocketParameters.height.rawValue:
                if settings.height == .meters {
                    cell.unitLabel.text = "\(rocket.height.meters ?? 0)"
                }  else {
                    cell.unitLabel.text = "\(rocket.height.feet ?? 0)"
                }
                
            case RocketParameters.payloadWeights.rawValue:
                for payloadWeight in rocket.payloadWeights {
                    if payloadWeight.id == "leo" {
                        if settings.payloadWeights == .kg {
                            cell.unitLabel.text = "\(payloadWeight.kg)"
                        } else {
                            cell.unitLabel.text = "\(payloadWeight.lb)"
                        }
                    }
                }
            default: break
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        RocketParameters.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CustomCollectionViewCell",
            for: indexPath
        ) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(with: indexPath.item)
        return cell
    }
}

// MARK: - ScrollView Settings

extension MainViewController {
    
    private func setUpScrollView(with rocket: Rocket) {
        
        firstFlightLabel.text = rocket.firstFlight
        countryLabel.text = rocket.country
        costPerLaunchLabel.text = "\(rocket.costPerLaunch)"
        
        firstEnginesCount.text = "\(rocket.firstStage.engines)"
        firstFuel.text = "\(rocket.firstStage.fuelAmountTons)"
        if let burnTimeSec = rocket.firstStage.burnTimeSec {
            firstTimeToBurn.text = "\(burnTimeSec)"
        } else {
            firstTimeToBurn.text = " "
        }
        
        secondEnginesCount.text = "\(rocket.secondStage.engines)"
        secondFuel.text = "\(rocket.secondStage.fuelAmountTons)"
        if let burnTimeSec = rocket.secondStage.burnTimeSec {
            secondTimeToBurn.text = "\(burnTimeSec)"
        } else {
            secondTimeToBurn.text = " "
        }
    }
    
    private func customizeScrollView() {
        contentView.addGestureRecognizer(createSwipeGestureRecognizer(for: .left))
        contentView.addGestureRecognizer(createSwipeGestureRecognizer(for: .right))
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

extension MainViewController: SettingsViewControllerDelegate {
    func updateUI() {
        collectionView.reloadData()
        setUpCollectionView(with: currentRocket)
        setImage(with: currentRocket)
    }
}
