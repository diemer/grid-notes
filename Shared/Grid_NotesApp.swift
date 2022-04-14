//
//  Grid_NotesApp.swift
//  Shared
//
//  Created by Dan Diemer on 4/14/22.
//

import SwiftUI

@main
struct Grid_NotesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
