import Foundation

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

// Gives puzzle ids that are in the chosen month and year
func puzzleIDs(month: Int, year: Int, puzzles: [Int: Puzzle]) -> [Int] {
    return puzzles.values
        .filter { $0.month == month && $0.year == year }
        .map { $0.id }
        .sorted()
}
