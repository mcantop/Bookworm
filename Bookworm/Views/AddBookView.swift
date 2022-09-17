//
//  AddBookView.swift
//  Bookworm
//
//  Created by Maciej on 17/09/2022.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Mystery"
    @State private var review = ""
    @State private var rating = 3
    @State private var errorMessage = ""
    @State private var showAlert = false
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var disableForm: Bool {
        errorMessage += { title.count < 2 ? "Title is too short. \n" : "" }()
        errorMessage += { author.count < 2 ? "Author is too short. \n" : "" }()
        errorMessage += { review.count < 10 ? "Review is too short." : "" }()

        return title.count < 2 || author.count < 2 || review.count < 10
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        if disableForm {
                            showAlert.toggle()
                        } else {
                            let newBook = Book(context: moc)
                            newBook.id = UUID()
                            newBook.title = title
                            newBook.author = author
                            newBook.genre = genre
                            newBook.review = review
                            newBook.rating = Int16(rating)
                            newBook.date = Date.now
                            
                            try? moc.save()
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Add Book")
            .alert("Error", isPresented: $showAlert) {
                Button("Close", role: .cancel) {
                    errorMessage = ""
                }
            } message: {
                Text(errorMessage)
            }
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
