// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

// View
import SwiftUI

struct DogsView: View {
    @State private var oo = DogsOO()
    
    var body: some View {
        List(oo.data) { datum in
            Text(datum.name)
        }
        .font(.title)
        .onAppear {
            oo.fetch()
        }
    }
}

#Preview {
    DogsView()
}

// Observable Object

@Observable
class DogsOO {
    var data: [DogsDO] = []
    
    func fetch() {
#if DEBUG // Mock data here
        data = [DogsDO(name: "Saint Bernard"),
                DogsDO(name: "English Mastiff"),
                DogsDO(name: "Newfoundland")]
#else // Real data, API calls, etc
        data = [DogsDO(name: "Dachshund"),
                DogsDO(name: "Boston Terrier"),
                DogsDO(name: "Pug")]
#endif
    }
}

// Data Object
struct DogsDO: Identifiable {
    let id = UUID()
    var name: String
}
