//  Copyright © 2020 Mark Moeykens. All rights reserved. | @BigMtnStudio

import SwiftUI

struct LazyVStack_Table: View {
    @State private var data = MockData.getProfiles()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(data) { datum in
                        NavigationLink(destination: Text("destination")) {
                            HStack {
                                Image(datum.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                Text(datum.name)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(.plain) // Removes accent color
                    }
                }
            }
            .navigationTitle("People")
        }
    }
}

struct LazyVStack_Table_Previews: PreviewProvider {
    static var previews: some View {
        LazyVStack_Table()
    }
}
