import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)

    self.window = UIWindow(frame: UIScreen.main.bounds)
    let navigationController: UINavigationController?
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let videoViewController = storyboard.instantiateViewController(withIdentifier: "VideoViewController")
    navigationController = UINavigationController(rootViewController: videoViewController)
    self.window?.rootViewController = navigationController
    self.window?.makeKeyAndVisible()
    
    return true
  }
}
