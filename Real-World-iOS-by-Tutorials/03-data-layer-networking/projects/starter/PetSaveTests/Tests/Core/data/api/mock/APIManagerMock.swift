//
//  APIManagerMock.swift
//  PetSaveTests
//
//  Created by tom on 10/16/22.
//  Copyright © 2022 Ray Wenderlich. All rights reserved.
//
import Foundation
@testable import PetSave
struct APIManagerMock: APIManagerProtocol {
  func perform(request: RequestProtocol, authToken: String) async throws -> Data {
    return try Data(contentsOf: URL(fileURLWithPath: request.path), options: .mappedIfSafe)
  }

  func requestToken() async throws -> Data {
    return Data()
  }
}
