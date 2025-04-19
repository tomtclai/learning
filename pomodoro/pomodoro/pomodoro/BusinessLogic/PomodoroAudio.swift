//
//  PomodoroSounds.swift
//  pomodoro
//
//  Created by Tom Lai on 4/18/25.
//
import AVFoundation
enum PomodoroAudioSounds {
    case done
    case tick
    
    var resource: String {
        switch self {
        case .done:
            return "bell.wav"
        case .tick:
            return "tick.wav"
        }
    }
}

class PomodoroAudio {
    private var audioPlayer: AVAudioPlayer?

    func play(sound: PomodoroAudioSounds) {
        let path = Bundle.main.path(forResource: sound.resource, ofType: nil)!
        let url = URL(filePath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }
}
