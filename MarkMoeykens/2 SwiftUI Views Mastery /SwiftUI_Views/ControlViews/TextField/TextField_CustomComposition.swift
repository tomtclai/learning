//  Copyright © 2019 Mark Moeykens. All rights reserved.

import SwiftUI

struct TextField_CustomComposition: View {
    @State private var textFieldData = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("TextField")
                .font(.largeTitle)
            
            Text("Custom Composition")
                .font(.title)
                .foregroundStyle(.gray)
            
            Text("Compose your own custom TextField by piecing together other views.")
                .font(.title)
                .frame(maxWidth: .infinity)
                .padding().layoutPriority(1)
                .background(Color.orange)
            
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.gray)
                    TextField("first name", text: $textFieldData)
                    Image(systemName: "slider.horizontal.3")
                }
                Divider()
            }
            .padding()
            
            HStack {
                Image(systemName: "envelope")
                    .foregroundStyle(.gray).font(.headline)
                TextField("email address", text: $textFieldData)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            .padding()
            
            HStack {
                TextField("country", text: $textFieldData)
                Button(action: {}) {
                    Image(systemName: "chevron.right").padding(.horizontal)
                }
                .tint(.orange)
            }
            .padding()
            .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            .padding()
        }
    }
}

struct TextField_CustomComposition_Previews: PreviewProvider {
    static var previews: some View {
        TextField_CustomComposition()
    }
}
