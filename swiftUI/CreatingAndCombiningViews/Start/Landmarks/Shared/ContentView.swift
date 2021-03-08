//
//  ContentView.swift
//  Shared
//
//  Created by Tom Lai on 11/20/20.
//

import SwiftUI

struct ContentView: View {
    let imageYOffset: CGFloat = -130
    
    var body: some View {
        VStack {
            MapView().ignoresSafeArea(edges: .top).frame(height: 300)
            
            
            CircleImage()
                .offset(y: imageYOffset)
                .padding(.bottom, imageYOffset)
            
            VStack(alignment: .leading) {
                Text("Turtle Rock")
                    .font(.title)
                HStack {
                    Text("Joshua Tree National Park")
                        .font(.subheadline)
                    Spacer()
                    Text("California")
                        .font(.subheadline)
                }
                
                Divider()
                
                Text("About Turtle Rock").font(.title2)
                Text("Descriptive text goes here")
            }.padding()
            
            Spacer()
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
