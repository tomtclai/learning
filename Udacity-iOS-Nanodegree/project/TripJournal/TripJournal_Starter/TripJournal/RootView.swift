import SwiftUI

struct RootView: View {
    @EnvironmentObject private var service: LiveJournalService
    @State private var addAction: () -> Void = {}

    @State private var isAuthenticated = false


    // MARK: - Body

    var body: some View {
        content
            .environment(\.journalService, service)
            .onReceive(service.isAuthenticated
                             .receive(on: DispatchQueue.main))
                 { self.isAuthenticated = $0 }
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
                .environmentObject(service)
        } else {
            AuthView(onAuth: {_ in })
                .environmentObject(service)
        }
    }
}
