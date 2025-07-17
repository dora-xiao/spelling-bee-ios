import SwiftUI

struct PuzzleView: View {
  @EnvironmentObject var appData : AppData
  let size: CGFloat = 100
  @State var word: String = "Enter word..."
  
  func tapLetter(_ letter: String) -> Void {
    if(word == "Enter word...") {
      word = letter
    } else if(word.count < 16) {
      word += letter
    }
  }
  
  var body: some View {
    ZStack {
      Color.customWhite
        .ignoresSafeArea()
      VStack {
        // TODO: Progress bar & guessed words
        
        Text(word) // Word Guess
          .foregroundColor(word == "Enter word..." ? Color.customGrey : Color.black)
          .bold()
          .font(.title)
          .disabled(true)
          .padding([.bottom], 20)
          .lineLimit(1)
          .truncationMode(.head)
          .frame(width: UIScreen.main.bounds.width * 0.8)
        
        HStack(spacing: -0.12 * size) { // Board
          VStack(spacing: 0) {
            Tile(size: size, color: Color.customGrey, letter: appData.letterOuter[0])
              .onTapGesture {tapLetter(appData.letterOuter[0])}
            
            Tile(size: size, color: Color.customGrey, letter: appData.letterOuter[1])
              .onTapGesture {tapLetter(appData.letterOuter[1])}
          }
          VStack(spacing: 0) {
            Tile(size: size, color: Color.customGrey, letter: appData.letterOuter[2])
              .onTapGesture {tapLetter(appData.letterOuter[2])}
            
            Tile(size: size, color: Color.customYellow, letter: appData.letterCenter)
              .onTapGesture {tapLetter(appData.letterCenter)}
            
            Tile(size: size, color: Color.customGrey, letter: appData.letterOuter[3])
              .onTapGesture {tapLetter(appData.letterOuter[3])}
          }
          VStack(spacing: 0) {
            Tile(size: size, color: Color.customGrey, letter: appData.letterOuter[4])
              .onTapGesture {tapLetter(appData.letterOuter[4])}
            
            Tile(size: size, color: Color.customGrey, letter: appData.letterOuter[5])
              .onTapGesture {tapLetter(appData.letterOuter[5])}
          }
        }
        .padding([.bottom], 40)
        
        HStack { // Buttons
          ButtonOutline(
            text: "Delete",
            color: Color.customGrey,
            action: {}
          )
          
          ButtonOutlineSymbol(
            symbol: "figure.strengthtraining.traditional",
            color: Color.customGrey,
            action: {}
          )
          
          ButtonOutline(
            text: "Enter",
            color: Color.customGrey,
            action: {}
          )
        }
      }
    }
  }
}
