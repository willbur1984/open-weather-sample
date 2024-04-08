//
//  OpenWeatherTarget.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Foundation
import Moya

enum OpenWeatherTarget: TargetType {
    case directGeocode(query: String, apiKey: String)
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
