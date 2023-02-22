//
//  ContentView.swift
//  CoreDataBooks
//
//  Created by Malcolm Hall on 06/02/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @SectionedFetchRequest(sectionIdentifier: \.author!, sortDescriptors: [SortDescriptor(\.author), SortDescriptor(\.title)])
    private var sections: SectionedFetchResults<String, Book>
    
    @State var selection: Book?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(sections) { section in
                    Section(section.id) {
                        ForEach(section) { book in
                            NavigationLink(value: book) {
                                Text(book.title!)
                            }
                        }
                        .onDelete { indexSet in
                            deleteItems(section: section, offsets: indexSet)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .primaryAction) {
                    BookSheetButton()
                }
            }
        } detail: { //  [selection] in
            // bug: in ipad landscape, when the selected item is deleted the selection isn't set to nil and book detail shows a book with empty properties
            if let book = selection {
                BookDetail(book: book)
            }
            else {
                Text("Select a book")
            }
        }
        
    }

    private func deleteItems(section: SectionedFetchResults<String, Book>.Section, offsets: IndexSet) {
        withAnimation {
            
            offsets.map { section[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
