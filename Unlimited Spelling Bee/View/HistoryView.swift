import SwiftUI

struct HistoryView: View {
  @EnvironmentObject var appData: AppData
  @State private var showingConfirmation = false
  @State private var toDelete = -1
  
  var sortedHistory: [PuzzleHistory] {
    appData.history.sorted(by: { ($0.lastModified ?? .distantPast) > ($1.lastModified ?? .distantPast) })
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.customWhite.ignoresSafeArea()
      
      VStack(alignment: .leading, spacing: 0) {
        // Back button + title
        HStack {
          Image(systemName: "chevron.left")
            .foregroundColor(Color.black)
            .padding([.leading, .top, .bottom], 20)
            .padding(.trailing, 10)
            .bold()
            .font(.title3)
            .onTapGesture { appData.navigate(Views.home) }
          
          Text("History")
            .font(.title3)
            .foregroundColor(Color.black)
          
          Spacer()
        }
        .padding(.bottom, 10)
        
        if sortedHistory.isEmpty {
          Spacer()
          Text("No history found")
            .foregroundColor(.gray)
            .font(.subheadline)
            .frame(maxWidth: .infinity, alignment: .center)
          Spacer()
        } else {
          ScrollView {
            VStack(spacing: 16) {
              ForEach(sortedHistory, id: \.self) { history in
                let puzzleId = Int(history.puzzleId)
                let progress = history.progress
                let genius = Double(appData.puzzles[puzzleId]?.genius ?? 1)
                let fraction = min(progress / genius, 1.0)
                
                ZStack(alignment: .leading) {
                  // Full background tile
                  RoundedRectangle(cornerRadius: 20)
                    .fill(Color.customGrey)
                  
                  // Progress fill
                  RoundedRectangle(cornerRadius: 20)
                    .fill(Color.customYellow)
                    .mask(
                      HStack {
                        RoundedRectangle(cornerRadius: 20)
                          .frame(width: UIScreen.main.bounds.width * 0.9 * CGFloat(fraction))
                        Spacer()
                      }
                    )
                  
                  HStack {
                    // Tap area (left side)
                    Button(action: {
                      appData.puzzleId = puzzleId
                      appData.currPuzzle = appData.puzzles[puzzleId]!
                      appData.letterCenter = appData.currPuzzle.center
                      let outerLetters = appData.currPuzzle.letters.filter { $0 != appData.currPuzzle.center }
                      appData.letterOuter1 = outerLetters[0]
                      appData.letterOuter2 = outerLetters[1]
                      appData.letterOuter3 = outerLetters[2]
                      appData.letterOuter4 = outerLetters[3]
                      appData.letterOuter5 = outerLetters[4]
                      appData.letterOuter6 = outerLetters[5]
                      appData.navigate(Views.puzzle)
                    }) {
                      HStack {
                        Text(idToDateLabel(id: puzzleId))
                          .foregroundColor(.black)
                          .bold()
                        Spacer()
                        if let modified = history.lastModified {
                          Text(timeAgo(since: modified))
                            .foregroundColor(.black)
                            .font(.caption)
                        }
                        
                        // Delete button
                        Button(action: {
                          showingConfirmation = true
                          toDelete = puzzleId
                        }) {
                          Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                        }
                        .confirmationDialog("Delete Item?", isPresented: $showingConfirmation) {
                          Button("Delete", role: .destructive) {
                            deleteHistory(appData: appData, puzzleId: toDelete)
                          }
                          Button("Cancel", role: .cancel) {}
                        }
                        message: {
                          Text("Are you sure you want to delete the \(idToDateLabel(id: toDelete)) puzzle?")
                        }
                        .padding(.leading, 8)
                      }
                      .padding(.horizontal, 16)
                      .padding(.vertical, 16)
                    }
                    .buttonStyle(PlainButtonStyle())
                  }
                }
                .frame(height: 70)
                .padding(.horizontal, 20)
              }
            }
            .padding(.top, 10)
          }
        }
      }
    }
  }
  
  func timeAgo(since date: Date) -> String {
    let interval = Date().timeIntervalSince(date)
    let seconds = Int(interval)
    if seconds < 60 {
      return "\(seconds)s ago"
    } else if seconds < 3600 {
      return "\(seconds / 60)m ago"
    } else if seconds < 86400 {
      return "\(seconds / 3600)h ago"
    } else {
      return "\(seconds / 86400)d ago"
    }
  }
}
