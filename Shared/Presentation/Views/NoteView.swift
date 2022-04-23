import SwiftUI


struct NoteView: View {
  @State var note: Note
  var zIndex: Double = 0
  private var position: CGPoint { note.position }
  private var width: CGFloat {
    note.width
  }
  private var height: CGFloat {
    note.height
  }
  @State private var offset = CGSize.zero
  @State private var isDragging = false
  @State var textContent: String = ""
  @FocusState private var isFocused: Bool
  var deleteCompletion: ((UUID) -> Void)? = nil
  var updateTextCompletion: ((Note) -> Void)? = nil
  var dragCompletion: ((Note) -> Void)? = nil
  
  var xPos: CGFloat {
    position.x + width / 2
  }
  var yPos: CGFloat {
    position.y + height / 2
  }
  let headerHeight: CGFloat = 20.0
  var headerYPos: CGFloat {
    headerHeight / 2
  }
  let lineWidth = 1.0
  
  let gridWidth = 10.0
  
  var drag: some Gesture {
    DragGesture()
      .onChanged { value in
        self.isDragging = true
        offset = CGSize(width: CGFloat.round(value.translation.width, toNearest: gridWidth), height: CGFloat.round(value.translation.height, toNearest: gridWidth))
      }
      .onEnded { value in
        self.isDragging = false
        note.content = textContent
        note.position = CGPoint(x: position.x + offset.width, y: position.y + offset.height)
        offset = .zero
        dragCompletion?(note)
      }
  }
  @ViewBuilder
  fileprivate func textEditor() -> some View {
    let editorWidth = width - (lineWidth * 2)
    let editorHeight = (height - headerHeight) - (lineWidth * 2)
    VStack {
      TextEditor(text: $textContent)
        .font(Font.custom(Fonts.courierPrime.rawValue, size: 14))
        .focused($isFocused)
        .onChange(of: isFocused) { isFocused in
          if isFocused {
            note.content = textContent
            updateTextCompletion?(note)
          }
      }
    }
    .background(Color.black)
    .foregroundColor(.white)
    .frame(width: editorWidth, height: editorHeight)
    .position(x: (editorWidth + lineWidth) / 2, y: (editorHeight + headerHeight + lineWidth) / 2 + (headerHeight / 2))
  }
  
  var body: some View {

    if isDragging {
      Rectangle()
        .fill(.white.opacity(0.1))
        .frame(width: width, height: height)
        .position(x: xPos + (gridWidth / 2), y: yPos + (gridWidth / 2))
        .offset(CGSize(width: offset.width + (gridWidth / 2), height: offset.height + (gridWidth / 2)))
    }
    Rectangle()
      .fill(.black)
      .frame(width: width, height: height)
      .overlay(
        ZStack {
          Rectangle()
            .fill(isDragging ? .white.opacity(0.1) : .black)
            .frame(width: width, height: headerHeight)
            .position(x: width / 2, y: headerYPos)
            ZStack {
              Rectangle()
                .stroke(.white, lineWidth: lineWidth)
              Path { path in
                path.move(to: CGPoint(x: 0, y: headerHeight))
                path.addLine(to: CGPoint(x: width, y: headerHeight))
              }
              .stroke(.white, lineWidth: lineWidth)
              Image(systemName: "xmark")
                .foregroundColor(.white)
                .position(x: headerHeight / 2, y: headerHeight / 2)
                .onTapGesture {
                  deleteCompletion?(note.id)
                }
              textEditor()
              
            }
        }
          .frame(width: width, height: height)
      
      )
      .position(x: xPos, y: yPos)
      .offset(offset)
      .gesture(drag)
      .zIndex(isDragging ? 1000 : zIndex)
      .onAppear {
        textContent = note.content
      }
  }
}


struct NoteView_Previews: PreviewProvider {
  static var previews: some View {
    NoteView(note: .init(width: 200, height: 400, position: .zero), zIndex: 0)
      .previewLayout(.sizeThatFits)
  }
}
