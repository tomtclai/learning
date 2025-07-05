// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct List_HeadersAndFooters : View {
    var data = ["Evans", "Lemuel James Guerrero", "Mark", "Durtschi", "Chase", "Rodrigo"]
    var body: some View {
        List {
            Section {
                ForEach(data, id: \.self) { datum in
                    Text(datum)
                }
            } header: {
                Header()
            } footer: {
                Text("7 People on Staff")
            }
        }
    }
}

struct Header: View {
    var body: some View {
        Image("mountains")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .overlay(Text("STAFF")
                        .font(.system(size: 120, design: .serif))
                        .foregroundStyle(.green))
            .padding(.horizontal, -40)
            .padding(.top, -25)
    }
}

struct List_HeadersAndFooters_Previews : PreviewProvider {
    static var previews: some View {
        List_HeadersAndFooters()
            .preferredColorScheme(.dark)
    }
}
