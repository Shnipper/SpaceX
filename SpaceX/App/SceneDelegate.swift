import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
    
        let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .dark
        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

