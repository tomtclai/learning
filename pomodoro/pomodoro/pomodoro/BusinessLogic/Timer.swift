//
//  Timer.swift
//  pomodoro
//
//  Created by Tom Lai on 4/18/25.
//
import Foundation
import Observation
enum TimerState: String {
    case idle
    case running
    case paused
}

enum TimerMode: String {
    case work
    case rest
}

@Observable
class PomodoroTimer {
    
    var mode: TimerMode = .work
    var state: TimerState = .idle
    var workDuration: TimeInterval
    var restDuration: TimeInterval
    var dateStarted: Date?
    var audio: PomodoroAudio = PomodoroAudio()
    var duration: TimeInterval{
        switch mode {
        case .rest:
            return restDuration
        case .work:
            return workDuration
        }
    }
    private(set) var secondsPassed: Int = 0
    public var secondsPassedString: String {
        return formatSeconds(secondsPassed)
    }
    public var secondsLeft: Int {
        return Int(duration) - secondsPassed
    }
    public var secondsLeftString: String {
        return formatSeconds(secondsLeft)
    }
    public var fractionLeft: Double {
        return 1-fractionPassed
    }
    public var fractionPassed: Double {
        return Double(secondsPassed) / duration
    }
    var secondsPassedBeforePause: Int = 0
    var timer: Timer?
    
    init(workDuration: TimeInterval, restDuration: TimeInterval) {
        self.workDuration = workDuration
        self.restDuration = restDuration
    }
    func play(){
        dateStarted = Date.now
        secondsPassed = 0
        state = .running
        createTimer()
    }
    func resume(){
        createTimer()
        state = .running
    }
    func pause(){
        secondsPassedBeforePause = secondsPassed
        dateStarted = Date.now
        state = .paused
        killTimer()
    }
    func reset(){
        secondsPassed = 0
        secondsPassedBeforePause = 0
        state = .idle
        killTimer()
    }
    func skip(){
        switch mode {
        case .work: mode = .rest
        case .rest: mode = .work
        }
    }
    func createTimer() {
        // notif
        killTimer()
        PomodoroNotification.scheduleNotification(timeInterval: TimeInterval(secondsLeft), title: "Pomodoro", body: "Time over")
        // timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.onTick()
        }
    }
    func killTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    func onTick() {
        audio.play(sound: .tick)
        if let dateStarted = dateStarted {
            var secondSinceStart = Int(Date.now.timeIntervalSince(dateStarted))
            self.secondsPassed = secondSinceStart + secondsPassedBeforePause
            if secondsLeft == 0 {
                skip()
                reset()
                audio.play(sound: .done)
            }
        }
    }
    
    func formatSeconds(_ value: Int) -> String {
        let interval = TimeInterval(value)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        if value < 60 {
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = [.pad]
        } else {
            formatter.allowedUnits = [.day, .hour, .minute, .second]
            formatter.zeroFormattingBehavior = [.pad, .dropLeading]
        }
        return formatter.string(from: interval) ?? "0:00"
    }
}
