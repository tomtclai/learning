import Combine
import Foundation

/// The journal service is used to perform networking operations in the app.
protocol JournalService {
    /// A publisher that can be observed to indicate whether the user is authenticated or not.
    var isAuthenticated: AnyPublisher<Bool, Never> { get }

    /// Create a new account.
    /// - Parameters:
    ///   - username: Username.
    ///   - password: Password.
    /// - Returns: A token that can be used to interact with the API.
    @discardableResult
    func register(username: String, password: String) async throws -> Token

    /// Login to an existing account.
    /// - Parameters:
    ///   - username: Username.
    ///   - password: Password.
    /// - Returns: A token that can be used to interact with the API.
    @discardableResult
    func logIn(username: String, password: String) async throws -> Token

    /// Log-outs the user, by deleting the token and updating the isAuthenticated publisher.
    func logOut()

    /// Creates a new trip.
    /// - Parameter request: Trip creation request.
    /// - Returns: Created trip.
    @discardableResult
    func createTrip(with request: TripCreate) async throws -> Trip

    /// Get all trips.
    /// - Returns: All trips.
    @discardableResult
    func getTrips() async throws -> [Trip]

    /// Get a trip with a given id.
    /// - Parameter tripId: Trip id.
    /// - Returns: Trip.
    @discardableResult
    func getTrip(withId tripId: Trip.ID) async throws -> Trip

    /// Updates a trip.
    /// - Parameter request: Trip update request.
    /// - Returns: Updated trip.
    @discardableResult
    func updateTrip(withId tripId: Trip.ID, and request: TripUpdate) async throws -> Trip

    /// Delete a trip with a given id.
    /// - Parameter tripId: Trip id.
    func deleteTrip(withId tripId: Trip.ID) async throws

    /// Create an event.
    /// - Parameter request: Event creation request.
    /// - Returns: Created event.
    @discardableResult
    func createEvent(with request: EventCreate) async throws -> Event

    /// Updates an event.
    /// - Parameter request: Event update request.
    /// - Returns: Updated event.
    @discardableResult
    func updateEvent(withId eventId: Event.ID, and request: EventUpdate) async throws -> Event

    /// Delete an event with a given id.
    /// - Parameter eventId: Event id.
    func deleteEvent(withId eventId: Event.ID) async throws

    /// Create a media.
    /// - Parameter request: Media creation request.
    /// - Returns: Created media.
    @discardableResult
    func createMedia(with request: MediaCreate) async throws -> Media

    /// Delete a media with a given id.
    /// - Parameter mediaId: Media id.
    func deleteMedia(withId mediaId: Media.ID) async throws
}
