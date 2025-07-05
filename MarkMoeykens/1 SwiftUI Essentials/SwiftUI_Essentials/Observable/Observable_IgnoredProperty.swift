// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

// View
import SwiftUI

struct Observable_IgnoredPropertyView: View {
    @State private var oo = Observable_IgnoredPropertyOO()
    
    var body: some View {
        List {
            Section {
                ForEach(oo.data, id: \.self) { datum in
                    Text(datum)
                }
            } header: {
                Text(oo.listName)
            } footer: {
                Text(oo.footer)
            }
            
            Section {
                Button("Update Data") {
                    oo.makeViewUpdates()
                }
                Button("Update Just the Footer") {
                    oo.makeJustFooterUpdate()
                }
            }
        }
        .font(.title)
        .headerProminence(.increased)
    }
}

#Preview {
    Observable_IgnoredPropertyView()
}

// Observable Object -----------------------------------------------

@Observable
class Observable_IgnoredPropertyOO {
    var data = ["Book 1", "Book 2", "Book 3"]
    var listName = "Book List"
    
    // Ignore changes
    @ObservationIgnored var footer = "3 books"
    
    func makeViewUpdates() {
        data.append("Book \(data.count + 1)")
        footer = "\(data.count) books"
    }
    
    func makeJustFooterUpdate() {
        footer = "Read all \(data.count) books!"
    }
}
