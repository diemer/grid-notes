//
//  NotesDataSource.swift
//  Grid Notes
//
//  Created by Dan Diemer on 4/22/22.
//

import Foundation
import CoreData

struct NotesDataSource {
  let managedObjectContext = PersistenceController.shared.container.viewContext
  
  func getNotes() -> [CDNote] {
    let request = CDNote.lastUpdatedFetchRequest()
    var notes: [CDNote] = []
    do {
      notes = try managedObjectContext.fetch(request)
    } catch {
      print(error)
    }
    return notes
  }
  
  func addNote(
    width: Double,
    height: Double,
    positionX: Double,
    positionY: Double,
    content: String,
    id: String
  ) {
    do {
      let note = CDNote.init(context: managedObjectContext)
      note.width = width
      note.height = height
      note.positionX = positionX
      note.positionY = positionY
      note.content = content
      note.id = id
      note.modifiedAt = Date()
      try managedObjectContext.save()
    } catch {
      print("Error saving note: \(error)")
    }
  }
  
  func updateNote(
    width: Double,
    height: Double,
    positionX: Double,
    positionY: Double,
    content: String,
    with id: String
  ) {
    do {
      let request = CDNote.findByIdFetchRequest(id)
      guard let note = try managedObjectContext.fetch(request).first else { return }
      note.width = width
      note.height = height
      note.positionX = positionX
      note.positionY = positionY
      note.content = content
      note.modifiedAt = Date()
      try managedObjectContext.save()
    } catch {
      print("Error updating note: \(error)")
    }
  }
  
  func deleteNote(with id: String) {
    do {
      let request = CDNote.findByIdFetchRequest(id)
      guard let note = try managedObjectContext.fetch(request).first else { return }
      managedObjectContext.delete(note)
      try managedObjectContext.save()
    } catch {
      print("Error deleting note: \(error)")
    }
  }
}
