import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		return true
	}
	
	/* Выбор sceneDelegate класса */
	func application(_ application: UIApplication,
					 configurationForConnecting connectingSceneSession: UISceneSession,
					 options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		if connectingSceneSession.role == UISceneSession.Role.windowApplication {
			let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
			config.delegateClass = SceneDelegate.self
			return config
		}
		fatalError("Unhandled scene role \(connectingSceneSession.role)")
	}
}
