//
//  WeatherResponse.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Foundation
import SwiftyJSON

struct WeatherResponse {
    // MARK: - Public Properties
    let latitude: Double
    let longitude: Double
    let name: String
    let weatherDescription: String
    let weatherIconURL: URL
    let temperature: Double
    let temperatureFeelsLike: Double
    let temperatureLow: Double
    let temperatureHigh: Double
}

extension WeatherResponse {
    // MARK: - Initializers
    init?(json: JSON) {
        guard
            let coordinatesDictionary = json["coord"].dictionary,
            let latitude = coordinatesDictionary["lat"]?.double,
            let longitude = coordinatesDictionary["lon"]?.double,
            let name = json["name"].string,
            let weatherDictionary = json["weather"].array?.first,
            let weatherDescription = weatherDictionary["description"].string,
            let weatherIcon = weatherDictionary["icon"].string,
            let weatherIconURL = URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png"),
            let mainDictionary = json["main"].dictionary,
            let temperature = mainDictionary["temp"]?.double,
            let temperatureFeelsLike = mainDictionary["feels_like"]?.double,
            let temperatureLow = mainDictionary["temp_min"]?.double,
            let temperatureHigh = mainDictionary["temp_max"]?.double else {
            return nil
        }
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.weatherDescription = weatherDescription
        self.weatherIconURL = weatherIconURL
        self.temperature = temperature
        self.temperatureFeelsLike = temperatureFeelsLike
        self.temperatureLow = temperatureLow
        self.temperatureHigh = temperatureHigh
    }
}
