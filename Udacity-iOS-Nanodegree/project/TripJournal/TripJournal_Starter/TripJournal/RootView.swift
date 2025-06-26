import SwiftUI

struct RootView: View {
    let service: JournalService

    @State private var addAction: () -> Void = {}
    @State private var isAuthenticated = false

    @Environment(\.journalService) private var journalService

    // MARK: - Body

    var body: some View {
        content
            .environment(\.journalService, service)
            .onReceive(service.isAuthenticated.receive(on: DispatchQueue.main)) { isAuthenticated in
                self.isAuthenticated = isAuthenticated
            }
    }

    // MARK: - Views

    @ViewBuilder
    private var content: some View {
        if isAuthenticated {
            TripList(addAction: $addAction)
                .contentMargins(.bottom, 100)
                .overlay(alignment: .bottom) {
                    AddButton(action: addAction)
                }
        } else {
            AuthView()
        }
    }
}
