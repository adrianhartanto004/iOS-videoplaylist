import SwiftUI
import Watchdog

@main
struct VideoPlaylistExerciseApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      VideoHomeView()
    }
  }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var watchdog: Watchdog!
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//      watchdog = Watchdog(threshold: 3, strictMode: true)

      return true
    }
}
