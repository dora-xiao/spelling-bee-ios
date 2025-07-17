import SwiftUI

struct PuzzleView: View {
  @EnvironmentObject var appData : AppData
  let size: CGFloat = 100
  @State var word: String = "Enter guess..."
  @State var guessed: String = "Your words..."
  @State var chevron: String = "chevron.down"
  var guessedList: [String] = []
  @State private var progress = 0.5
  var datelabel: String {
    return idToDateLabel(id: appData.puzzleId)
  }
  
  func tapLetter(_ letter: String) -> Void {
    if(word == "Enter guess...") {
      word = letter
    } else if(word.count < 16) {
      word += letter
    }
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.customWhite
        .ignoresSafeArea()
      
      VStack(alignment: .leading) {
        HStack {
          Image(systemName: "chevron.left")
            .padding([.leading, .top, .bottom], 20)
            .padding([.trailing], 10)
            .bold()
            .font(.title3)
            .onTapGesture { appData.navigate(Views.home) }
          Text(datelabel)
            .font(.title3)
        }
        
        ProgressView(value: progress, total: 1)
          .clipShape(RoundedRectangle(cornerRadius: 5))
          .frame(width: UIScreen.main.bounds.width - 60)
          .offset(CGSize(width: 30, height: 0))
          .scaleEffect(x: 1, y: 2, anchor: .center)
          .tint(Color.customYellow)
          .padding([.bottom], 10)
        
        ZStack {
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color.customGrey, lineWidth: 2)
            .frame(height: 45)
          Text(guessed)
            .font(.subheadline)
            .foregroundColor(Color.customDarkGrey)
            .frame(width: UIScreen.main.bounds.width - 100, alignment: .leading)
            .offset(CGSize(width: -5, height: 0))
            .lineLimit(1)
          HStack() {
            Spacer()
            Image(systemName: chevron)
                .padding([.trailing], 10)
          }
        }
        .frame(width: UIScreen.main.bounds.width - 60)
        .contentShape(Rectangle())
        .onTapGesture {
          chevron = chevron == "chevron.down" ? "chevron.up" : "chevron.down"
        }
        .offset(CGSize(width: 30, height: 0))
      }
      
      VStack {
        Text(word) // Word Guess
          .foregroundColor(word == "Enter guess..." ? Color.customGrey : Color.black)
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
              if(word == "Enter guess...") { return }
              if(word.count > 1) {
                word = String(word.dropLast())
              } else {
                word = "Enter guess..."
              }
            }
          )
          
          ButtonOutlineSymbol(
            symbol: "shuffle",
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
            action: {
              // TODO: handle guess
            }
          )
        }
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}
