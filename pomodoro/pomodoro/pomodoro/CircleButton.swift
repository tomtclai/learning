//
//  NotificationDisabled.swift
//  pomodoro
//
//  Created by Tom Lai on 4/19/25.
//
import SwiftUI

struct CircleButton: View {
    let icon: String
    let action: () -> Void
    var body: some View {
        Button() {
            action()
        } label: {
            Image(systemName: icon)
                .foregroundColor(Color("Light"))
                .frame(width: 60, height: 60)
                .background(Color("Dark")).opacity(0.5)
                .clipShape(Circle())
        }
    }
    
    private func openSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}

#Preview {
    VStack {
        CircleButton(icon: "play.fill") {
            print("hello")
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("Light"))
}
