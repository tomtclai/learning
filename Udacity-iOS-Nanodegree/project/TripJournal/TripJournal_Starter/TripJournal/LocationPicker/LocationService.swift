import MapKit
import SwiftUI

@Observable
/// A service that can used used to search for locations.
class LocationService: NSObject {
    private let completer = MKLocalSearchCompleter()

    override init() {
        super.init()
        completer.delegate = self
    }

    var results: [MKLocalSearchCompletion] = []

    func search(for query: String) {
        completer.resultTypes = [.address, .pointOfInterest]
        completer.pointOfInterestFilter = .includingAll
        completer.queryFragment = query
    }

    func items(for result: MKLocalSearchCompletion) async -> [MKMapItem] {
        let mapKitRequest = MKLocalSearch.Request(completion: result)
        mapKitRequest.pointOfInterestFilter = .includingAll
        mapKitRequest.resultTypes = [.pointOfInterest, .address]
        let search = MKLocalSearch(request: mapKitRequest)
        let response = try? await search.start()
        return response?.mapItems ?? []
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }

    func completer(_: MKLocalSearchCompleter, didFailWithError _: Error) {
        results = []
    }
}
