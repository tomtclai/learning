// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct DismissSearchAppleExample: View {
    @State private var text = ""
    
    var body: some View {
        NavigationStack {
            MyMainList()
               .searchable(text: $text)
        }
    }
}

struct MyMainList: View {
    @State private var isPresented = false
    @Environment(\.isSearching) private var isSearching

    var body: some View {
        VStack {
            Text("isSearching: \(isSearching.description)")
            Text("Main List")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    if isSearching {
                        Button {
                            isPresented = true
                        } label: {
                            Text("Present")
                                .frame(
                                    maxWidth: .infinity,
                                    maxHeight: .infinity
                                )
                                .background()
                        }
                        .sheet(isPresented: $isPresented) {
                            NavigationStack {
                                MyMainListDetailView()
                            }
                        }
                    }
            }
        }
    }
}

struct MyMainListDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dismissSearch) private var dismissSearch

    var body: some View {
        Text("Detail Content")
            .toolbar {
                Button("Add") {
                    dismiss()
                    dismissSearch()
                }
            }
    }
}

struct DismissSearchAppleExample_Previews: PreviewProvider {
    static var previews: some View {
        DismissSearchAppleExample()
    }
}
