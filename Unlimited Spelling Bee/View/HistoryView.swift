import SwiftUI

struct HistoryView: View {
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
        .foregroundColor(Color.black)
      
      VStack() {
        Spacer()
        Text("To Do")
          .foregroundColor(Color.black)
        Spacer()
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}
