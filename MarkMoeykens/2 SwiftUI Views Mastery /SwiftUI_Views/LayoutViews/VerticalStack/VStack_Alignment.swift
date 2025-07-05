//
//  VStack_1_01_Alignment.swift
//  100Views
//
//  Created by Mark Moeykens on 6/6/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI

struct VStack_1_01_Alignment : View {
    var body: some View {
        
        VStack(spacing: 20) {
            Text("VStack")
                .font(.largeTitle)
            Text("Alignment")
                .font(.title)
                .foregroundStyle(.gray)
            Text("By default, views in a VStack are center aligned.")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue).font(.title)
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 40) {
                Text("Leading Alignment")
                    .font(.title)
                Divider() // Creates a thin line (Push-out view)
                Image(systemName: "arrow.left")
            }
            .padding()
            .foregroundStyle(Color.white)
            .background(RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.blue))
            .padding()
            
            VStack(alignment: .trailing, spacing: 40) {
                Text("Trailing Alignment")
                    .font(.title)
                Divider()
                Image(systemName: "arrow.right")
            }
            .padding()
            .foregroundStyle(Color.white)
            .background(RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.blue))
            .padding()
        }
    }
}

struct VStack_1_01_Alignment_Previews : PreviewProvider {
    static var previews: some View {
        VStack_1_01_Alignment()
    }
}
