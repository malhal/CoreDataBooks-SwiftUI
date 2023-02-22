//
//  BookSheetButton.swift
//  CoreDataBooks
//
//  Created by Malcolm Hall on 14/02/2023.
//

import SwiftUI
import CoreData

struct SheetConfig: Identifiable {
    var id: NSManagedObjectContext {
        context
    }
    
    var context: NSManagedObjectContext
    var book: Book
    
    init(parentContext: NSManagedObjectContext, existingBookID: NSManagedObjectID? = nil) {
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = parentContext
        if let existingBookID {
            book = context.object(with: existingBookID) as! Book
        }else {
            book = Book(context: context)
        }
    }
}
    
struct BookSheetButton: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var sheetConfig: SheetConfig?
    let existingBookID: NSManagedObjectID?
    
    // I think this init is required for an optional property that defaults to nil
    init(existingBookID: NSManagedObjectID? = nil) {
        self.existingBookID = existingBookID
    }
    
    var isAddingNewBook: Bool {
        existingBookID == nil
    }
    
    var body: some View {
        Button {
            sheetConfig = SheetConfig(parentContext: viewContext, existingBookID: existingBookID)
        } label: {
            if isAddingNewBook {
                Label("Add", systemImage: "plus")
            }
            else{
                Text("Edit")
            }
        }
        .sheet(item: $sheetConfig, onDismiss: {
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
        }, content: { config in
            NavigationStack {
                EditBookView(book: config.book)
                    .navigationTitle(isAddingNewBook ? "Add New Book" : "Edit Book")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .environment(\.managedObjectContext, config.context)    
        })
    }
}
