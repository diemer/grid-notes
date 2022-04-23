//
//  PreviewNoteView.swift
//  Grid Notes (iOS)
//
//  Created by Dan Diemer on 4/16/22.
//

import SwiftUI

struct PreviewNoteView: View {
  var startLocation: CGPoint
  var endLocation: CGPoint
  var fillColor: Color = .white
  
  var body: some View {
    Path { path in
      path.move(to: CGPoint(x: startLocation.x, y: startLocation.y))
      path.addLine(to: CGPoint(x: endLocation.x, y: startLocation.y))
      path.addLine(to: CGPoint(x: endLocation.x, y: endLocation.y))
      path.addLine(to: CGPoint(x: startLocation.x, y: endLocation.y))
      path.addLine(to: CGPoint(x: startLocation.x, y: startLocation.y))
    }
    .fill(fillColor.opacity(0.2))
  }
}
