// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio










import SwiftUI

struct LazyVGrid_FlexWidth: View {
    @State private var data = ["❣️ Love You! ❣️", "Test Length 1", "👉 Test Length 2 👈", "Hi"]
    
    
    var body: some View {
        let columns = [GridItem(.flexible(minimum: 70, maximum: 200)),
                       GridItem(.flexible(minimum: 70, maximum: 200))]
        
        LazyVGrid(columns: columns) {
            ForEach(data, id: \.self) { item in
                RoundedRectangle(cornerRadius: 12)
                    .fill(.tertiary)
                    .frame(height: 50)
                    .overlay {
                        Text(item)
                    }
            }
        }
    }
}

struct LazyVGrid_FlexWidth_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid_FlexWidth()
    }
}
