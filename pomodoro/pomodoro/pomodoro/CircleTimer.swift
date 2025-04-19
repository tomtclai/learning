//
//  CircleTimer.swift
//  pomodoro
//
//  Created by Tom Lai on 4/19/25.
//

import SwiftUI

struct CircleTimer: View {
    let fraction: Double
    let primaryText: String
    let secondaryText: String
    var body: some View {
        ZStack{
            Circle()
                .fill(Color("Dark")).opacity(0.5)
            Circle()
                .trim(from:0, to:fraction)
                .stroke(Color("Light"),style: .init(lineWidth: 20, lineCap: .round))
                .opacity(0.8)
                .rotationEffect(.init(degrees: -90))
                .padding()
                .animation(.easeInOut, value: fraction)
            Text(primaryText)
                .font(.system(size: 50, weight: .semibold, design: .rounded))
                .foregroundColor(Color("Light"))
            Text(secondaryText)
                .font(.system(size: 30, weight: .light, design: .rounded))
                .foregroundColor(Color("Light"))
                .offset(y: 50)
        }
        .padding()
    }
}

#Preview {
    CircleTimer(fraction: 0.5, primaryText: "12:20", secondaryText: "working")
}
