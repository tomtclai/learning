// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct onAppear_Intro: View {
    @State private var currentDate = Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(currentDate.formatted(date: .omitted, time: .standard))
                    .padding()
                NavigationLink("Detail View") {
                    onAppear_DetailView()
                }
            }
            .font(.largeTitle)
            .navigationTitle("onAppear")
            .onAppear {
                currentDate = Date()
            }
        }
    }
}

struct onAppear_DetailView: View {
    @State private var currentDate = Date()
    
    var body: some View {
        Text(currentDate.formatted(date: .omitted, time: .standard))
            .font(.largeTitle)
            .padding()
            .onAppear {
                currentDate = Date()
            }
            .navigationTitle("Detail View")
    }
}

struct onAppear_Intro_Previews: PreviewProvider {
    static var previews: some View {
        onAppear_Intro()
    }
}
