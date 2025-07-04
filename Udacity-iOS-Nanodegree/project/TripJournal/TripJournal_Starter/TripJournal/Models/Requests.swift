import Foundation

/// An object that can be used to create a new trip.
struct TripCreate: Codable {
    let name: String
    let startDate: Date
    let endDate: Date
}

/// An object that can be used to update an existing trip.
struct TripUpdate: Codable {
    let name: String
    let startDate: Date
    let endDate: Date
}

/// An object that can be used to create a media.
struct MediaCreate: Codable {
    let eventId: Event.ID
    let base64Data: Data
}

/// An object that can be used to create a new event.
struct EventCreate: Codable {
    let tripId: Trip.ID
    let name: String
    let note: String?
    let date: Date
    let location: Location?
    let transitionFromPrevious: String?
}

/// An object that can be used to update an existing event.
struct EventUpdate: Codable {
    var name: String
    var note: String?
    var date: Date
    var location: Location?
    var transitionFromPrevious: String?
}
