import SwiftUI

@main
struct TripJournalApp: App {
    var body: some Scene {
        WindowGroup {
            #warning("Replace the mock service with a live implementation that talks with the API.")
            RootView(service: MockJournalService(delay: 0.25))
        }
    }
}
