// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct NavLink_isPresented: View {
    @State private var showSheet = false
    @State private var navigate = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Show Sheet") { showSheet.toggle() }
            }
            .navigationTitle("Navigate When True")
            .sheet(isPresented: $showSheet) {
                VStack(spacing: 16.0) {
                    NavigationLink(destination: Text("Destination from Link")) {
                        Text("Navigation Link")
                    }
                    Button("Button Link") {
                        showSheet = false
                        navigate = true
                    }
                }
                .presentationDetents([.height(240)])
            }
            .navigationDestination(isPresented: $navigate) {
                Text("Destination from Button")
            }
        }
        .font(.title)
    }
}

struct NavLink_isPresented_Previews: PreviewProvider {
    static var previews: some View {
        NavLink_isPresented()
    }
}
