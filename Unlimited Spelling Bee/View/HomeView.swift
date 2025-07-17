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
        
        ButtonSolid(
          text: "Choose Puzzle",
          color: Color.black,
          action: { appData.navigate(Views.datepicker) }
        )
        
        ButtonSolid(
          text: "Random",
          color: Color.black,
          action: {
            if let selected = appData.puzzles.randomElement() {
              appData.puzzleId = selected.key
              appData.letterCenter = selected.value.center
              let outerLetters = selected.value.letters.filter { $0 != selected.value.center }
              appData.letterOuter1 = outerLetters[0]
              appData.letterOuter2 = outerLetters[1]
              appData.letterOuter3 = outerLetters[2]
              appData.letterOuter4 = outerLetters[3]
              appData.letterOuter5 = outerLetters[4]
              appData.letterOuter6 = outerLetters[5]
            }
            appData.navigate(Views.puzzle)
          }
        )
        
        ButtonSolid(
          text: "History",
          color: Color.black,
          action: { appData.navigate(Views.history) }
        )
        
      }.background(Color.clear)
    }.background(Color.clear)
  }
}
