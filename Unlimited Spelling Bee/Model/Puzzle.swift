import Foundation
import CoreData

// Puzzle structure in json
struct Puzzle: Codable {
  let id: Int
  let date: String
  let center: String
  let letters: [String]
  let pangrams: [String]
  let words: [String]
  let genius: Int
  let month: Int
  let day: Int
  let year: Int
}

var initPuzzle: Puzzle = Puzzle(
  id: -1,
  date: "",
  center: "",
  letters: [],
  pangrams: [],
  words: [],
  genius: -1,
  month: -1,
  day: -1,
  year: -1
)

// Read puzzles json
func loadPuzzlesById() -> [Int: Puzzle] {
  guard let url = Bundle.main.url(forResource: "puzzles", withExtension: "json") else {
    print("Puzzles.json not found in bundle")
    return [:]
  }
  
  do {
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    let puzzlesByDateKey = try decoder.decode([String: Puzzle].self, from: data)
    
    // Convert keys from date strings to id integers
    var puzzlesById: [Int: Puzzle] = [:]
    for (_, puzzle) in puzzlesByDateKey {
      puzzlesById[puzzle.id] = puzzle
    }
    print("Loaded puzzles")
    return puzzlesById
  } catch {
    print("Failed to decode puzzles.json: \(error)")
    return [:]
  }
}

// Conversion from puzzle id to date and vice versa
let basePuzzleID = 82
let baseDateComponents = DateComponents(year: 2018, month: 7, day: 29)
let calendar = Calendar.current

func dateToId(day: Int, month: Int, year: Int) -> Int? {
  guard let baseDate = calendar.date(from: baseDateComponents),
        let targetDate = calendar.date(from: DateComponents(year: year, month: month, day: day)) else {
    return nil
  }
  let daysDifference = calendar.dateComponents([.day], from: baseDate, to: targetDate).day ?? 0
  return basePuzzleID + daysDifference
}

func idToDate(id: Int) -> (day: Int, month: Int, year: Int)? {
  guard let baseDate = calendar.date(from: baseDateComponents) else { return nil }
  let offset = id - basePuzzleID
  guard let targetDate = calendar.date(byAdding: .day, value: offset, to: baseDate) else { return nil }
  
  let comps = calendar.dateComponents([.day, .month, .year], from: targetDate)
  guard let day = comps.day, let month = comps.month, let year = comps.year else { return nil }
  return (day, month, year)
}

func idToDateLabel(id: Int) -> String {
  var label = "Unknown Date"
  if let (day, month, year) = idToDate(id: id) {
    var comps = DateComponents() // <1>
    comps.day = day
    comps.month = month
    comps.year = year
    let date = Calendar.current.date(from: comps)!
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd, yyyy"
    label = dateFormatter.string(from: date)
  }
  return label
}

// Gives puzzle ids that are in the chosen month and year
func puzzleIDs(month: Int, year: Int, puzzles: [Int: Puzzle]) -> [Int] {
  return puzzles.values
    .filter { $0.month == month && $0.year == year }
    .map { $0.id }
    .sorted()
}

// Split array into [[first half], [second half]]
extension Array {
  func split() -> [[Element]] {
    let ct = self.count
    let half = ct / 2
    let leftSplit = self[0 ..< half]
    let rightSplit = self[half ..< ct]
    return [Array(leftSplit), Array(rightSplit)]
  }
}

// Adding string access
extension String {
  subscript (_ index: Int) -> String {
    get {
      String(self[self.index(startIndex, offsetBy: index)])
    }
    
    set {
      if index >= count {
        insert(Character(newValue), at: self.index(self.startIndex, offsetBy: count))
      } else {
        insert(Character(newValue), at: self.index(self.startIndex, offsetBy: index))
      }
    }
  }
}

// Save helper
func saveHistory(appData: AppData, puzzleId: Int, progress: Double, guessedList: [String]) {
  // Check if it already exists
  if let existing = appData.history.first(where: { $0.puzzleId == Int32(puzzleId) }) {
    existing.progress = progress
    existing.guessedList = guessedList as NSArray
  } else {
    let newHistory = PuzzleHistory(context: appData.context)
    newHistory.puzzleId = Int32(puzzleId)
    newHistory.progress = progress
    newHistory.guessedList = guessedList as NSArray
    newHistory.lastModified = Date()
    appData.history.append(newHistory)
  }
  
  do {
    try appData.context.save()
    appData.loadHistory()
    print("Saved history:")
    appData.history.forEach {
      let list = $0.guessedList as? [String] ?? []
      print("Puzzle \($0.puzzleId): \(list)")
    }
  } catch {
    print("Failed to save history: \(error)")
  }
}

// Delete saved history for one puzzle
func deleteHistory(appData: AppData, puzzleId: Int) {
    let context = appData.context
    let fetchRequest: NSFetchRequest<PuzzleHistory> = PuzzleHistory.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "puzzleId == %d", puzzleId)

    do {
        let results = try context.fetch(fetchRequest)
        for obj in results {
            context.delete(obj)
        }
        try context.save()
        appData.loadHistory()
        print("Deleted history for puzzle \(puzzleId)")
    } catch {
        print("Failed to delete history for puzzle \(puzzleId): \(error)")
    }
}

// Delete all saved history for all puzzles
func deleteAllHistories(appData: AppData) {
    let context = appData.context
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PuzzleHistory.fetchRequest()
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

    do {
        try context.execute(batchDeleteRequest)
        try context.save()
        appData.loadHistory()
        print("Deleted all puzzle histories.")
    } catch {
        print("Failed to delete all histories: \(error)")
    }
}

// Transformer for guessedList
@objc(ArrayStringTransformer)
class ArrayStringTransformer: NSSecureUnarchiveFromDataTransformer {
  override class var allowedTopLevelClasses: [AnyClass] {
    return [NSArray.self, NSString.self]
  }
  
  static let name = NSValueTransformerName(rawValue: String(describing: ArrayStringTransformer.self))
  
  public static func register() {
    let transformer = ArrayStringTransformer()
    ValueTransformer.setValueTransformer(transformer, forName: name)
  }
}

