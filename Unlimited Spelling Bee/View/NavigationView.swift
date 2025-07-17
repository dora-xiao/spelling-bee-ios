import SwiftUI

struct NavigationView: View {
  @EnvironmentObject var appData : AppData
  
  var body: some View {
    switch (appData.currView) {
      case .home: HomeView().environmentObject(appData)
      case .datepicker: DatePickerView().environmentObject(appData)
      case .puzzle: PuzzleView().environmentObject(appData)
      case .history: HistoryView().environmentObject(appData)
    }
  }
}
