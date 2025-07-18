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
  @Published var currView: Views = Views.home
  @Published var prevViews: [Views] = []
  @Published var letterCenter: String = "A"
  @Published var letterOuter1: String = "B"
  @Published var letterOuter2: String = "C"
  @Published var letterOuter3: String = "D"
  @Published var letterOuter4: String = "E"
  @Published var letterOuter5: String = "F"
  @Published var letterOuter6: String = "G"
  var puzzles: [Int: Puzzle]
  @Published var puzzleId: Int = -1
  @Published var currPuzzle: Puzzle = initPuzzle
  
  init() {
    self.puzzles = loadPuzzlesById()
  }
    
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
