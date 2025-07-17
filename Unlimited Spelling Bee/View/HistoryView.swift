import SwiftUI

struct HistoryView: View {
  @EnvironmentObject var appData : AppData
  
  var body: some View {
    ZStack {
      Color.customWhite
        .ignoresSafeArea()
      
      VStack(spacing: 20) {
        Text("History view")
      }
    }
  }
}
