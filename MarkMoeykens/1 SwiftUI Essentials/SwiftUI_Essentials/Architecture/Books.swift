// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

// View
import SwiftUI

struct BooksView: View {
    @State private var oo = BooksOO()
    
    var body: some View {
        List(oo.data) { datum in
            Text(datum.name)
        }
        .font(.title)
        .onAppear {
            oo.fetch()
        }
    }
}

#Preview {
    BooksView()
}

// Observable Object
import SwiftUI

@Observable
class BooksOO {
    var data: [BooksDO] = []
    
    func fetch() {
        data = [BooksDO(name: "SwiftUI Views Mastery"),
                BooksDO(name: "SwiftUI Animations Mastery"),
                BooksDO(name: "Combine Mastery in SwiftUI"),
                BooksDO(name: "SwiftData Mastery in SwiftUI"),
                BooksDO(name: "Core Data Mastery in SwiftUI"),
                BooksDO(name: "SwiftUI Essentials")]
    }
}

// Data Object
import Foundation

struct BooksDO: Identifiable {
    let id = UUID()
    var name: String
}
