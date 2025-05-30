//
//  ContentView.swift
//  SocialApp
//
//  Created by Mark DiFranco on 2024-05-05.
//

import SwiftUI
struct Post: Identifiable {
    var id = UUID()
    var title = ""
    var description = ""
    var color: Color = .black
    var isPublic: Bool = false
}
struct PostView: View {
    @State var post = Post()
    var body: some View {
        NavigationStack {
            
            ZStack {
                post.color.opacity(0.5).ignoresSafeArea()
                Form {
                    TextField("Title", text: $post.title)
                    TextField("Description", text: $post.description)
                    ColorPicker("Color", selection: $post.color)
                    Toggle("Make public", isOn: $post.isPublic)
                }
                .navigationTitle("New Post")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Post") { }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        
    }
    
}

#Preview {
    PostView()
}
