import SwiftUI

struct PuzzleView: View {
  @EnvironmentObject var appData : AppData
  
  // Guessed words
  @State var guessed: String = "Your words..."
  @State var chevron: String = "chevron.down"
  @State var guessBoxHeight: CGFloat = 45
  @State var guessedList: [String] = []
  @State var lineLimit: Int = 1
  @State var strokeColor: Color = Color.customGrey
  @State var strokeWidth: CGFloat = 2
  @State var boxColor: Color = Color.clear
  @State var wrongGuess: Bool = false
  @State var hint: String = ""
  @State var revealed: String = ""
  
  // Other data
  let size: CGFloat = 100
  @State private var progress = 0.0
  @State var word: String = "Enter guess..."
  
  var datelabel: String {
    return idToDateLabel(id: appData.puzzleId)
  }
  
  // Handle tapping a letter
  func tapLetter(_ letter: String) -> Void {
    if(word == "Enter guess...") {
      word = letter
    } else if (hint != "") {
      let start = (word.components(separatedBy: "-"))[0]
      if(start.count < hint.count) {
        word = start + letter + String(repeating: "-", count: hint.count - start.count - 1)
      }
    } else if(word.count < 16) {
      word += letter
    }
    let vibrate = UIImpactFeedbackGenerator(style: .medium)
    vibrate.impactOccurred()
    wrongGuess = false
  }
  
  // Sort guesses by length and then aphabetically within each length
  func sortGuesses(strings: [String]) -> [String] {
    return strings.sorted {
      if $0.count == $1.count {
        return $0 < $1 // alphabetical
      }
      return $0.count < $1.count // Sort by length
    }
  }
  
  // Flash the guesses box yellow since the guess was correct
  func animateCorrectGuess() -> Void {
    strokeColor = Color.customYellow
    strokeWidth = 4
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      strokeColor = Color.customYellow
      strokeWidth = 6
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      strokeColor = Color.customYellow
      strokeWidth = 8
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
      strokeColor = Color.customYellow
      strokeWidth = 6
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
      strokeColor = Color.customYellow
      strokeWidth = 5
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
      strokeColor = Color.customYellow
      strokeWidth = 4
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
      strokeColor = Color.customYellow
      strokeWidth = 3
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
      strokeColor = Color.customGrey
      strokeWidth = 2
    }
  }
  
  func expandGuesses(_ guessedListCustom: [String]) {
    boxColor = Color.customWhite
    chevron = "chevron.up"
    guessBoxHeight = UIScreen.main.bounds.height * 0.7
    lineLimit = 30
    var result = ""
    let orderedGuesses = (sortGuesses(strings: guessedListCustom)).split()
    var a1 = orderedGuesses[0]
    var a2 = orderedGuesses[1]
    var rows = 0
    var extra = ""
    if(a1.count == a2.count) {
      rows = a1.count
    } else if(a1.count > a2.count) {
      rows = a2.count
      extra = a1.popLast()!
    } else {
      rows = a1.count
      extra = a2.removeFirst()
    }
    if(rows > 0) {
      for i in 0...(rows-1) {
        result += a1[i] + String(repeating: " ", count: 17 - a1[i].count) + a2[i] + "\n"
      }
    }
    guessed = result + extra
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.customWhite
        .ignoresSafeArea()
      
      VStack(alignment: .leading) {
        HStack {
          Image(systemName: "chevron.left")
            .foregroundColor(Color.black)
            .padding([.leading, .top, .bottom], 20)
            .padding([.trailing], 10)
            .bold()
            .font(.title3)
            .onTapGesture { appData.navigate(Views.home) }
          Text(datelabel)
            .font(.title3)
            .foregroundColor(Color.black)
          Spacer()
          Text(String(Int(progress)) + " pts")
            .font(.title3)
            .padding([.trailing], 30)
            .foregroundColor(Color.black)
        }.padding([.bottom], 10)
        
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
          .stroke(strokeColor, lineWidth: strokeWidth)
          .frame(height: guessBoxHeight)
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(Color.customGrey, lineWidth: 2)
              .background(boxColor)
          )
        Text(guessed)
          .font(.subheadline)
          .monospaced()
          .foregroundColor(chevron == "chevron.down" ? Color.customDarkGrey : Color.black)
          .frame(width: UIScreen.main.bounds.width - 100, alignment: .leading)
          .offset(CGSize(width: -5, height: 0))
          .lineLimit(lineLimit)
          .padding([.top], 12.5)
        HStack() {
          Spacer()
          Image(systemName: chevron)
            .padding([.trailing], 10)
            .foregroundColor(Color.black)
        }
        .padding([.top], 17)
      }
      .frame(width: UIScreen.main.bounds.width - 60)
      .contentShape(Rectangle())
      .onTapGesture {
        if(chevron == "chevron.down") { // Expand
          expandGuesses(guessedList)
        } else { // Collapse
          boxColor = Color.clear
          chevron = "chevron.down"
          guessBoxHeight = 45
          lineLimit = 1
          if(guessedList.count == 0) {
            guessed = "Your words..."
          } else {
            print(guessedList)
            guessed = guessedList.reversed().joined(separator: ", ")
          }
        }
      }
      .offset(CGSize(width: 30, height: 100))
      .zIndex(20)
      
      
      
      VStack {
        Text(word) // Word Guess
          .foregroundColor({
            if(wrongGuess) {
              return Color.red
            } else if(word == "Enter guess...") {
              return Color.customGrey
            } else if(word == hint) {
              return Color.customYellow
            } else {
              return Color.black
            }
          }())
          .bold()
          .font(.title)
          .disabled(true)
          .padding([.bottom], 20)
          .padding([.top], 50)
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
              wrongGuess = false
              if(word == "Enter guess...") { return }
              if(word.count > 1) {
                if(hint != "") {
                  let comp = word.components(separatedBy: "-")
                  if(!hint.starts(with: comp[0])) {
                    let start = comp[0].dropLast()
                    word = start + String(repeating: "-", count: hint.count - start.count)
                    revealed = String(start)
                  }
                } else {
                  word = String(word.dropLast())
                }
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
              if(appData.currPuzzle.words.contains(currGuess) && !guessedList.contains(currGuess)) {
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
                hint = ""
                saveHistory(appData: appData, puzzleId: appData.puzzleId, progress: progress, guessedList: guessedList)
                animateCorrectGuess()
                print("Guessed word")
              } else {
                wrongGuess = true
                print("Not a word: \(currGuess) in \(appData.currPuzzle.words)")
              }
            }
          )
        }
        .frame(height: 45)
        .padding([.bottom], 20)
        
        HStack {
          ButtonOutlineSymbol(
            symbol: "lightbulb",
            color: Color.customGrey,
            action: {
              wrongGuess = false
              if(hint == "") { // Choose hint word
                let notGuessed = Array(Set(appData.currPuzzle.words).subtracting(Set(guessedList)))
                let newHint = notGuessed.randomElement()
                if let chosenHint = newHint {
                  hint = chosenHint.uppercased()
                  revealed = String(chosenHint[0]).uppercased()
                  word = String(chosenHint[0]).uppercased() + String(repeating: "-", count: chosenHint.count - 1)
                }
              } else if(word != hint) {
                var newWord = ""
                var alreadyRevealed = false
                for i in 0...hint.count-1 {
                  if(word[i] != hint[i]) {
                    if(alreadyRevealed) {
                      newWord += "-"
                    } else {
                      newWord += String(hint[i])
                      revealed += String(hint[i])
                      alreadyRevealed = true
                    }
                  } else {
                    newWord += String(hint[i])
                  }
                }
                word = newWord
                print("Hint: \(hint) | Revealed: \(revealed)")
              }
            }
          )
          
          ButtonOutline(
            text: "Reveal",
            color: Color.customGrey,
            action: {
              let revealedList = appData.currPuzzle.words
              expandGuesses(revealedList)
            }
          )
        }
        .frame(height: 45)
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .onAppear {
      // deleteHistory(appData: appData, puzzleId: 2064)
      // deleteAllHistories(appData: appData)
      if let saved = appData.history.first(where: { $0.puzzleId == Int32(appData.puzzleId) }) {
        self.guessedList = saved.guessedList as? [String] ?? []
        self.progress = saved.progress
        if(guessedList.count == 0) {
          self.guessed = "Your words..."
        } else {
          self.guessed = guessedList.reversed().joined(separator: ", ")
        }
        print("Already guessed (\(Int(progress)) pts): \(guessedList)")
        if let lastModified = saved.lastModified {
          print("Last modified: \(lastModified.formatted(.iso8601.year().month().day()))")
        }
      }
    }
  }
}
