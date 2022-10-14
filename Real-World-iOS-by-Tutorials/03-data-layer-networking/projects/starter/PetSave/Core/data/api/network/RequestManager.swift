protocol RequestManagerProtocol {
  func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}
class RequestManager: RequestManagerProtocol {

  let apiManager: APIManagerProtocol
  let parser: DataParserProtocol
  let accessTokenManger: AccessTokenManagerProtocol
  init(apiManager: APIManagerProtocol = APIManager(), parser: DataParserProtocol = DataParser(), accessTokenManger: AccessTokenManagerProtocol = AccessTokenManager()) {
    self.apiManager = apiManager
    self.parser = parser
    self.accessTokenManger = accessTokenManger
  }

  func perform<T>(_ request: RequestProtocol) async throws -> T where T : Decodable {
    let authToken = try await requestAccessToken()
    let data = try await apiManager.perform(request: request, authToken: authToken)
    let decoded: T = try parser.parse(data: data)
    return decoded
  }
  func requestAccessToken() async throws -> String {

    if accessTokenManger.isTokenValid() {
      return accessTokenManger.fetchToken()
    }

    let data = try await apiManager.requestToken()
    let token: APIToken = try parser.parse(data: data)

    try accessTokenManger.refreshWith(apiToken: token)
    return token.bearerAccessToken

  }
}
