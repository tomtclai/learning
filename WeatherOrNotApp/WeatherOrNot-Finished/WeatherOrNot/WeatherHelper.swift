/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import PromiseKit

private let appID = "<#Enter Your API Key from http://openweathermap.org/appid#>"

class WeatherHelper {
  struct WeatherInfo: Codable {
    let main: Temperature
    let weather: [Weather]
    var name: String = "Error: invalid jsonDictionary! Verify your appID is correct"
  }

  struct Weather: Codable {
    let icon: String
    let description: String
  }

  struct Temperature: Codable {
    let temp: Double
  }

  func getWeatherTheOldFashionedWay(coordinate: CLLocationCoordinate2D, completion: @escaping (WeatherInfo?, Error?) -> Void) {
    let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(appID)"

    guard let url = URL(string: urlString) else {
      preconditionFailure("Failed creating API URL - Make sure you set your OpenWeather API Key")
    }

    URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data,
            let result = try? JSONDecoder().decode(WeatherInfo.self, from: data) else {
        completion(nil, error)
        return
      }
      
      completion(result, nil)
    }.resume()
  }

  func getWeather(atLatitude latitude: Double, longitude: Double) -> Promise<WeatherInfo> {
    let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=" +
      "\(latitude)&lon=\(longitude)&appid=\(appID)"
    let url = URL(string: urlString)!

    return firstly {
      URLSession.shared.dataTask(.promise, with: url)
    }.compactMap {
      return try JSONDecoder().decode(WeatherInfo.self, from: $0.data)
    }
  }

  func getIcon(named iconName: String) -> Promise<UIImage> {
    return Promise<UIImage> {
      getFile(named: iconName, completion: $0.resolve)
    }
    .recover { _ in
      self.getIconFromNetwork(named: iconName)
    }
  }

  func getIconFromNetwork(named iconName: String) -> Promise<UIImage> {
    let urlString = "http://openweathermap.org/img/w/\(iconName).png"
    let url = URL(string: urlString)!

    return firstly {
      URLSession.shared.dataTask(.promise, with: url)
    }
    .then(on: DispatchQueue.global(qos: .background)) { urlResponse in
      return Promise {
        self.saveFile(named: iconName, data: urlResponse.data, completion: $0.resolve)
      }
      .then(on: DispatchQueue.global(qos: .background)) {
        return Promise.value(UIImage(data: urlResponse.data)!)
      }
    }
  }

  
  private func saveFile(named: String, data: Data, completion: @escaping (Error?) -> Void) {
    guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(named+".png") else { return }

    DispatchQueue.global(qos: .background).async {
      do {
        try data.write(to: path)
        print("Saved image to: " + path.absoluteString)
        completion(nil)
      } catch {
        completion(error)
      }
    }
  }
  
  private func getFile(named: String, completion: @escaping (UIImage?, Error?) -> Void) {
    DispatchQueue.global(qos: .background).async {
      if let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(named+".png"),
        let data = try? Data(contentsOf: path),
        let image = UIImage(data: data) {
        DispatchQueue.main.async { completion(image, nil) }
      } else {
        let error = NSError(domain: "WeatherOrNot",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: "Image file '\(named)' not found."])
        DispatchQueue.main.async { completion(nil, error) }
      }
    }
  }
}
