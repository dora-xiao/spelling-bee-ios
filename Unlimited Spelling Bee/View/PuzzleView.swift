import SwiftUI

struct PuzzleView: View {
  @EnvironmentObject var appData : AppData
  
  // Guessed words
  @State var guessed: String = "Your words..."
  @State var chevron: String = "chevron.down"
  @State var guessBoxHeight: CGFloat = 45
  @State var guessedList: [String] = []
  
  // Other data
  let size: CGFloat = 100
  @State private var progress = 0.0
  @State var word: String = "Enter guess..."
  
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
        
        ProgressView(value: progress, total: Double(appData.currPuzzle.genius))
          .clipShape(RoundedRectangle(cornerRadius: 5))
          .frame(width: UIScreen.main.bounds.width - 60)
          .offset(CGSize(width: 30, height: 0))
          .scaleEffect(x: 1, y: 2, anchor: .center)
          .tint(Color.customYellow)
          .padding([.bottom], 10)
      }
      
      ZStack(alignment: .top) {
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color.customGrey, lineWidth: 2)
          .frame(height: guessBoxHeight)
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(Color.customGrey, lineWidth: 2)
              .background(Color.customWhite)
          )
        Text(guessed)
          .font(.subheadline)
          .foregroundColor(chevron == "chevron.down" ? Color.customDarkGrey : Color.black)
          .frame(width: UIScreen.main.bounds.width - 100, alignment: .leading)
          .offset(CGSize(width: -5, height: 0))
          .lineLimit(1)
          .padding([.top], 12.5)
        HStack() {
          Spacer()
          Image(systemName: chevron)
            .padding([.trailing], 10)
        }
        .padding([.top], 17)
      }
      .frame(width: UIScreen.main.bounds.width - 60)
      .contentShape(Rectangle())
      .onTapGesture {
        if(chevron == "chevron.down") { // Expand
          chevron = "chevron.up"
          guessBoxHeight = UIScreen.main.bounds.height * 0.7
          
        } else { // Collapse
          chevron = "chevron.down"
          guessBoxHeight = 45
        }
      }
      .offset(CGSize(width: 30, height: 100))
      .zIndex(20)
      
      
      
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
              if(word == "Enter guess...") { return }
              let currGuess = word.lowercased()
              if(appData.currPuzzle.words.contains(currGuess)) {
                if(guessed == "Your words...") {
                  guessed = currGuess
                } else {
                  guessed = currGuess + ", " + guessed
                }
                guessedList.append(currGuess)
                if(appData.currPuzzle.pangrams.contains(currGuess)) {
                  progress += Double(currGuess.count + 7)
                } else if(currGuess.count == 4) {
                  progress += 1.0
                } else {
                  progress += Double(currGuess.count)
                }
                word = "Enter guess..."
                print("Guessed word")
              } else {
                print("Not a word")
              }
            }
          )
        }
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}
