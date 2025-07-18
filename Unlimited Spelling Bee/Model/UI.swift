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
  static let customDarkGrey = Color(UIColor(rgb: 0xC4C4C4))
  static let customLightGrey = Color(UIColor(rgb: 0xF0F0F0))
  static let customYellow = Color(UIColor(rgb: 0xF7DA20))
  static let customWhite = Color(UIColor(rgb: 0xFAFAFA))
}

// Define reusable button styles - ghost button with text
struct ButtonOutline: View {
  let text: String
  let color: Color
  var action: (() -> Void)
  
  var body: some View {
    Button(action: action) {
      Text(text)
//        .padding([.top, .bottom], 6)
        .padding([.leading, .trailing], 20)
        .foregroundColor(Color.black)
    }
    .tint(color)
    .font(.subheadline)
    .cornerRadius(50)
    .overlay(
      RoundedRectangle(cornerRadius: 50)
        .stroke(color, lineWidth: 2)
        .frame(height: UIScreen.main.bounds.width / 8.8)
    )
  }
}

// Define reusable button styles - ghost button with symbol
struct ButtonOutlineSymbol: View {
  let symbol: String
  let color: Color
  var action: (() -> Void)
  
  var body: some View {
    Button(action: action) {
      Image(systemName: symbol)
        .padding([.leading, .trailing], 20)
        .foregroundColor(Color.black)
    }
    .tint(color)
    .font(.subheadline)
    .cornerRadius(50)
    .overlay(
      RoundedRectangle(cornerRadius: 50)
        .stroke(color, lineWidth: 2)
        .frame(height: UIScreen.main.bounds.width / 8.8)
    )
  }
}

// Define reusable button styles - solid-color button with text
struct ButtonSolid: View {
  let text: String
  let color: Color
  var action: (() -> Void)
  
  var body: some View {
    Button(action: action) {
      Text(text)
        .padding(6)
        .frame(width: UIScreen.main.bounds.width / 2)
    }
    .tint(color)
    .font(.title2)
    .cornerRadius(50)
    .buttonStyle(.borderedProminent)
  }
}


// Defined reusable hexagon for board
struct HexagonShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = min(rect.width, rect.height) / 2
    
    // Calculate the hexagon's vertices
    let corners = (0..<6).map { i -> CGPoint in
      let angle = CGFloat.pi / 3 * CGFloat(i) // Angle for each vertex
      let x = center.x + radius * cos(angle)
      let y = center.y + radius * sin(angle)
      return CGPoint(x: x, y: y)
    }
    
    // Draw the path
    path.move(to: corners[0])
    for i in 1..<corners.count {
      path.addLine(to: corners[i])
    }
    path.closeSubpath()
    return path
  }
}

struct Tile: View {
  let size: CGFloat
  let color: Color
  @Binding var letter: String
  
  var body: some View {
    ZStack {
      HexagonShape()
        .fill(color)
        .frame(width: size, height: size)
        .padding(-0.03 * size)
      
      Text(letter)
        .foregroundColor(Color.black)
        .bold()
        .font(.title)
        .disabled(true)
    }
  }
}

// Custom round corners
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

