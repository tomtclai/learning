//
//  RequestProtocol.swift
//  PetSave
//
//  Created by tom on 9/26/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//

import Foundation
protocol RequestProtocol {
  var path: String { get }
  var headers: [String: String] { get }
  var params: [String: Any] { get }

  var urlParams: [String: String?] { get }
  var addAuthorizationToken: Bool { get }
  var requestType: RequestType { get }
}

extension RequestProtocol {
  var host: String {
    APIConstants.host
  }

  var addAuthorizationToken: Bool {
    true
  }

  var params: [String: Any] {
    [:]
  }
  var urlParams: [String: String?] {
    [:]
  }
  var headers: [String: String] {
    [:]
  }

  func createURLRequest(authToken: String) throws -> URLRequest {
    var components = URLComponents()
    components.scheme = "https"
    components.host = host
    components.path = path

    if !urlParams.isEmpty {
      components.queryItems = urlParams.map {
        URLQueryItem(name: $0, value: $1)
      }
    }

    guard let url = components.url else {
      throw NetworkError.invalidURL
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = requestType.rawValue

    if !headers.isEmpty {
      urlRequest.allHTTPHeaderFields = headers
    }

    if addAuthorizationToken {
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    if !params.isEmpty {
      urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
    }

    return urlRequest
  }
}
