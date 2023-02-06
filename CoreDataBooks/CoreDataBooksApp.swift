//
//  CoreDataBooksApp.swift
//  CoreDataBooks
//
//  Created by Malcolm Hall on 06/02/2023.
//

import SwiftUI

@main
struct CoreDataBooksApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
