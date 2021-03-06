//
//  HomeView.swift
//  Bookworm
//
//  Created by Mehmet Ateş on 18.05.2022.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title),
                                    SortDescriptor(\.author)]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                HStack{
                                    Text(book.title ?? "Unknown Title")
                                        .font(.headline)
                                    GenreTypeLabel(type: book.genre ?? "Unknow")
                                }
                                
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                        }
                    }
                }.onDelete(perform: deleteBooks)
            }.navigationTitle("Bookworm")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddScreen.toggle()
                        } label: {
                            Label("Add Book", systemImage: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView()
                }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let book = books[offset]
            
            // delete it from the context
            moc.delete(book)
        }
        
        // save the context
        try? moc.save()
    }
    

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        GenreTypeLabel(type: "Fantasy")
    }
}


struct GenreTypeLabel: View{
    private let typesColors = [
        "Fantasy": Color.green,
        "Horror": Color.gray,
        "Kids": Color.blue,
        "Mystery": Color.purple,
        "Poetry": Color.pink,
        "Romance": Color.red,
        "Thriller": Color.orange,
        "Unknow": Color.secondary
    ]

    var type: String
    
    
    var body: some View{
        VStack{
            Text(type)
                .font(.caption2)
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke())
                .foregroundColor(typesColors[type])
        }
    }
}
