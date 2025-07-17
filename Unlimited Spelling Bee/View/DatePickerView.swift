import SwiftUI

struct DatePickerView: View {
  @EnvironmentObject var appData : AppData
  
  var body: some View {
    ZStack {
      Color.customWhite
        .ignoresSafeArea()
      
      VStack(spacing: 20) {
        Text("Date picker view")
      }
    }
  }
}
