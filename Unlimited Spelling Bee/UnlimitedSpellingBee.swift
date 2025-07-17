import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
}

enum Views:Int {
  case home
  case datepicker
  case puzzle
  case history
}

// Environment variable for whole app
class AppData : ObservableObject {
  @Published var currView = Views.home
  @Published var prevViews : [Views] = []
  
  func navigate(_ destination: Views) {
    prevViews.append(currView)
    currView = destination
  }
}

@main
struct Habit_TrackerApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  private var appData = AppData()
  
  var body: some Scene {
    WindowGroup {
      NavigationView().environmentObject(appData)
    }
  }
}
