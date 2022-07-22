import Foundation

protocol MainViewControllerProtocol: AnyObject {
    func set(rocketMainInfo: RocketMainInfo)
    func set(rocketDetailInfo: RocketDetailInfo)
    
}

protocol MainPresenterProtocol: AnyObject {
    init(view: MainViewControllerProtocol,
         networkManager: NetworkManagerProtocol,
         settingsManager: SettingsManager,
         dataManager: DataManager)
    
    func setRocketMainInfo()
    func setRocketDetailInfo(with settings: Settings)
}

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewControllerProtocol?
    let networkManager: NetworkManagerProtocol
    let settingsManager: SettingsManager
    let dataManager: DataManager
    var rocket: Rocket?
    
    required init(view: MainViewControllerProtocol,
                  networkManager: NetworkManagerProtocol,
                  settingsManager: SettingsManager,
                  dataManager: DataManager) {
        
        self.view = view
        self.networkManager = networkManager
        self.settingsManager = settingsManager
        self.dataManager = dataManager
        self.rocket = nil
    }
    
    func setRocketMainInfo() {
        guard let rocket = rocket else { return }
        
        let rocketMainInfo = RocketMainInfo(
            name: rocket.name,
            firstFlight: changeDateType(inputDate: rocket.firstFlight),
            country: rocket.country,
            costPerLaunch: "\(rocket.costPerLaunch)",
            firstStageEngines: "\(rocket.firstStage.engines)",
            firstStageFuelAmountTons: "\(rocket.firstStage.fuelAmountTons)",
            firstStageBurnTimeSec: timeBurnSec(rocket.firstStage),
            secondStageEngines: "\(rocket.secondStage.engines)",
            secondStageFuelAmountTons: "\(rocket.secondStage.fuelAmountTons)",
            secondStageBurnTimeSec: timeBurnSec(rocket.secondStage)
        )
        
        view?.set(rocketMainInfo: rocketMainInfo)
    }
    
    func setRocketDetailInfo(with settings: Settings) {
        guard let rocket = rocket else { return }
        
        let height = settings.height == .meters
            ? rocket.height.meters
            : rocket.height.feet
        let diameter = settings.diameter == .meters
            ? rocket.diameter.meters
            : rocket.diameter.feet
        let mass = settings.mass == .kg
            ? rocket.mass.kg
            : rocket.mass.lb
        let payloadWeight = settings.payloadWeights == .kg
            ? leo(rocket.payloadWeights)?.kg
            : leo(rocket.payloadWeights)?.lb
        
        let rocketDetailInfo = RocketDetailInfo(
            height: "\(height)",
            diameter: "\(diameter)",
            mass: "\(mass)",
            payloadWeight: "\(stringFrom(payloadWeight))"
        )
        
        view?.set(rocketDetailInfo: rocketDetailInfo)
    }
    
    private func timeBurnSec(_ stage: Stage) -> String {
        guard let timeToBurn = stage.burnTimeSec else { return "" }
        return "\(timeToBurn)"
    }
    
    private func changeDateType(inputDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ru_RU")
            outputFormatter.setLocalizedDateFormatFromTemplate("MMMMddYYYY")
            let outputDate = outputFormatter.string(from: date)
            return outputDate
        } else {
            return inputDate
        }
    }
    
    private func leo(_ payloadWeights: [PayloadWeight]) -> PayloadWeight? {
        var value: PayloadWeight? = nil
        for payloadWeight in payloadWeights {
            if payloadWeight.id == "leo" {
                value = payloadWeight
            }
        }
        return value
    }
    
    private func stringFrom(_ payloadWeight: Int?) -> String {
        guard let payloadWeight = payloadWeight else { return "" }
        return "\(payloadWeight)"
    }
}
