//
//  NotesUseCase.swift
//  Grid Notes
//
//  Created by Dan Diemer on 4/22/22.
//

import Foundation

struct NotesUseCase {
  let repository: NotesRepository
  
  func getNotes() {
    repository.getNotes()
  }
  
  func addNote(_ note: Note) {
    repository.addNote(note)
  }
  
  func deleteNote(with uuid: UUID) {
    repository.deleteNote(with: uuid)
  }
  
  func updateNote(_ note: Note) {
    repository.updateNote(note)
  }
}
