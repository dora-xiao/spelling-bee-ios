import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
}

enum CurrView:Int {
  case home
  case datepicker
  case puzzle
  case history
}

// Environment variable for whole app
class AppData : ObservableObject {
  @Published var currView = CurrView.home
  @Published var prevViews : [CurrView] = []
}

@main
struct Habit_TrackerApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  private var appData = AppData()
  
  var body: some Scene {
    WindowGroup {
      HomeView().environmentObject(appData)
    }
  }
}
