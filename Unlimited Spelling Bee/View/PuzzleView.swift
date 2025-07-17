import SwiftUI

struct PuzzleView: View {
  @EnvironmentObject var appData : AppData
  
  var body: some View {
    ZStack {
      Color.customYellow
        .ignoresSafeArea()
      
      VStack(spacing: 20) {
        Text("Puzzle view")
      }
    }
  }
}
