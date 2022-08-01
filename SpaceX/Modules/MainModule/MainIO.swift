import Foundation

protocol MainInputProtocol: AnyObject {
}

protocol MainOutputProtocol: AnyObject {
    func moveToSettings(_ mainPresenterDelegate: MainPresenterDelegate)
    func moveToLaunchList(rocketID: String?, rocketName: String?)
}
