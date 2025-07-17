import SwiftUI

struct NavigationView: View {
  @EnvironmentObject var appData : AppData
  
  var body: some View {
    switch (appData.currView) {
      case .home: HomeView().environmentObject(self.appData)
      case .datepicker: DatePickerView().environmentObject(self.appData)
      case .puzzle: PuzzleView().environmentObject(self.appData)
      case .history: HistoryView().environmentObject(self.appData)
    }
  }
}
