import SwiftUI

struct HomeView: View {
  @EnvironmentObject var appData : AppData
  
  var body: some View {
    VStack(spacing: 20) {
      Text("Spelling Bee")
        .font(.largeTitle)
        .padding()
      
      Button("Choose Puzzle") {
        appData.currView = CurrView.datepicker
        appData.prevViews.append(CurrView.home)
      }
      .buttonStyle(.borderedProminent)
      .tint(Color.yellow)
      .font(.title2)
      
      Button("Random") {
        appData.currView = CurrView.puzzle
        appData.prevViews.append(CurrView.home)
      }
      .buttonStyle(.borderedProminent)
      .tint(Color.yellow)
      .font(.title2)
      
      Button("History") {
        appData.currView = CurrView.history
        appData.prevViews.append(CurrView.home)
      }
      .buttonStyle(.borderedProminent)
      .tint(Color.yellow)
      .font(.title2)
    }
  }
}
