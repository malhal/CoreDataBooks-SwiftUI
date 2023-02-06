//
//  AddView.swift
//  CoreDataBooks
//
//  Created by Malcolm Hall on 06/02/2023.
//

import SwiftUI
import CoreData

struct AddConfig: Identifiable {
    var id: NSManagedObjectContext {
        managedObjectContext
    }
    
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
}

struct BookForm: View {
    @ObservedObject var book: Book
    let message: String
    
    var body: some View {
        Form {
            Section{
                LabeledContent {
                    TextField("Title", text: Binding($book.title)!, prompt: Text("e.g. Great Expectations"))
                        .textContentType(.name)
                        .foregroundColor(.accentColor)
                } label: {
                    Text("Title")
                    //  .bold()
                }
                
                LabeledContent {
                    TextField("Author", text: Binding($book.author)!, prompt: Text("e.g. Charles Dickens"))
                        .textContentType(.name)
                        .foregroundColor(.accentColor)
                    
                } label: {
                    Text("Author")
                    //   .bold()
                    
                }
                // LabeledContent("Copyright") {
                DatePicker(selection: Binding($book.copyright)!, displayedComponents: [.date]) {
                    Text("Copyright")
                    //   .bold()
                }
                
                //   }
            } footer: {
                Text(message)
                    .foregroundColor(.red)
            }
            .autocorrectionDisabled(true)
            .multilineTextAlignment(.trailing)
        }
    }
}

struct EditBookView: View {
    //@Binding var config: AddConfig
    @ObservedObject var book: Book
    @Environment(\.dismiss) var dismiss
    let saveAction: (() -> Void)
    @Environment(\.managedObjectContext) private var addingContext
    @State var message = ""
    
    var body: some View {
        NavigationView {
            BookForm(book: book, message: message)
            
            .navigationTitle("New Book")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        //   config.cancel()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button( "Save") {
                        //   config.cancel()
                        do {
                            try addingContext.save()
                            saveAction()
                            //dismiss()
                            message = ""
                        }
                        catch {
                            // Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            //let nsError = error as NSError
                            //fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            message = error.localizedDescription
                        }
                        
                        
                    }
                }
            }
        }
    }
}



//struct AddView_Previews: PreviewProvider {
//    
//    struct AddViewContainer: View {
//        @State var config = AddConfig()
//        
//        var body: some View {
//            AddView(config: $config)
//        }
//    }
//    
//    static var previews: some View {
//        AddViewContainer()
//    }
//}
