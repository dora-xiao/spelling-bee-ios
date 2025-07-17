import SwiftUI

struct PuzzleView: View {
  @EnvironmentObject var appData : AppData
  let size: CGFloat = 100
  
  var body: some View {
    ZStack {
      Color.customWhite
        .ignoresSafeArea()
      
      HStack(spacing: -0.12 * size) {
        VStack(spacing: 0) {
          Tile(size: size, color: Color.customGrey, letter: appData.letterOuter[0])
          Tile(size: size, color: Color.customGrey, letter: appData.letterOuter[1])
        }
        VStack(spacing: 0) {
          Tile(size: size, color: Color.customGrey, letter: appData.letterOuter[2])
          Tile(size: size, color: Color.customYellow, letter: appData.letterCenter)
          Tile(size: size, color: Color.customGrey, letter: appData.letterOuter[3])
        }
        VStack(spacing: 0) {
          Tile(size: size, color: Color.customGrey, letter: appData.letterOuter[4])
          Tile(size: size, color: Color.customGrey, letter: appData.letterOuter[5])
        }
      }
    }
  }
}
