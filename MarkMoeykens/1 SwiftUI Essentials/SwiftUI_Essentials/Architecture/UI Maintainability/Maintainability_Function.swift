// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Maintainability_Function: View {
    @State var oo = BookListOO()
    
    var body: some View {
        List {
            Section {
                ForEach(oo.data) { datum in
                    rowView(datum.name)
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
    
    func rowView(_ bookName: String) -> some View {
        GroupBox {
            VStack {
                Image(systemName: "book.pages")
                Text(bookName)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    Maintainability_Function(oo: MockBookListOO())
}
