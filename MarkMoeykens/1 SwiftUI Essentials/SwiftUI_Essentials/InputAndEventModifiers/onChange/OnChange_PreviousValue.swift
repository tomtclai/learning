// Copyright © 2022 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

struct OnChange_PreviousValue: View {
    @State private var rotation = Angle.degrees(0)
    @State private var size: CGFloat = 50
    @State private var color = Color.green
    
    var body: some View {
        VStack(spacing: 20) {
            HeaderView("onChange", subtitle: "Previous Value",
                       desc: "The onChange modifier can also view the previous value of the property that is being changed.",
                       back: .blue, textColor: .white)
            HStack(spacing: 75) {
                Button("Reset") { rotation = Angle.degrees(0) }
                Button("Rotate") { rotation = Angle.degrees(90) }
            }
            Spacer()
            Image(systemName: "l.joystick.tilt.up.fill")
                .rotationEffect(rotation)
                .font(.system(size: size))
                .foregroundStyle(color)
                .animation(.default, value: rotation)
            Spacer()
        }
        .font(.title)
        .onChange(of: rotation) { oldValue, newValue in
            print("Previous Value: \(oldValue)")
            if newValue == Angle.degrees(0) {
                size = 50
                color = Color.green
            } else {
                size = 100
                color = Color.red
            }
        }
    }
}

struct OnChange_PreviousValue_Previews: PreviewProvider {
    static var previews: some View {
        OnChange_PreviousValue()
    }
}
