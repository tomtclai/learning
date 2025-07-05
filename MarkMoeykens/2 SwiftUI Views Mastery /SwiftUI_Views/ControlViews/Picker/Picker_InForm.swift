// Copyright © 2021 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct Picker_InForm: View {
    @State private var selectedDaysOption = "2"
    var numberOfDaysOptions = ["1", "2", "3", "4", "5"]
    
    var body: some View {
        VStack {
            Form {
                Picker("Frequency", selection: $selectedDaysOption) {
                    ForEach(numberOfDaysOptions, id: \.self) {
                        Text("\($0) Days").tag($0)
                    }
                }
                Picker("Frequency", selection: $selectedDaysOption) {
                    ForEach(numberOfDaysOptions, id: \.self) {
                        Text("\($0) Days").tag($0)
                    }
                }
                .pickerStyle(.menu) // Add this modifier to make it use the accent color
                
                Picker("Frequency", selection: $selectedDaysOption) {
                    ForEach(numberOfDaysOptions, id: \.self) {
                        Text("\($0) Days").tag($0)
                    }
                }
                .pickerStyle(.inline)
                
                Picker("Frequency", selection: $selectedDaysOption) {
                    ForEach(numberOfDaysOptions, id: \.self) {
                        Text("\($0) Days").tag($0)
                    }
                }
                .pickerStyle(.wheel)
            }
        }
        .font(.title)
    }
}

struct Picker_InForm_Previews: PreviewProvider {
    static var previews: some View {
        Picker_InForm()
    }
}
