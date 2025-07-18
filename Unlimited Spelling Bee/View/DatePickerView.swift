import SwiftUI

struct DatePickerView: View {
  @EnvironmentObject var appData: AppData
  @State var year: Int = 2023

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .topLeading) {
        Color.customWhite.ignoresSafeArea()

        VStack(alignment: .leading, spacing: 0) {
          // Header
          HStack {
            Image(systemName: "chevron.left")
              .foregroundColor(.black)
              .padding(.leading, 20)
              .padding(.vertical, 20)
              .padding(.trailing, 10)
              .bold()
              .font(.title3)
              .onTapGesture { appData.navigate(Views.home) }

            Text("Choose Puzzle")
              .font(.title3)
              .foregroundColor(.black)
          }
          .padding(.bottom, 10)

          // Year Picker
          Color.customYellow
            .overlay(
              HStack {
                Image(systemName: "chevron.left")
                  .foregroundColor(year == appData.minYear ? .customWhite : .black)
                  .font(.title)
                  .bold()
                  .padding(.leading, 10)
                  .onTapGesture {
                    if year > appData.minYear { year -= 1 }
                  }

                Spacer()
                Text(String(year)).font(.title).bold()
                Spacer()

                Image(systemName: "chevron.right")
                  .foregroundColor(year == appData.maxYear ? .customWhite : .black)
                  .font(.title)
                  .bold()
                  .padding(.trailing, 10)
                  .onTapGesture {
                    if year < appData.maxYear { year += 1 }
                  }
              }
            )
            .cornerRadius(10)
            .frame(width: geometry.size.width - 60, height: 60)
            .padding(.horizontal, 30)
            .padding(.bottom, 20)

          // Scrollable Month Picker
          ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 30) {
              ForEach(1...12, id: \.self) { monthNum in
                MonthSectionView(monthNum: monthNum, year: year, containerWidth: geometry.size.width - 80, appData: appData)
              }
            }
            .padding([.leading, .trailing, .bottom], 20)
          }
          .frame(
            width: geometry.size.width - 60,
            height: geometry.size.height - 160
          )
          .background(Color.customWhite)
          .clipShape(
            UnevenRoundedRectangle(cornerRadii: .init(
              topLeading: 0,
              bottomLeading: 10,
              bottomTrailing: 10,
              topTrailing: 0
            ))
          )
          .padding(.horizontal, 30)
        }
      }
    }
  }
}

struct MonthSectionView: View {
  let monthNum: Int
  let year: Int
  let containerWidth: CGFloat
  let appData: AppData

  var body: some View {
    let monthName = DateFormatter().monthSymbols[monthNum - 1]
    let puzzles = puzzleIDs(month: monthNum, year: year, puzzles: appData.puzzles)
    let tileSize = (containerWidth - 30) / 4

    VStack(alignment: .leading, spacing: 10) {
      Text(monthName)
        .font(.headline)
        .padding(.leading, 10)

      LazyVGrid(columns: Array(repeating: GridItem(.fixed(tileSize), spacing: 10), count: 4), spacing: 10) {
        ForEach(puzzles, id: \.self) { puzzleID in
          let (day, _, _) = idToDate(id: puzzleID)!
          TileView(day: day, puzzleID: puzzleID, size: tileSize)
        }
      }
    }
  }
}


struct TileView: View {
  let day: Int
  let puzzleID: Int
  let size: CGFloat
  @EnvironmentObject var appData: AppData

  var body: some View {
    Text(String(day))
      .foregroundColor(Color.black)
      .frame(width: size, height: size)
      .background(RoundedRectangle(cornerRadius: 10).fill(Color.customGrey))
      .foregroundColor(.customWhite)
      .onTapGesture {
        appData.puzzleId = puzzleID
        appData.currPuzzle = appData.puzzles[puzzleID]!
        appData.letterCenter = appData.currPuzzle.center
        let outerLetters = appData.currPuzzle.letters.filter { $0 != appData.currPuzzle.center }
        appData.letterOuter1 = outerLetters[0]
        appData.letterOuter2 = outerLetters[1]
        appData.letterOuter3 = outerLetters[2]
        appData.letterOuter4 = outerLetters[3]
        appData.letterOuter5 = outerLetters[4]
        appData.letterOuter6 = outerLetters[5]
        appData.navigate(Views.puzzle)
      }
  }
}
