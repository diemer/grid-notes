import Foundation
import CoreGraphics

struct Note: Hashable {
  var width: CGFloat
  var height: CGFloat
  var position: CGPoint
  var id = UUID()
  var content: String = ""
  func hash(into hasher: inout Hasher) {
      hasher.combine(id)
  }
}
