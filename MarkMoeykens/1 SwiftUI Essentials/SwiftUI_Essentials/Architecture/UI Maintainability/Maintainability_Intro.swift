// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Maintainability_Intro: View {
    @State var oo = BookListOO()
    
    var body: some View {
        List {
            Section {
                ForEach(oo.data) { datum in
                    BookRowView(bookName: datum.name)
                    .listRowSeparator(.hidden)
                }
            } header: {
                sectionHeaderView
            }
        }
        .headerProminence(.increased)
        .listStyle(.plain)
        .onAppear {
            oo.fetch()
        }
    }
    var sectionHeaderView: some View {
        HStack {
            Label("Books (\(oo.data.count))", systemImage: "books.vertical.fill")
            Spacer()
            Button("Add", systemImage: "plus") {
                
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    Maintainability_Intro(oo: MockBookListOO())
}
