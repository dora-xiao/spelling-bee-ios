import SwiftUI

struct HomeView: View {
  @EnvironmentObject var appData : AppData
  
  var body: some View {
    ZStack {
      Color.customYellow
        .ignoresSafeArea()
      
      VStack(spacing: 20) {
        Image("bee_logo")
          .resizable()
          .scaledToFit()
          .frame(width: UIScreen.main.bounds.width * 0.5)
          .padding([.bottom], 40)
        
        BubbleButton(
          text: "Choose Puzzle",
          color: Color.black,
          action: { appData.navigate(Views.datepicker) }
        )
        
        BubbleButton(
          text: "Random",
          color: Color.black,
          action: { appData.navigate(Views.puzzle) }
        )
        
        BubbleButton(
          text: "History",
          color: Color.black,
          action: { appData.navigate(Views.history) }
        )
        
      }.background(Color.clear)
    }.background(Color.clear)
  }
}
