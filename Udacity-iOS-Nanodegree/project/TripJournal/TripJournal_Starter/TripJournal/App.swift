import SwiftUI

@main
struct TripJournalApp: App {
    @StateObject private var journalService = LiveJournalService()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(journalService)
        }
    }
}
