import Combine
import Foundation

/// An unimplemented version of the `JournalService`.
class UnimplementedJournalService: JournalService {
    var isAuthenticated: AnyPublisher<Bool, Never> {
        fatalError("Unimplemented isAuthenticated")
    }

    func register(username _: String, password _: String) async throws -> Token {
        fatalError("Unimplemented register")
    }

    func logOut() {
        fatalError("Unimplemented logOut")
    }

    func logIn(username _: String, password _: String) async throws -> Token {
        fatalError("Unimplemented logIn")
    }

    func createTrip(with _: TripCreate) async throws -> Trip {
        fatalError("Unimplemented createTrip")
    }

    func getTrips() async throws -> [Trip] {
        fatalError("Unimplemented getTrips")
    }

    func getTrip(withId _: Trip.ID) async throws -> Trip {
        fatalError("Unimplemented getTrip")
    }

    func updateTrip(withId _: Trip.ID, and _: TripUpdate) async throws -> Trip {
        fatalError("Unimplemented updateTrip")
    }

    func deleteTrip(withId _: Trip.ID) async throws {
        fatalError("Unimplemented deleteTrip")
    }

    func createEvent(with _: EventCreate) async throws -> Event {
        fatalError("Unimplemented createEvent")
    }

    func updateEvent(withId _: Event.ID, and _: EventUpdate) async throws -> Event {
        fatalError("Unimplemented updateEvent")
    }

    func deleteEvent(withId _: Event.ID) async throws {
        fatalError("Unimplemented deleteEvent")
    }

    func createMedia(with _: MediaCreate) async throws -> Media {
        fatalError("Unimplemented createMedia")
    }

    func deleteMedia(withId _: Media.ID) async throws {
        fatalError("Unimplemented deleteMedia")
    }
}
