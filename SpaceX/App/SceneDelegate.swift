import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.overrideUserInterfaceStyle = .dark
        
        let moduleBuilder = ModuleBuilder()
        let coordinator: CoordinatorProtocol = Coordinator(moduleBuilder: moduleBuilder)
        if let window = window {
            coordinator.start(window)
        }
    }
}

