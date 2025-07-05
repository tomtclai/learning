// Copyright © 2023 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct OnChange_WithObservable: View {
    @State var oo = OnChange_WithObservableOO()
    @State private var isProcessing = true
    
    var body: some View {
        List(oo.data, id: \.self) { datum in
            Text(datum)
        }
        .overlay {
            if isProcessing {
                ProgressView()
                    .padding()
                    .background(.black.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .font(.title)
        .onAppear {
            oo.fetchData()
        }
        .onChange(of: oo.data, initial: false) { _, _ in
            isProcessing = false
        }
    }
}

@Observable
class OnChange_WithObservableOO {
    var data: [String] = []
    
    func fetchData() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [self] in
            data = ["Datum 1", "Datum 2", "Datum 3"]
        }
    }
}

#Preview {
    OnChange_WithObservable()
}
