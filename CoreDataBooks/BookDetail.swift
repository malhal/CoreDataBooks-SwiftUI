//
//  EditView.swift
//  CoreDataBooks
//
//  Created by Malcolm Hall on 06/02/2023.
//

import SwiftUI
import CoreData


struct EditBookButton: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var addConfig: AddConfig?
    let existingBookID: NSManagedObjectID?
    
    var body: some View {
        Button {
            addConfig = AddConfig(parentContext: viewContext, existingBookID: existingBookID)
        } label: {
            if existingBookID == nil {
                Label("Add Item", systemImage: "plus")
            }
            else{
                Text("Edit")
            }
        }
        .sheet(item: $addConfig, onDismiss: {
            print("Dismiss")
        }, content: { item in
            EditBookView(book: item.book) {
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                addConfig = nil
            }
            .environment(\.managedObjectContext, item.managedObjectContext)
            
        })
    }
}

struct BookDetail: View {
   
    @ObservedObject var book: Book
 //   @Environment(\.editMode) var editMode
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(book.title!)
                .font(.title)
            Text(book.author!)
                .font(.title2)
            Text(book.copyright!, format:.dateTime.year())
                .font(.title3)
            Spacer()
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditBookButton(existingBookID: book.objectID)
            }
            
            
        }
    }
}

