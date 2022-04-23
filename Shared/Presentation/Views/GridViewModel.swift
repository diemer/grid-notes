//
//  NoteViewModel.swift
//  Grid Notes
//
//  Created by Dan Diemer on 4/22/22.
//

import Foundation
import Combine

extension GridView {
  class ViewModel: ObservableObject {
    @Published var notes: [Note] = []
    let repository: NotesRepository
    let useCase: NotesUseCase
    
    var cancellables: [AnyCancellable] = []
    
    init(repository: NotesRepository = RealNotesRepository()) {
      self.repository = repository
      self.useCase = .init(repository: self.repository)
      repository.notesPublisher.sink { [weak self] notes in
        self?.notes = notes
        self?.objectWillChange.send()
      }.store(in: &cancellables)
    }
    
    func getNotes() {
      useCase.getNotes()
    }
    
    func addNote(_ note: Note) {
      useCase.addNote(note)
    }
    
    func updateNote(_ note: Note) {
      useCase.updateNote(note)
    }
    
    func deleteNote(with uuid: UUID) {
      useCase.deleteNote(with: uuid)
    }
    
  }
}
