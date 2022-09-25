import Foundation
// 1
private struct AnimalsMock: Codable {
  let animals: [Animal]
}
// 2
private func loadAnimals() -> [Animal] {
  guard let url = Bundle.main.url(
    forResource: "AnimalsMock",
    withExtension: "json"
  ), let data = try? Data(contentsOf: url) else { return [] }
  let decoder = JSONDecoder()
  // 3
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  let jsonMock = try? decoder.decode(AnimalsMock.self, from:
data)
  return jsonMock?.animals ?? []
}
// 4
extension Animal {
  static let mock = loadAnimals()
}
