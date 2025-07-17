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
            Tile(size: size, color: Color.customGrey, letter: $appData.letterOuter1)
              .onTapGesture {tapLetter(appData.letterOuter1)}
            
            Tile(size: size, color: Color.customGrey, letter: $appData.letterOuter2)
              .onTapGesture {tapLetter(appData.letterOuter2)}
          }
          VStack(spacing: 0) {
            Tile(size: size, color: Color.customGrey, letter: $appData.letterOuter3)
              .onTapGesture {tapLetter(appData.letterOuter3)}
            
            Tile(size: size, color: Color.customYellow, letter: $appData.letterCenter)
              .onTapGesture {tapLetter(appData.letterCenter)}
              .id(appData.letterCenter)
            
            Tile(size: size, color: Color.customGrey, letter: $appData.letterOuter4)
              .onTapGesture {tapLetter(appData.letterOuter4)}
          }
          VStack(spacing: 0) {
            Tile(size: size, color: Color.customGrey, letter: $appData.letterOuter5)
              .onTapGesture {tapLetter(appData.letterOuter5)}
            
            Tile(size: size, color: Color.customGrey, letter: $appData.letterOuter6)
              .onTapGesture {tapLetter(appData.letterOuter6)}
          }
        }
        .padding([.bottom], 40)
        
        HStack { // Buttons
          ButtonOutline(
            text: "Delete",
            color: Color.customGrey,
            action: {
              if(word.count > 0) {
                word = String(word.dropLast())
              }
            }
          )
          
          ButtonOutlineSymbol(
            symbol: "figure.strengthtraining.traditional",
            color: Color.customGrey,
            action: {
              var letters = [
                appData.letterOuter1,
                appData.letterOuter2,
                appData.letterOuter3,
                appData.letterOuter4,
                appData.letterOuter5,
                appData.letterOuter6
              ]
              letters.shuffle()
              appData.letterOuter1 = letters[0]
              appData.letterOuter2 = letters[1]
              appData.letterOuter3 = letters[2]
              appData.letterOuter4 = letters[3]
              appData.letterOuter5 = letters[4]
              appData.letterOuter6 = letters[5]
            }
          )
          
          ButtonOutline(
            text: "Enter",
            color: Color.customGrey,
            action: {}
          )
          .onTapGesture {
            
          }
        }
      }
    }
  }
}
