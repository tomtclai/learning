//
//  NotificationDisabled.swift
//  pomodoro
//
//  Created by Tom Lai on 4/19/25.
//
import SwiftUI

struct NotificationDisabled: View {
    var body: some View {
        VStack {
            Text("Notification Disabled")
                .font(.headline)
            Text("You can enable it in Settings > Notifications")
                .font(.subheadline)
            Button("Go to Settings") {
                openSettings()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color("Light"))
        .foregroundColor(Color("Dark"))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .frame(maxWidth: .infinity) // grow wider for wider device
        .padding(.vertical)
    }
    
    private func openSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}

#Preview {
    VStack {
        NotificationDisabled()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("Dark"))
}
