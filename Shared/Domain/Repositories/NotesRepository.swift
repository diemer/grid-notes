//
//  NotesRepository.swift
//  Grid Notes
//
//  Created by Dan Diemer on 4/22/22.
//

import Foundation
import CoreGraphics

protocol NotesRepository {
  var notes: [Note] { get }
  var notesPublished: Published<[Note]> { get }
  var notesPublisher: Published<[Note]>.Publisher { get }
  func addNote(_ note: Note)
  func deleteNote(with uuid: UUID)
  func updateNote(_ note: Note)
  func getNotes()
}

class RealNotesRepository: NotesRepository, ObservableObject {
  let dataSource = NotesDataSource.init()
  
  @Published var notes: [Note] = []
  var notesPublished: Published<[Note]> { _notes }
  var notesPublisher: Published<[Note]>.Publisher { $notes }
  
  init() {
    getNotes()
  }
  
  func addNote(_ note: Note) {
    dataSource.addNote(
      width: note.width,
      height: note.height,
      positionX: note.position.x,
      positionY: note.position.y,
      content: note.content,
      id: note.id.uuidString
    )
    afterAction()
  }
  
  func deleteNote(with uuid: UUID) {
    dataSource.deleteNote(with: uuid.uuidString)
    afterAction()
  }
  
  
  func updateNote(_ note: Note) {
    dataSource.updateNote(
      width: note.width,
      height: note.height,
      positionX: note.position.x,
      positionY: note.position.y,
      content: note.content,
      with: note.id.uuidString
    )
    afterAction()
  }
  
  private func afterAction() {
    getNotes()
  }
  
  func getNotes() {
    notes = dataSource.getNotes().map { (item) -> Note in
      Note.init(
        width: item.width,
        height: item.height,
        position: CGPoint(x: item.positionX, y: item.positionY),
        id: .init(uuidString: item.id) ?? .init(),
        content: item.content
      )
    }
//    objectWillChange.send()
  }
}
