// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct ViewThatFits_WithScrollView: View {
    var repeatedDataView: some View {
        VStack {
            ForEach(0..<15) { index in
                Image(systemName: "\(index).circle")
                    .padding()
            }
        }
    }
    
    var body: some View {
        ViewThatFits {
            repeatedDataView
            
            ScrollView {
                repeatedDataView
            }
        }
        .font(.largeTitle)
    }
}

#Preview {
    ViewThatFits_WithScrollView()
}
