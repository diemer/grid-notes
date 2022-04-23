#if os(macOS)
import Foundation
import AppKit

extension NSTextView {
  open override var frame: CGRect {
    didSet {
      backgroundColor = .clear //<<here clear
      drawsBackground = true
      textContainerInset = NSSize(width: 0, height: 10)
      // Left fragment padding <<< This is what I was looking for
      textContainer?.lineFragmentPadding = 5
    }
    
  }
}
#endif
