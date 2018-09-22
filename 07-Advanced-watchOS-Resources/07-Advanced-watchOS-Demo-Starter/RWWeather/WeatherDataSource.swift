/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import Foundation

public enum MeasurementSystem {
  case metric
  case usCustomary
}

public enum WeatherDataInterval {
  case instant
  case day(day: Date)
  case hour(time: Date)
}

public enum WeatherCondition: String {
  case Sunny
  case Cloudy
  case Rain
  case Snow
}

private func ctof(_ temp: Int) -> Int {
  return Int(Double(temp) * 9 / 5 + 32)
}
private func ftoc(_ temp: Int) -> Int {
  return Int((Double(temp) - 32) * 5.0 / 9.0)
}
private func identity(_ temp: Int) -> Int {
  return temp
}
private func mitokm(_ dist: Int) -> Int {
  return Int(Double(dist) * 1.60934)
}
private func kmtomi(_ dist: Int) -> Int {
  return Int(Double(dist) / 1.60934)
}
private var shortHourFormatter: DateFormatter = {
  let f = DateFormatter()
  f.dateFormat = "ha"
  return f
}()
private var shortDayFormatter: DateFormatter = {
  let f = DateFormatter()
  f.dateFormat = "ccc d"
  return f
}()

public struct WeatherData {
  let measurementSystem: MeasurementSystem
  let outputConversion: (Int) -> Int

  let interval: WeatherDataInterval

  fileprivate let _temperature: Int
  var temperature: Int {
    return outputConversion(_temperature)
  }

  fileprivate let _feelTemperature: Int
  var feelTemperature: Int {
    return outputConversion(_feelTemperature)
  }

  fileprivate let _highTemperature: Int
  var highTemperature: Int {
    return outputConversion(_highTemperature)
  }

  fileprivate let _lowTemperature: Int
  var lowTemperature: Int {
    return outputConversion(_lowTemperature)
  }

  fileprivate let _windSpeed: Int
  var windSpeed: Int {
    return measurementSystem == .metric ? _windSpeed : kmtomi(_windSpeed)
  }

  let windDirection: String

  let weatherCondition: WeatherCondition

  var intervalString: String {
    switch interval {
    case .instant:
      return "Now"
    case .hour(let time):
      return shortHourFormatter.string(from: time)
    case .day(let day):
      return shortDayFormatter.string(from: day)
    }
  }

  var intervalDate: Date {
    switch interval {
    case .instant:
      return Date()
    case .hour(let time):
      return time
    case .day(let day):
      return day
    }
  }

  var temperatureString: String {
    return "\(temperature)°"
  }
  var highTemperatureString: String {
    return "\(highTemperature)°"
  }
  var lowTemperatureString: String {
    return "\(lowTemperature)°"
  }
  var feelTemperatureString: String {
    return "Feels like \(feelTemperature)°"
  }
  var weatherConditionString: String {
    return weatherCondition.rawValue
  }
  var weatherConditionImageName: String {
    return weatherCondition.rawValue
  }
  var windString: String {
    return "\(windSpeed)\(measurementSystem == .metric ? "km/h" : "MPH") \(windDirection)"
  }

  init(measurementSystem: MeasurementSystem, interval: WeatherDataInterval, temperature: Int, feelTemperature: Int, highTemperature: Int, lowTemperature: Int, windSpeed: Int, windDirection: String, weatherCondition: WeatherCondition) {
    self.outputConversion = measurementSystem == .metric ? identity : ctof

    self.measurementSystem = measurementSystem
    self.interval = interval
    self._temperature = temperature
    self._feelTemperature = feelTemperature
    self._highTemperature = highTemperature
    self._lowTemperature = lowTemperature
    self._windSpeed = windSpeed

    self.windDirection = windDirection
    self.weatherCondition = weatherCondition
  }
}

open class WeatherDataSource {
  fileprivate(set) var measurementSystem: MeasurementSystem
  fileprivate(set) var currentWeather: WeatherData
  fileprivate(set) var shortTermWeather: [WeatherData] = []
  fileprivate(set) var longTermWeather: [WeatherData] = []

  public init(measurementSystem: MeasurementSystem) {
    self.measurementSystem = measurementSystem

    currentWeather = WeatherData(measurementSystem: measurementSystem, interval: .instant, temperature: 16, feelTemperature: 15, highTemperature: 16, lowTemperature: 16, windSpeed: 8, windDirection: "NE", weatherCondition: .Cloudy)

    shortTermWeather = [
      WeatherData(measurementSystem: measurementSystem, interval: .hour(time: Date().dateByAddingsHours(1)), temperature: 16, feelTemperature: 15, highTemperature: 16, lowTemperature: 16, windSpeed: 8, windDirection: "NE", weatherCondition: .Sunny),
      WeatherData(measurementSystem: measurementSystem, interval: .hour(time: Date().dateByAddingsHours(2)), temperature: 19, feelTemperature: 15, highTemperature: 16, lowTemperature: 16, windSpeed: 8, windDirection: "NE", weatherCondition: .Cloudy),
      WeatherData(measurementSystem: measurementSystem, interval: .hour(time: Date().dateByAddingsHours(3)), temperature: 21, feelTemperature: 22, highTemperature: 16, lowTemperature: 16, windSpeed: 8, windDirection: "NE", weatherCondition: .Rain),
      WeatherData(measurementSystem: measurementSystem, interval: .hour(time: Date().dateByAddingsHours(4)), temperature: 22, feelTemperature: 22, highTemperature: 16, lowTemperature: 16, windSpeed: 8, windDirection: "NE", weatherCondition: .Cloudy),
      WeatherData(measurementSystem: measurementSystem, interval: .hour(time: Date().dateByAddingsHours(5)), temperature: 20, feelTemperature: 21, highTemperature: 16, lowTemperature: 16, windSpeed: 8, windDirection: "NE", weatherCondition: .Snow),
      WeatherData(measurementSystem: measurementSystem, interval: .hour(time: Date().dateByAddingsHours(6)), temperature: 21, feelTemperature: 20, highTemperature: 16, lowTemperature: 16, windSpeed: 9, windDirection: "SW", weatherCondition: .Rain),
      WeatherData(measurementSystem: measurementSystem, interval: .hour(time: Date().dateByAddingsHours(7)), temperature: 18, feelTemperature: 19, highTemperature: 18, lowTemperature: 14, windSpeed: 5, windDirection: "NW", weatherCondition: .Snow)
    ]

    longTermWeather = [
      WeatherData(measurementSystem: measurementSystem, interval: .day(day: Date().dateByAddingsDays(1)), temperature: 16, feelTemperature: 15, highTemperature: 16, lowTemperature: 16, windSpeed: 8, windDirection: "NE", weatherCondition: .Cloudy),
      WeatherData(measurementSystem: measurementSystem, interval: .day(day: Date().dateByAddingsDays(2)), temperature: 17, feelTemperature: 15, highTemperature: 18, lowTemperature: 14, windSpeed: 8, windDirection: "NE", weatherCondition: .Rain),
      WeatherData(measurementSystem: measurementSystem, interval: .day(day: Date().dateByAddingsDays(3)), temperature: 18, feelTemperature: 19, highTemperature: 20, lowTemperature: 14, windSpeed: 8, windDirection: "NE", weatherCondition: .Sunny),
      WeatherData(measurementSystem: measurementSystem, interval: .day(day: Date().dateByAddingsDays(4)), temperature: 17, feelTemperature: 15, highTemperature: 16, lowTemperature: 16, windSpeed: 8, windDirection: "NE", weatherCondition: .Sunny),
      WeatherData(measurementSystem: measurementSystem, interval: .day(day: Date().dateByAddingsDays(5)), temperature: 16, feelTemperature: 14, highTemperature: 16, lowTemperature: 16, windSpeed: 8, windDirection: "NE", weatherCondition: .Snow)
    ]
  }
}

private extension Date {
  static func calendar() -> Calendar {
    return Calendar.autoupdatingCurrent
  }

  func dateByAddingsDays(_ days: NSInteger) -> Date {
    var dateComponents = DateComponents()
    dateComponents.day = days

    return (Date.calendar() as NSCalendar).date(byAdding: dateComponents, to: self, options: [])!
  }

  func dateByAddingsHours(_ hours: NSInteger) -> Date {
    return self.addingTimeInterval(Double(hours) * 60 * 60)
  }
}
