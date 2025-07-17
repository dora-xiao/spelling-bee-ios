import Foundation
import UIKit
import SwiftUI

// Extend UIColor to accept hexcodes
extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }
}

// Use the extended UIColor to define custom colors
extension Color {
  static let customGrey = Color(UIColor(rgb: 0xE6E6E6))
  static let customYellow = Color(UIColor(rgb: 0xF7DA20))
}

// Define reusable button style
struct BubbleButton: View {
  let text: String
  let color: Color
  var action: (() -> Void)
  var body: some View {
    Button(action: action) {
      Text(text)
        .frame(width: UIScreen.main.bounds.width * 0.5)
        .padding(6)
    }
    .buttonStyle(.borderedProminent)
    .tint(color)
    .font(.title2)
    .cornerRadius(50)
  }
}
