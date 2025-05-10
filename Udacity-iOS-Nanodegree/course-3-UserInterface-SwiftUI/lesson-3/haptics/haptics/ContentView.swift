//
//  ContentView.swift
//  testapp
//
//  Created by Lai, Tom on 5/2/25.
//
import CoreHaptics
import SwiftUI

struct ContentView: View {
    var hapticEngine: CHHapticEngine?
    init() {
        self.hapticEngine = try? CHHapticEngine()
    }
    var body: some View {
         List {
             Button("UINotificationFeedbackGenerator success") {
                 let generator = UINotificationFeedbackGenerator()
                 generator.notificationOccurred(.success)
             }
             Button("UINotificationFeedbackGenerator error") {
                 let generator = UINotificationFeedbackGenerator()
                 generator.notificationOccurred(.error)
             }
             Button("UINotificationFeedbackGenerator warning") {
                 let generator = UINotificationFeedbackGenerator()
                 generator.notificationOccurred(.warning)
             }
             Button("UIImpactFeedbackGenerator impactOccurred"){
                 let generator = UIImpactFeedbackGenerator(style: .heavy)
                 generator.impactOccurred()

             }
             Button("UISelectionFeedbackGenerator selectionChanged"){
                 let generator = UISelectionFeedbackGenerator()
                 generator.selectionChanged()
             }
             Button("UICanvasFeedbackGenerator alignmentOccurred") {
                 let generator = UICanvasFeedbackGenerator()
                 generator.alignmentOccurred(at: CGPointZero)
             }
         }
         .onAppear {
             do {

                 try hapticEngine?.start()
             } catch let error {
                 print("Engine Error: \(error)")
             }
         }
     }

    func generateHaptics() {
        let notificationGenerator = UISelectionFeedbackGenerator()
        notificationGenerator.selectionChanged()

    }
}

#Preview {
    ContentView()
}
