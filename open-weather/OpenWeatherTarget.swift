//
//  OpenWeatherTarget.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Foundation
import Moya

/**
 Represents the possible requests that can be made to the *Open Weather* API.
 */
enum OpenWeatherTarget: TargetType {
    /**
     The *Direct Geocoding* API, which takes a query and returns latitude/longitude coordinates.
     
     - SeeAlso: https://openweathermap.org/api/geocoding-api#direct
     */
    case directGeocode(query: String, apiKey: String)
    /**
     The *Current Weather* API, which takes a latitude/longitude values and returns various weather information.
     
     - SeeAlso: https://openweathermap.org/current
     */
    case weather(latitude: Double, longitude: Double, apiKey: String)
    
    // MARK: - TargetType
    var baseURL: URL {
        switch self {
        case .directGeocode:
            return URL(string: "https://api.openweathermap.org/geo/1.0/")!
        case .weather:
            return URL(string: "https://api.openweathermap.org/data/2.5/")!
        }
    }
    
    var path: String {
        switch self {
        case .directGeocode:
            return "direct"
        case .weather:
            return "weather"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        switch self {
        case let .directGeocode(query, apiKey):
            return .requestParameters(parameters: [
                "q": query,
                "appid": apiKey,
                "limit": 1
            ], encoding: URLEncoding.queryString)
        case let .weather(latitude, longitude, apiKey):
            return .requestParameters(parameters: [
                "lat": latitude,
                "lon": longitude,
                "appid": apiKey,
                "units": Locale.current.usesMetricSystem ? "metric" : "imperial"
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var validationType: ValidationType {
        .successAndRedirectCodes
    }
    
    var headers: [String : String]? {
        nil
    }
}
