

protocol RequestManagerProtocol {
  func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}


final class RequestManager: RequestManagerProtocol {
  let apiManager: APIManagerProtocol
  let parser: DataParserProtocol
  let accessTokenManager: AccessTokenManagerProtocol

  init(
    apiManager: APIManagerProtocol = APIManager(),
    parser: DataParserProtocol = DataParser(),
    accessTokenManager: AccessTokenManagerProtocol = AccessTokenManager()
  ) {
    self.apiManager = apiManager
    self.parser = parser
    self.accessTokenManager = accessTokenManager
  }

  func requestAccessToken() async throws -> String {
    if accessTokenManager.isTokenValid() {
      return accessTokenManager.fetchToken()
    }

    let data = try await apiManager.requestToken()
    let token: APIToken = try parser.parse(data: data)
    try accessTokenManager.refreshWith(apiToken: token)
    return token.bearerAccessToken
  }

  func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
    let authToken = try await requestAccessToken()
    let data = try await apiManager.perform(request, authToken: authToken)
    let decoded: T = try parser.parse(data: data)
    return decoded
  }
}
