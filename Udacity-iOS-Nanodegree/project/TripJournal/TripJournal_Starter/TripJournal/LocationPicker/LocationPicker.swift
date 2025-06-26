import Contacts
import MapKit
import SwiftUI

struct LocationPicker: View {
    let selectionHandler: (Location) -> Void

    init(location: Location? = nil, selectionHandler: @escaping (Location) -> Void) {
        if let location {
            let placemark = MKPlacemark(
                coordinate: location.coordinate,
                addressDictionary: [
                    CNPostalAddressStreetKey: location.address ?? "",
                ]
            )
            let item = MKMapItem(placemark: placemark)
            _items = .init(initialValue: [item])
            _selectedItem = .init(initialValue: item)
            _isSheetPresented = .init(initialValue: false)

        } else {
            _items = .init(initialValue: [])
            _selectedItem = .init(initialValue: nil)
            _isSheetPresented = .init(initialValue: true)
        }
        self.selectionHandler = selectionHandler
    }

    private let service = LocationService()

    @State private var position = MapCameraPosition.automatic
    @State private var query = ""
    @State private var items: [MKMapItem]
    @State private var selectedItem: MKMapItem?
    @State private var isSheetPresented: Bool
    @State private var scene: MKLookAroundScene?

    @Environment(\.dismiss) private var dismiss

    // MARK: - Body

    var body: some View {
        NavigationView {
            Map(position: $position, selection: $selectedItem) {
                ForEach(items, id: \.self, content: Marker.init)
            }
            .ignoresSafeArea()
            .safeAreaInset(edge: .bottom, alignment: .center) {
                if let selectedItem {
                    VStack(alignment: .center, spacing: 16) {
                        selectButton(for: selectedItem)
                        LookAroundPreview(scene: $scene, allowsNavigation: false, badgePosition: .bottomTrailing)
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 20)
                }
            }
            .onChange(of: selectedItem) {
                if let selectedItem {
                    Task {
                        scene = try? await fetchScene(for: selectedItem.placemark.coordinate)
                    }
                }
                isSheetPresented = selectedItem == nil
            }
            .onChange(of: items) {
                if let firstItem = items.first, items.count == 1 {
                    selectedItem = firstItem
                }
            }
            .task {
                if let coordinate = selectedItem?.placemark.coordinate {
                    scene = try? await fetchScene(for: coordinate)
                }
            }
            .sheet(isPresented: $isSheetPresented) {
                LocationSearchView(service: service, query: $query, items: $items)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    // MARK: - Views

    private func selectButton(for item: MKMapItem) -> some View {
        Button(
            action: {
                let coordinate = item.placemark.coordinate
                let location = Location(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    address: item.name
                )
                selectionHandler(location)
                dismiss()
            },
            label: {
                Text("Select")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(5)
            }
        )
        .buttonBorderShape(.roundedRectangle)
        .buttonStyle(.borderedProminent)
    }

    // MARK: - Helpers

    private func fetchScene(for coordinate: CLLocationCoordinate2D) async throws -> MKLookAroundScene? {
        let lookAroundScene = MKLookAroundSceneRequest(coordinate: coordinate)
        return try await lookAroundScene.scene
    }
}
