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
        let url = URL(string: "http://localhost:8000/trips")!
        var urlRequest = URLRequest(url: url)
        guard let token = token else {
            throw ValidationError.signedOut
        }
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        let response = try await URLSession.shared.data(for: urlRequest)
        let data = response.0
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        do {
            let trips = try decoder.decode([Trip].self, from: data)
            return trips
        } catch {
            print("Decoding failed with error: \(error)")
            print("Raw response: \(String(data: data, encoding: .utf8) ?? "N/A")")
            throw error
        }
    }

    func getTrip(withId id: Trip.ID) async throws -> Trip {
        let url = URL(string: "http://localhost:8000/trips/\(id)")!
        var urlRequest = URLRequest(url: url)
        guard let token = token else {
            throw ValidationError.signedOut
        }
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
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

    func updateTrip(withId id: Trip.ID, and tripUpdate: TripUpdate) async throws -> Trip {
        let url = URL(string: "http://localhost:8000/trips")!
        var urlRequest = URLRequest(url: url)
        guard let token = token else {
            throw ValidationError.signedOut
        }
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        let requestObject = tripUpdate
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

    func deleteTrip(withId id: Trip.ID) async throws {
        let url = URL(string: "http://localhost:8000/trips/\(id)")!
        var urlRequest = URLRequest(url: url)
        guard let token = token else {
            throw ValidationError.signedOut
        }
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        let response = try await URLSession.shared.data(for: urlRequest)
        let urlresponse = response.1 as! HTTPURLResponse
        
        guard 200..<300 ~= urlresponse.statusCode else {
            throw ResponseError.errorCode(urlresponse.statusCode)
        }
         
        return
    }

    func createEvent(with event: EventCreate) async throws -> Event {
        let url = URL(string: "http://localhost:8000/events")!
        var urlRequest = URLRequest(url: url)
        guard let token = token else {
            throw ValidationError.signedOut
        }
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        let requestObject = event
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
            let event = try decoder.decode(Event.self, from: data)
            return event
        } catch {
            print("Decoding failed with error: \(error)")
            print("Raw response: \(String(data: data, encoding: .utf8) ?? "N/A")")
            throw error
        }
    }

    func updateEvent(withId id: Event.ID, and event: EventUpdate) async throws -> Event {
        let url = URL(string: "http://localhost:8000/events/\(id)")!
        var urlRequest = URLRequest(url: url)
        guard let token = token else {
            throw ValidationError.signedOut
        }
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        let requestObject = event
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
            let event = try decoder.decode(Event.self, from: data)
            return event
        } catch {
            print("Decoding failed with error: \(error)")
            print("Raw response: \(String(data: data, encoding: .utf8) ?? "N/A")")
            throw error
        }
    }

    func deleteEvent(withId id: Event.ID) async throws {
        let url = URL(string: "http://localhost:8000/events/\(id)")!
        var urlRequest = URLRequest(url: url)
        guard let token = token else {
            throw ValidationError.signedOut
        }
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        let response = try await URLSession.shared.data(for: urlRequest)
        let urlresponse = response.1 as! HTTPURLResponse
        
        guard 200..<300 ~= urlresponse.statusCode else {
            throw ResponseError.errorCode(urlresponse.statusCode)
        }
         
        return
    }

    func createMedia(with mediaCreate: MediaCreate) async throws -> Media {
        let url = URL(string: "http://localhost:8000/media")!
        var urlRequest = URLRequest(url: url)
        guard let token = token else {
            throw ValidationError.signedOut
        }
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        let requestObject = mediaCreate
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
            let event = try decoder.decode(Media.self, from: data)
            return event
        } catch {
            print("Decoding failed with error: \(error)")
            print("Raw response: \(String(data: data, encoding: .utf8) ?? "N/A")")
            throw error
        }
    }

    func deleteMedia(withId id: Media.ID) async throws {
        let url = URL(string: "http://localhost:8000/media/\(id)")!
        var urlRequest = URLRequest(url: url)
        guard let token = token else {
            throw ValidationError.signedOut
        }
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("\(token.tokenType) \(token.accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        let response = try await URLSession.shared.data(for: urlRequest)
        let urlresponse = response.1 as! HTTPURLResponse
        
        guard 200..<300 ~= urlresponse.statusCode else {
            throw ResponseError.errorCode(urlresponse.statusCode)
        }
         
        return
    }
    
}
