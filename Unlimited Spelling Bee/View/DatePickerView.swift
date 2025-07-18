import SwiftUI

struct DatePickerView: View {
  @EnvironmentObject var appData : AppData
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.customWhite
        .ignoresSafeArea()
      
      Image(systemName: "chevron.left")
        .padding(20)
        .bold()
        .font(.title3)
        .onTapGesture { appData.navigate(Views.home) }
      
      VStack {
        Text("To Do")
        let temp = print(puzzleIDs(month: 1, year: 2024, puzzles: appData.puzzles).count)
      }
    }
  }
}
