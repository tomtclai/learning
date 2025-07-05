// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Maintainability_Property: View {
    @State var oo = BookListOO()
    
    var body: some View {
        List {
            Section {
                ForEach(oo.data) { datum in
                    GroupBox {
                        VStack {
                            Image(systemName: "book.pages")
                            Text(datum.name)
                                .font(.title)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
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
    Maintainability_Property(oo: MockBookListOO())
}
