// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct BookListView: View {
    @State var oo = BookListOO()
    
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
    BookListView(oo: MockBookListOO()) // Pass in the mock
}

// Observable Object

@Observable
class BookListOO {
    var data: [BooksDO] = []
    
    func fetch() {
        // Call API
    }
}

class MockBookListOO: BookListOO {
    override func fetch() {
        // Use mock data while creating the view
        data = [BooksDO(name: "SwiftUI Views Mastery"),
                BooksDO(name: "SwiftUI Animations Mastery"),
                BooksDO(name: "Combine Mastery in SwiftUI"),
                BooksDO(name: "Core Data Mastery in SwiftUI"),
                BooksDO(name: "SwiftData Mastery in SwiftUI"),
                BooksDO(name: "Working with Data in SwiftUI")]
    }
}
