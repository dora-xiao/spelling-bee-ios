import SwiftUI
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    ArrayStringTransformer.register()
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
class AppData: ObservableObject {
  @Published var currView: Views = Views.home
  @Published var prevViews: [Views] = []
  @Published var letterCenter: String = "A"
  @Published var letterOuter1: String = "B"
  @Published var letterOuter2: String = "C"
  @Published var letterOuter3: String = "D"
  @Published var letterOuter4: String = "E"
  @Published var letterOuter5: String = "F"
  @Published var letterOuter6: String = "G"
  @Published var puzzleId: Int = -1
  @Published var currPuzzle: Puzzle = initPuzzle
  var puzzles: [Int: Puzzle]
  var minYear: Int
  var maxYear: Int
  
  let context: NSManagedObjectContext
  @Published var history: [PuzzleHistory] = []
  
  init(context: NSManagedObjectContext) {
    self.context = context
    self.puzzles = loadPuzzlesById()
    self.minYear = idToDate(id: self.puzzles.keys.min()!)!.2
    self.maxYear = idToDate(id: self.puzzles.keys.max()!)!.2
    self.loadHistory()
  }
  
  func loadHistory() {
    let fetchRequest: NSFetchRequest<PuzzleHistory> = PuzzleHistory.fetchRequest()
    do {
      history = try context.fetch(fetchRequest)
    } catch {
      print("Failed to fetch puzzle history: \(error)")
    }
  }
  
  func navigate(_ destination: Views) {
    prevViews.append(currView)
    currView = destination
  }
}


@main
struct Habit_TrackerApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  let persistenceController = PersistenceController.shared
  @StateObject private var appData: AppData
  
  init() {
    let context = persistenceController.container.viewContext
    _appData = StateObject(wrappedValue: AppData(context: context))
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationView().environmentObject(appData)
    }
  }
}
