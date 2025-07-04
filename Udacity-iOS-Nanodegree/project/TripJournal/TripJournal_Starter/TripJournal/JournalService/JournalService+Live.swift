//
//  JournalService+Live.swift
//  TripJournal
//
//  Created by Tom Lai on 6/26/25.
//

import Combine
import Foundation
class LiveJournalService: JournalService, ObservableObject {
    @Published private var token: Token?

    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }

    
    func register(username: String, password: String) async throws -> Token {
        let url = URL(string: "http://localhost:8000/register")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        let requestObject = CreateUserRequest(
            username: username,
            password: password
        )
        let requestData = try JSONEncoder().encode(requestObject)
        urlRequest.httpBody = requestData
        let response = try await URLSession.shared.data(for: urlRequest)
        let data = response.0
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let token = try decoder.decode(Token.self, from: data)
            DispatchQueue.main.async{
                self.token = token
            }
            return token
        } catch {
            print("Decoding failed with error: \(error)")
            print("Raw response: \(String(data: data, encoding: .utf8) ?? "N/A")")
            throw error
        }
    }
    
    func logOut() {
        fatalError("Unimplemented logOut")
    }

    func logIn(username: String, password: String) async throws -> Token {
        
        let url = URL(string: "http://localhost:8000/token")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        let bodyString = [
            "username": username,
            "password": password
        ].map { "\($0.key)=\($0.value)"}.joined(separator: "&")
        urlRequest.httpBody = Data(bodyString.utf8)
        
        let response = try await URLSession.shared.data(for: urlRequest)
        let data = response.0
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let token = try decoder.decode(Token.self, from: data)
            DispatchQueue.main.async{
                self.token = token
            }
            return token
        } catch {
            print("Decoding failed with error: \(error)")
            print("Raw response: \(String(data: data, encoding: .utf8) ?? "N/A")")
            throw error
        }
    }

    func createTrip(with trip: TripCreate) async throws -> Trip {
        let url = URL(string: "http://localhost:8000/trips")!
        var urlRequest = URLRequest(url: url)
        guard let token = token else {
            throw ValidationError.signedOut
        }
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        let requestObject = trip
        let coder = JSONEncoder()
        coder.keyEncodingStrategy = .convertToSnakeCase
        let requestData = try coder.encode(requestObject)
        urlRequest.httpBody = requestData
        let response = try await URLSession.shared.data(for: urlRequest)
        let data = response.0
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        do {
            let trip = try decoder.decode(Trip.self, from: data)
            return trip
        } catch {
            print("Decoding failed with error: \(error)")
            print("Raw response: \(String(data: data, encoding: .utf8) ?? "N/A")")
            throw error
        }
    }

    func getTrips() async throws -> [Trip] {
        return []
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
