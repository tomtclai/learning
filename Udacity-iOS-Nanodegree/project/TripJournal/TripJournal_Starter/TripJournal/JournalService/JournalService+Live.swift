//
//  JournalService+Live.swift
//  TripJournal
//
//  Created by Tom Lai on 6/26/25.
//
import Combine
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class LiveJournalService: JournalService, ObservableObject {
    @Published private var token: Token?

    private let baseURL: URL
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(baseURL: URL = URL(string: "http://localhost:8000")!, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token.map { $0 != nil }.eraseToAnyPublisher()
    }

    private func makeURL(_ path: String) -> URL { baseURL.appendingPathComponent(path) }

    private func request(path: String, method: HTTPMethod, body: Data? = nil, contentType: String? = nil, requireAuth: Bool = true) throws -> URLRequest {
        var request = URLRequest(url: makeURL(path))
        request.httpMethod = method.rawValue
        request.httpBody = body
        if let contentType = contentType { request.setValue(contentType, forHTTPHeaderField: "Content-Type") }
        if requireAuth {
            guard let token = token else { throw ValidationError.signedOut }
            request.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    private func send<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw ResponseError.errorCode(code)
        }
        return try decoder.decode(T.self, from: data)
    }

    private func send(_ request: URLRequest) async throws {
        let (_, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw ResponseError.errorCode(code)
        }
    }

    private func setToken(_ token: Token) {
        DispatchQueue.main.async {
            self.token = token
        }
    }

    func register(username: String, password: String) async throws -> Token {
        let body = try encoder.encode(CreateUserRequest(username: username, password: password))
        let request = try request(path: "register", method: .post, body: body, contentType: "application/json", requireAuth: false)
        let token: Token = try await send(request)
        setToken(token)
        return token
    }

    func logIn(username: String, password: String) async throws -> Token {
        let form = "username=\(username)&password=\(password)"
        let request = try request(path: "token", method: .post, body: Data(form.utf8), contentType: "application/x-www-form-urlencoded", requireAuth: false)
        let token: Token = try await send(request)
        setToken(token)
        return token
    }

    func logOut() { token = nil }

    func createTrip(with trip: TripCreate) async throws -> Trip {
        let body = try encoder.encode(trip)
        let request = try request(path: "trips", method: .post, body: body, contentType: "application/json")
        return try await send(request)
    }

    func getTrips() async throws -> [Trip] {
        let request = try request(path: "trips", method: .get)
        return try await send(request)
    }

    func getTrip(withId id: Trip.ID) async throws -> Trip {
        let request = try request(path: "trips/\(id)", method: .get)
        return try await send(request)
    }

    func updateTrip(withId id: Trip.ID, and tripUpdate: TripUpdate) async throws -> Trip {
        let body = try encoder.encode(tripUpdate)
        let request = try request(path: "trips", method: .put, body: body, contentType: "application/json")
        return try await send(request)
    }

    func deleteTrip(withId id: Trip.ID) async throws {
        let request = try request(path: "trips/\(id)", method: .delete)
        try await send(request)
    }

    func createEvent(with event: EventCreate) async throws -> Event {
        let body = try encoder.encode(event)
        let request = try request(path: "events", method: .post, body: body, contentType: "application/json")
        return try await send(request)
    }

    func updateEvent(withId id: Event.ID, and event: EventUpdate) async throws -> Event {
        let body = try encoder.encode(event)
        let request = try request(path: "events/\(id)", method: .put, body: body, contentType: "application/json")
        return try await send(request)
    }

    func deleteEvent(withId id: Event.ID) async throws {
        let request = try request(path: "events/\(id)", method: .delete)
        try await send(request)
    }

    func createMedia(with mediaCreate: MediaCreate) async throws -> Media {
        let body = try encoder.encode(mediaCreate)
        let request = try request(path: "media", method: .post, body: body, contentType: "application/json")
        return try await send(request)
    }

    func deleteMedia(withId id: Media.ID) async throws {
        let request = try request(path: "media/\(id)", method: .delete)
        try await send(request)
    }
}
