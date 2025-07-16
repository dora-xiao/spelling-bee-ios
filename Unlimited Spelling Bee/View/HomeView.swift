import SwiftUI

struct HomeView: View {
  @EnvironmentObject var appData : AppData
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.customYellow
          .ignoresSafeArea()
        
        VStack(spacing: 20) {
          Image("bee_logo")
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.width * 0.5)
            .padding([.bottom], 40)
          
          Button {
            appData.currView = CurrView.datepicker
            appData.prevViews.append(CurrView.home)
          }
        label: {
          Text("Choose Puzzle")
            .frame(width: UIScreen.main.bounds.width * 0.5)
            .padding(6)
        }
        .buttonStyle(.borderedProminent)
        .tint(Color.black)
        .font(.title2)
        .cornerRadius(50)
          
          Button {
            appData.currView = CurrView.puzzle
            appData.prevViews.append(CurrView.home)
          } label: {
            Text("Random")
              .frame(width: UIScreen.main.bounds.width * 0.5)
              .padding(6)
          }
          .buttonStyle(.borderedProminent)
          .tint(Color.black)
          .font(.title2)
          .cornerRadius(50)
          
          Button {
            appData.currView = CurrView.history
            appData.prevViews.append(CurrView.home)
          } label: {
            Text("History")
              .frame(width: UIScreen.main.bounds.width * 0.5)
              .padding(6)
          }
          .buttonStyle(.borderedProminent)
          .tint(Color.black)
          .font(.title2)
          .cornerRadius(50)
          
        }
        .background(Color.clear)
      }
      .background(Color.clear)
    }
  }
}
