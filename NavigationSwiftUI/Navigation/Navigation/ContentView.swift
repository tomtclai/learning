//
//  ContentView.swift
//  Navigation
//
//  Created by Tom Lai on 4/17/25.
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(0..<5) { i in
                    NavigationLink("Select Number: \(i)", value: i)
                }
                
                ForEach(0..<5) { i in
                    NavigationLink("Select String: \(i)", value: String(i))
                }
            }
            .toolbar {
                Button("push 556") {
                    path.append(556)
                }
                Button("push hello") {
                    path.append("hello")
                }
            }
            .navigationDestination(for: Int.self) { selection in
                Text("int \(selection)")
            }
            .navigationDestination(for: String.self) { selection in
                Text("string \(selection)")
            }
        }
    }
}

#Preview {
    ContentView()
}
