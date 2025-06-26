import MapKit
import SwiftUI

struct EventForm: View {
    enum Mode: Hashable, Identifiable {
        case add
        case edit(Event)

        var id: String {
            switch self {
            case .add:
                "add"
            case let .edit(event):
                "edit: \(event.id)"
            }
        }
    }

    struct FormError: LocalizedError {
        var errorDescription: String?

        static let emptyName = Self(errorDescription: "Please enter a name.")
    }

    init(
        tripId: Trip.ID,
        mode: Mode,
        updateHandler: @escaping () -> Void
    ) {
        self.tripId = tripId
        self.mode = mode
        self.updateHandler = updateHandler

        switch mode {
        case .add:
            title = "Add Event"

        case let .edit(event):
            title = "Edit \(event.name)"
            _name = .init(initialValue: event.name)
            _note = .init(initialValue: event.note)
            _date = .init(initialValue: event.date)
            _location = .init(initialValue: event.location)
            _transitionFromPrevious = .init(initialValue: event.transitionFromPrevious)
        }
    }

    private let tripId: Trip.ID
    private let mode: Mode
    private let updateHandler: () -> Void
    private let title: String

    @State private var name: String = ""
    @State private var note: String?
    @State private var date: Date = .now
    @State private var location: Location?
    @State private var transitionFromPrevious: String?
    @State private var isLoading = false
    @State private var error: Error?
    @State private var isLocationPickerPresented = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.journalService) private var journalService

    // MARK: - Body

    var body: some View {
        NavigationView {
            form
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: toolbar)
                .overlay(alignment: .bottom, content: deleteButton)
                .alert(error: $error)
                .loadingOverlay(isLoading)
                .sheet(isPresented: $isLocationPickerPresented) {
                    LocationPicker(location: location) { selectedLocation in
                        location = selectedLocation
                    }
                }
                .interactiveDismissDisabled()
        }
    }

    // MARK: - Views

    private var form: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $name, prompt: Text("Visit to the Van Gogh Museum"))
            }
            Section("Note") {
                TextField(
                    "Note",
                    text: $note ?? "",
                    prompt: Text("A vivid, unforgettable art experience..."),
                    axis: .vertical
                )
                .lineLimit(3 ... 5)
            }
            Section {
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            Section("Travel Method") {
                TextField("Travel Method", text: $transitionFromPrevious ?? "", prompt: Text("Tram ride from hotel"))
            }
            locationSection
        }
    }

    @ToolbarContentBuilder
    func toolbar() -> some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Dismiss", systemImage: "xmark") {
                dismiss()
            }
        }
        ToolbarItem(placement: .primaryAction) {
            Button("Save") {
                switch mode {
                case .add:
                    Task {
                        await addEvent()
                    }
                case let .edit(event):
                    Task {
                        await editEvent(withId: event.id)
                    }
                }
            }
        }
    }

    private var locationSection: some View {
        Section {
            if let location {
                Button(
                    action: { isLocationPickerPresented = true },
                    label: {
                        map(location: location)
                    }
                )
                .buttonStyle(.plain)
                .containerRelativeFrame(.horizontal)
                .clipped()
                .listRowInsets(EdgeInsets())
                .frame(height: 150)

                removeLocation
            } else {
                addLocation
            }
        }
    }

    @ViewBuilder
    private func map(location: Location) -> some View {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 0, longitudinalMeters: 0)
        let bounds = MapCameraBounds(centerCoordinateBounds: region, minimumDistance: 250, maximumDistance: .infinity)

        Map(bounds: bounds) {
            Marker(location.address ?? "", coordinate: location.coordinate)
        }
    }

    private var addLocation: some View {
        Button(
            action: {
                isLocationPickerPresented = true
            },
            label: {
                Text("Add Location")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        )
    }

    private var removeLocation: some View {
        Button(
            role: .destructive,
            action: {
                location = nil
            },
            label: {
                Text("Remove Location")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        )
    }

    @ViewBuilder
    private func deleteButton() -> some View {
        if case let .edit(event) = mode {
            ZStack(alignment: .bottom) {
                LinearGradient(
                    colors: [
                        Color(uiColor: .systemBackground),
                        Color(uiColor: .systemBackground),
                        Color.clear,
                    ],
                    startPoint: .bottom,
                    endPoint: .top
                )
                .ignoresSafeArea()
                .frame(height: 100)

                Button("Delete Event", systemImage: "trash", role: .destructive) {
                    Task {
                        await deleteEvent(withId: event.id)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    // MARK: - Networking

    private func validateForm() throws {
        if name.nonEmpty == nil {
            throw FormError.emptyName
        }
    }

    private func addEvent() async {
        isLoading = true
        do {
            try validateForm()
            let request = EventCreate(
                tripId: tripId,
                name: name,
                note: note?.nonEmpty,
                date: date,
                location: location,
                transitionFromPrevious: transitionFromPrevious?.nonEmpty
            )
            try await journalService.createEvent(with: request)
            await MainActor.run {
                updateHandler()
                dismiss()
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }

    private func editEvent(withId id: Event.ID) async {
        isLoading = true
        do {
            try validateForm()
            let request = EventUpdate(
                name: name,
                note: note?.nonEmpty,
                date: date,
                location: location,
                transitionFromPrevious: transitionFromPrevious?.nonEmpty
            )
            try await journalService.updateEvent(withId: id, and: request)
            await MainActor.run {
                updateHandler()
                dismiss()
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }

    private func deleteEvent(withId id: Event.ID) async {
        isLoading = true
        do {
            try await journalService.deleteEvent(withId: id)
            await MainActor.run {
                updateHandler()
                dismiss()
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
