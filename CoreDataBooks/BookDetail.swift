//
//  EditView.swift
//  CoreDataBooks
//
//  Created by Malcolm Hall on 06/02/2023.
//

import SwiftUI
import CoreData

struct EditorConfig {

    var managedObjectContext: NSManagedObjectContext
    var book: Book
    
    init(parentContext: NSManagedObjectContext, existingBookID: NSManagedObjectID? = nil) {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.parent = parentContext
        
        let book: Book
        if let existingBookID {
            book = moc.object(with: existingBookID) as! Book
        }
        else {
            book = Book(context: moc)
        }
        
        self.managedObjectContext = moc
        self.book = book
    }
    
    func delete() {
        managedObjectContext.delete(book)
    }
}


struct BookDetail: View {
    @ObservedObject var book: Book
    
    var body: some View {
        Form {
            LabeledContent {
                Text(book.title ?? "")
            } label: {
                Text("Title")
            }
            
            LabeledContent {
                Text(book.author ?? "")
            } label: {
                Text("Author")
            }
            
            LabeledContent {
                Text(book.copyright ?? Date(), format:.dateTime.year())
            } label: {
                Text("Copyright")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                BookSheetButton(existingBookID: book.objectID)
            }
        }
    }
}
