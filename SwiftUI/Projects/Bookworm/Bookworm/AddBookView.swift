//
//  AddBookView.swift
//  Bookworm
//
//  Created by Mehmet Ateş on 18.05.2022.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var reviewDate = Date.now
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
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
                    DatePicker("Review Date", selection: $reviewDate, displayedComponents: .date)
                }
                
                Section {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(context: moc)
                        validateContent()
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review
                        newBook.reviewDate = reviewDate
                        
                        dismiss()
                        try? moc.save()
                    }
                }
            }
            .navigationTitle("Add Book")
        }
    }
    
    
    func validateContent(){
        if title.isEmpty{
            title = "Unknow"
        }
        
        if author.isEmpty{
            author = "Unknow"
        }
        
        if genre.isEmpty{
            genre = "Fantasy"
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
