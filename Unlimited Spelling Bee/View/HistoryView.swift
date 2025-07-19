import SwiftUI

struct HistoryView: View {
  @EnvironmentObject var appData : AppData
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.customWhite
        .ignoresSafeArea()
      
      HStack {
        Image(systemName: "chevron.left")
          .foregroundColor(Color.black)
          .padding([.leading, .top, .bottom], 20)
          .padding([.trailing], 10)
          .bold()
          .font(.title3)
          .onTapGesture { appData.navigate(Views.home) }
        Text("History")
          .font(.title3)
          .foregroundColor(Color.black)
        Spacer()
      }.padding([.bottom], 10)
      
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
