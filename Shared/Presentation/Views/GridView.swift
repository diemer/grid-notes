import SwiftUI

struct GridView: View {
 
  @ObservedObject var viewModel: GridView.ViewModel = .init()
  
  @State var isDragging = false
  @State private var startLocation: CGPoint?
  @State private var endLocation: CGPoint?
  let gridWidth = 10.0
  let outerPadding = 20.0
  
  var drag: some Gesture {
    DragGesture()
      .onChanged { value in
        if !self.isDragging {
          self.startLocation = CGPoint(
            x: CGFloat.round(value.location.x, toNearest: gridWidth),
            y: CGFloat.round(value.location.y, toNearest: gridWidth)
          )
        }
        self.isDragging = true
        self.endLocation = value.location
        self.endLocation = CGPoint(
          x: CGFloat.round(value.location.x, toNearest: gridWidth),
          y: CGFloat.round(value.location.y, toNearest: gridWidth)
        )
      }
      .onEnded { value in
        self.isDragging = false
        self.endLocation = CGPoint(
          x: CGFloat.round(value.location.x, toNearest: gridWidth),
          y: CGFloat.round(value.location.y, toNearest: gridWidth)
        )
        if let startLocation = startLocation, let endLocation = endLocation {
          let width = abs(endLocation.x - startLocation.x)
          let height = abs(endLocation.y - startLocation.y)
          let xPos = (startLocation.x < endLocation.x ? startLocation.x : endLocation.x)
          let yPos = (startLocation.y < endLocation.y ? startLocation.y : endLocation.y)
          let note = Note(width: width, height: height, position: CGPoint(x: xPos, y: yPos))
          viewModel.addNote(note)
        }
        startLocation = nil
        endLocation = nil
      }
  }

  @ViewBuilder
  func dotView(bounds: CGSize) -> some View {
    var point = CGPoint(x: 0, y: 0)
    Path { dotPath in
      dotPath.move(to: point)
      while point.x < (bounds.width - outerPadding * 2) {
        while point.y < (bounds.height - outerPadding * 2) {
          dotPath.move(to: point)
          dotPath.addArc(center: point, radius: 1, startAngle: .degrees(0), endAngle: .degrees(.pi * 2), clockwise: true)
          point.y = point.y + gridWidth
        }
        point.x = point.x + gridWidth
        point.y = 0
      }
    }
  }
  
  var body: some View {
    GeometryReader { proxy in
      ZStack {
        Rectangle()
          .fill(Color.black)
        
        dotView(bounds: proxy.size)
          .foregroundColor(Color.white.opacity(0.2))
          .padding(outerPadding)
        
        if let startLocation = startLocation,
           let endLocation = endLocation {
          if (isDragging) {
            PreviewNoteView(startLocation: startLocation, endLocation: endLocation)
          }
        }
        ForEach(Array(viewModel.notes.enumerated()), id: \.element) { index, note in
          NoteView(
            note: note,
            zIndex: Double(index),
            deleteCompletion: { noteId in
              viewModel.deleteNote(with: noteId)
            },
            updateTextCompletion: { note in
              viewModel.updateNote(note)
            },
            dragCompletion: { note in
              viewModel.updateNote(note)
            }
          )
        }
      }
      .gesture(drag)
    }
  }
}

struct GridView_Previews: PreviewProvider {
  static var previews: some View {
    GridView()
  }
}
