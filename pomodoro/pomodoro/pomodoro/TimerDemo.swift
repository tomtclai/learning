//
//  ContentView.swift
//  pomodoro
//
//  Created by Tom Lai on 4/17/25.
//

import SwiftUI

struct TimerDemo: View {
    var timer: PomodoroTimer = PomodoroTimer(workDuration: 10, restDuration: 5)

    var body: some View {
        VStack {
            Text("\(timer.secondsLeft)")
            Text("\(timer.secondsLeftString)")
            Text("\(timer.mode.rawValue)")
            
            switch timer.state {
            case .idle:
                Button("Start") { timer.play() }
            case .running:
                Button("Pause") { timer.pause() }
            case .paused:
                Button("Resume") { timer.resume() }
            }
        }
        .padding()
    }
}

#Preview {
    TimerDemo()
}
