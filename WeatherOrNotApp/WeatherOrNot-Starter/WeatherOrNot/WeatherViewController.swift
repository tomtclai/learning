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

import UIKit
import PromiseKit
import CoreLocation

private let errorColor = UIColor(red: 0.96, green: 0.667, blue: 0.690, alpha: 1)
private let oneHour: TimeInterval = 3600 // Seconds per hour
private let randomCities = [("Tokyo", "JP", 35.683333, 139.683333),
                            ("Jakarta", "ID", -6.2, 106.816667),
                            ("Delhi", "IN", 28.61, 77.23),
                            ("Manila", "PH", 14.58, 121),
                            ("São Paulo", "BR", -23.55, -46.633333)]

class WeatherViewController: UIViewController {
  @IBOutlet private var placeLabel: UILabel!
  @IBOutlet private var tempLabel: UILabel!
  @IBOutlet private var iconImageView: UIImageView!
  @IBOutlet private var conditionLabel: UILabel!
  @IBOutlet private var randomWeatherButton: UIButton!
  
  let weatherAPI = WeatherHelper()
  let locationHelper = LocationHelper()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    updateWithCurrentLocation()
  }
  
  private func updateWithCurrentLocation() {
    locationHelper.getLocation()
      .done { [weak self] placemark in
        // You use a helper class to work with core location, you will implement it. The result is a promise to get a placemark for the current location.
        self?.handleLocation(placemark: placemark)
    }
      .catch { [weak self] error in
        // This catch block demonstrates how you handle different errors within a single catch block. here you use a simple switch to provide a different message when the user hasn't granted location privileges vs other types of errors
        guard let sSelf = self else { return }
        sSelf.tempLabel.text = "--"
        sSelf.placeLabel.text = "--"

        switch error {
        case is CLError where (error as? CLError)?.code == .denied:
          sSelf.conditionLabel.text = "Enable Location Permission in Settings"
          sSelf.conditionLabel.textColor = .white
        default:
          sSelf.conditionLabel.text = error.localizedDescription
          sSelf.conditionLabel.textColor = errorColor
        }
    }

    after(seconds: oneHour).done { [weak self] in
      self?.updateWithCurrentLocation()
    }
  }
  
  private func handleMockLocation() {
    let coordinate = CLLocationCoordinate2DMake(37.966667, 23.716667)
    handleLocation(city: "Athens", state: "Greece", coordinate: coordinate)
  }
  
  private func handleLocation(placemark: CLPlacemark) {
    handleLocation(city: placemark.locality,
                   state: placemark.administrativeArea,
                   coordinate: placemark.location!.coordinate)
  }
  
  private func handleLocation(city: String?,
                              state: String?,
                              coordinate: CLLocationCoordinate2D) {
    if let city = city,
       let state = state {
      placeLabel.text = "\(city), \(state)"
    }

    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    weatherAPI.getWeather2(atLatitude: coordinate.latitude, longitude: coordinate.longitude)

      // you change the then block to returning a promise instead of void. this means when getWeather compeltes you return a new promise.

      .then { [weak self] weatherInfo -> Promise<UIImage> in
        guard let self = self else { return brokenPromise() }
        self.updateUI(with: weatherInfo)
        // You use your just added get icon method to create a new promise to get the icon
        return self.weatherAPI.getIcon(named: weatherInfo.weather.first!.icon)
      }
      // you add a new done which will execute on the main queue when the get icon promise completes
      // No need to speicify Queue.main for your done block, this is the default
      .done(on: DispatchQueue.main) { icon in
        self.iconImageView.image = icon
      }
      .catch { [weak self] error in
        guard let self = self else { return }
        self.tempLabel.text = "--"
        self.conditionLabel.text = error.localizedDescription
        self.conditionLabel.textColor = errorColor
      }.finally {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
  }
  
  private func updateUI(with weatherInfo: WeatherHelper.WeatherInfo) {
    let tempMeasurement = Measurement(value: weatherInfo.main.temp, unit: UnitTemperature.kelvin)
    let formatter = MeasurementFormatter()
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .none
    formatter.numberFormatter = numberFormatter
    let tempStr = formatter.string(from: tempMeasurement)
    self.tempLabel.text = tempStr
    self.placeLabel.text = weatherInfo.name
    self.conditionLabel.text = weatherInfo.weather.first?.description ?? "empty"
    self.conditionLabel.textColor = UIColor.white
  }
  
  @IBAction func showRandomWeather(_ sender: AnyObject) {
    randomWeatherButton.isEnabled = false
    let weatherPromises = randomCities.map {
      weatherAPI.getWeather2(atLatitude: $0.2, longitude: $0.3)
    }

    UIApplication.shared.isNetworkActivityIndicatorVisible = true

    race(weatherPromises)
      .then { [weak self] weatherInfo -> Promise<UIImage> in
        guard let self = self else { return brokenPromise() }
        self.placeLabel.text = weatherInfo.name
        self.updateUI(with: weatherInfo)

        return self.weatherAPI.getIcon(named: weatherInfo.weather.first!.icon)
    }
      .done { icon in
        self.iconImageView.image = icon
    }
      .catch { error in
        self.tempLabel.text = "--"
        self.conditionLabel.text = error.localizedDescription
        self.conditionLabel.textColor = errorColor
    }
      .finally {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.randomWeatherButton.isEnabled = true
    }
  }
}

// MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    guard let text = textField.text else { return false }

    locationHelper.searchForPlacemark(text: text)
      .done { [weak self] placemark in
        guard let self = self else { return }
        self.handleLocation(placemark: placemark)
    }
      .catch { _ in }

    return true
  }
}
