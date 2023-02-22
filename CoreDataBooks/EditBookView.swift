//
//  AddView.swift
//  CoreDataBooks
//
//  Created by Malcolm Hall on 06/02/2023.
//

import SwiftUI
import CoreData

// https://forums.swift.org/t/help-me-with-writing-generic-func-on-extension-swiftui-binding/57698
public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

struct EditBookView: View {
    @ObservedObject var book: Book
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var message = ""
    
    var body: some View {
        Form {
            Section{
                LabeledContent {
                    TextField("Title",
                              text: $book.title ?? "",
                              prompt: Text("e.g. Great Expectations"))
                    .textContentType(.name)
                } label: {
                    Text("Title")
                }
                
                LabeledContent {
                    TextField("Author", text: $book.author ?? "", prompt: Text("e.g. Charles Dickens"))
                        .textContentType(.name)
                    
                } label: {
                    Text("Author")
                }
                
                LabeledContent {
                    Picker("", selection: Binding<Int>(get: {
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.year], from: book.copyright ?? Date())
                        let year = components.year
                        return year!
                    }, set: { v in
                        let calendar = Calendar.current
                        let components = DateComponents(calendar: calendar, year: v)
                        book.copyright = components.date
                    })) {
                        ForEach(1800..<2050) { i in // todo allow any year.
                            Text(String(i)).tag(i)
                        }
                    }
                    .pickerStyle(.wheel)
                } label: {
                    Text("Copyright")
                }
            } footer: {
                HStack {
                    Spacer()
                    Text(message)
                        .foregroundColor(.red)
                    Spacer()
                }
                   
            }
            .autocorrectionDisabled(true)
            .multilineTextAlignment(.trailing)
        }
        
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    //config.cancel()
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button( "Save") {
                    do {
                        try viewContext.save()
                        //saveAction()
                        dismiss()
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



//struct EditBookView_Previews: PreviewProvider {
//    
//    struct AddViewContainer: View {
//        //@State var config = AddConfig()
//        
//        var body: some View {
//            EditBookView()
//        }
//    }
//    
//    static var previews: some View {
//        AddViewContainer()
//    }
//}
