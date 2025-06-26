import MapKit
import SwiftUI

struct TripDetails: View {
    init(
        trip: Trip,
        addAction: Binding<() -> Void>,
        deletionHandler: @escaping () -> Void
    ) {
        _trip = .init(initialValue: trip)
        _addAction = addAction
        self.deletionHandler = deletionHandler
    }

    private let deletionHandler: () -> Void

    @Binding private var addAction: () -> Void

    @State private var trip: Trip
    @State private var eventFormMode: EventForm.Mode?
    @State private var isDeleteConfirmationPresented = false
    @State private var isLoading = false
    @State private var error: Error?

    @Environment(\.dismiss) private var dismiss
    @Environment(\.journalService) private var journalService

    var body: some View {
        contentView
            .onAppear {
                addAction = { eventFormMode = .add }
                Task {
                    await reloadTrip()
                }
            }
            .navigationTitle(trip.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolbar)
            .sheet(item: $eventFormMode) { mode in
                EventForm(tripId: trip.id, mode: mode) {
                    Task {
                        await reloadTrip()
                    }
                }
            }
            .confirmationDialog("Delete Trip?", isPresented: $isDeleteConfirmationPresented) {
                Button("Delete Trip", role: .destructive) {
                    Task {
                        await deleteTrip()
                    }
                }
            }
            .loadingOverlay(isLoading)
    }

    @ToolbarContentBuilder
    private func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Delete Trip", systemImage: "trash", role: .destructive) {
                isDeleteConfirmationPresented = true
            }
            .tint(.red)
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if trip.events.isEmpty {
            emptyView
        } else {
            eventsView
        }
    }

    private var eventsView: some View {
        ScrollView(.vertical) {
            ForEach(trip.events) { event in
                EventCell(
                    event: event,
                    edit: { eventFormMode = .edit(event) },
                    mediaUploadHandler: { data in
                        Task {
                            await uploadMedia(eventId: event.id, data: data)
                        }
                    },
                    mediaDeletionHandler: { mediaId in
                        Task {
                            await deleteMedia(withId: mediaId)
                        }
                    }
                )
            }
        }
        .refreshable {
            await reloadTrip()
        }
    }

    private var emptyView: some View {
        ContentUnavailableView(
            label: {
                Label("Nothing here yet!", systemImage: "face.dashed")
                    .labelStyle(.titleOnly)
            },
            description: {
                Text("Add an event to start your trip journal.")
            }
        )
    }

    // MARK: - Networking

    private func uploadMedia(eventId: Event.ID, data: Data) async {
        isLoading = true
        let request = MediaCreate(eventId: eventId, base64Data: data)
        do {
            try await journalService.createMedia(with: request)
            await reloadTrip()
        } catch {
            self.error = error
        }
        isLoading = false
    }

    private func deleteMedia(withId mediaId: Media.ID) async {
        isLoading = true
        do {
            try await journalService.deleteMedia(withId: mediaId)
            await reloadTrip()
        } catch {
            self.error = error
        }
        isLoading = false
    }

    private func reloadTrip() async {
        let id = trip.id
        do {
            let updatedTrip = try await journalService.getTrip(withId: id)
            trip = updatedTrip
        } catch {
            self.error = error
        }
    }

    private func deleteTrip() async {
        isLoading = true
        do {
            try await journalService.deleteTrip(withId: trip.id)
            await MainActor.run {
                deletionHandler()
                dismiss()
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
