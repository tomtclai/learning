//
//  Stepper_Colors.swift
//  100Views
//
//  Created by Mark Moeykens on 6/29/19.
//  Copyright © 2019 Mark Moeykens. All rights reserved.
//

import SwiftUI

struct Stepper_Colors : View {
    @State private var contrast = 50
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Stepper").font(.largeTitle)
            Text("Colors").font(.title).foregroundStyle(.gray)
            
            Text("There is no built-in way to change the color of the stepper that I have found. Instead, I had to hide the label and apply a color behind it.")
                .frame(maxWidth: .infinity).padding()
                .background(Color.blue).foregroundStyle(Color.white)
                .font(.title).minimumScaleFactor(0.8) // Allow text to resize on smaller devices
            
            Group {
                Stepper(value: $contrast, in: 0...100) {
                    Text("Default Color")
                }
                Stepper(value: $contrast, in: 0...100) {
                    Text("Applying Tint Color (no effect)")
                }
                .tint(.blue)
                
                HStack {
                    Text("My Custom Colored Stepper")
                    Spacer()
                    Stepper("Age", value: $contrast)
                        .background(Color.teal, in: RoundedRectangle(cornerRadius: 9))
                        .labelsHidden() // Hide the label
                }
                
                HStack {
                    Text("My Custom Colored Stepper")
                    Spacer()
                    Stepper("Count", value: $contrast)
                        .background(Color.orange, in: RoundedRectangle(cornerRadius: 9))
                        .labelsHidden() // Hide the label
                }
                
                HStack {
                    Text("My Custom Colored Stepper")
                    Spacer()
                    Stepper("", value: $contrast)
                        .background(Color.red, in: RoundedRectangle(cornerRadius: 9))
                        .labelsHidden() // Hide the label
                }
                
                HStack {
                    Text("My Custom Colored Stepper")
                    Spacer()
                    Stepper("", value: $contrast)
                        .background(Color.pink, in: RoundedRectangle(cornerRadius: 9))
                        .labelsHidden() // Hide the label
                }
                
                HStack {
                    Text("My Custom Colored Stepper")
                    Spacer()
                    Stepper("", value: $contrast)
                        .background(Color.purple, in: RoundedRectangle(cornerRadius: 9))
                        .labelsHidden() // Hide the label
                }
                
                HStack {
                    Text("My Custom Colored Stepper")
                    Spacer()
                    Stepper("", value: $contrast)
                        .background(Color.yellow, in: RoundedRectangle(cornerRadius: 9))
                        .labelsHidden() // Hide the label
                }
                
                HStack {
                    Text("Using RoundedRectangle:")
                    Spacer()
                    Stepper("", value: $contrast)
                        .background(RoundedRectangle(cornerRadius: 9).fill(Color.green))
                        .labelsHidden() // Hide the label
                }
            }.padding(.horizontal)
        }
    }
}

struct Stepper_Colors_Previews : PreviewProvider {
    static var previews: some View {
        Stepper_Colors()
    }
}
