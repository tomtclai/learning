//
//  ContentView.swift
//  pomodoro
//
//  Created by Tom Lai on 4/17/25.
//

import SwiftUI
struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var displayWarning = false
    private var timer = PomodoroTimer(workDuration: 600, restDuration: 60)
    var body: some View {
        VStack {
            CircleTimer(fraction: timer.fractionPassed, primaryText: timer.secondsLeftString, secondaryText: timer.mode.rawValue)
            HStack {
                if timer.state == .idle && timer.mode == .rest {
                    CircleButton(icon: "forward.fill") {
                        timer.skip()
                    }
                }
                if timer.state == .idle  {
                    CircleButton(icon: "play.fill") {
                        timer.play()
                    }
                }
                if timer.state == .running {
                    CircleButton(icon: "pause.fill") {
                        timer.pause()
                    }
                }
                if timer.state == .paused {
                    CircleButton(icon: "play.fill") {
                        timer.resume()
                    }
                }
                if timer.state == .running {
                    CircleButton(icon: "stop.fill") {
                        timer.reset()
                    }
                }
            }
            if displayWarning {
                NotificationDisabled()
            }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity) // grow height
        .background(
            RadialGradient(colors: [Color("Light"), Color("Dark")], center: .center, startRadius: 5.0, endRadius: 500.0)
        )
        .onChange(of: scenePhase, initial: true) { oldValue, newValue in
            if newValue == .active {
                Task {
                    displayWarning = !(await PomodoroNotification.checkAuthorization())
                }
            }
        }
    }
}
struct ContentView1: View {
    @State private var showWarning = false
    var audioPlayer = PomodoroAudio()
    var notif = PomodoroNotification()
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack {
            if showWarning {
                VStack{
                    Text("Notification disabled")
                    Button("Enable in settings") {
                        DispatchQueue.main.async {
                            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                        }
                    }
                }
            }
            Button("Play Done") {
                audioPlayer.play(sound: .done)
            }
            Button("Play Tick") {
                audioPlayer.play(sound: .tick)
            }
            Button("Timer") {
                PomodoroNotification.scheduleNotification(timeInterval: 5, title: "TItle", body: "body")
            }
        }
        .onChange(of: scenePhase, initial: true, { oldValue, newValue in
            Task {
                if newValue == .active {
                    showWarning = !(await PomodoroNotification.checkAuthorization())
                }
            }
        })
        .padding()
    }
}

#Preview {
    ContentView()
}
