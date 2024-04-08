//
//  NetworkManager.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Combine
import Feige
import Foundation
import Moya
import os.log
import SwiftyJSON

extension JSON: ScopeFunctions {}

/**
 Represents the required functions needed by the various view models in the app.
 
 - Note: This could be mocked in unit tests and injected into the view models if you did not want to worry about actually making network calls
 */
protocol NetworkManagerInterface {
    // MARK: - Public Functions
    func weather(query: String) -> AnyPublisher<WeatherResponse?, MoyaError>
    func refreshWeather(response: WeatherResponse) -> AnyPublisher<WeatherResponse?, MoyaError>
}

/**
 Manages access to the *Open Weather* API.
 */
final class NetworkManager: NetworkManagerInterface {
    // MARK: - Public Properties
    /**
     Returns the shared instance.
     
     - Note: `init()` is private, so you must use `shared` to access
     */
    static let shared = NetworkManager()
    
    // MARK: - Private Properties
    private let openWeatherAPIKey = "b01f7368b1c91afa52622b262087a736"
    private let queue = DispatchQueue(label: "network-manager")
    private let provider: MoyaProvider<OpenWeatherTarget>
    
    // MARK: - Public Functions
    /**
     Returns a publisher that requests the weather conditions from the *Open Weather* API, then either sends a decoded `WeatherResponse` or fails with an error.
     
     - Parameter query: The query string to search for (e.g. `"Philadelphia"`)
     - Returns: A publisher
     */
    func weather(query: String) -> AnyPublisher<WeatherResponse?, MoyaError> {
        requestPublisher(target: .directGeocode(query: query, apiKey: openWeatherAPIKey))
            .map {
                $0?.array?.first?.let {
                    DirectGeocodeResponse(json: $0)
                }
            }
            .flatMap { [weak self] in
                guard let self, let response = $0 else {
                    return Just<WeatherResponse?>(nil)
                        .setFailureType(to: MoyaError.self)
                        .eraseToAnyPublisher()
                }
                return self.weatherPrivate(latitude: response.latitude, longitude: response.longitude)
            }
            .eraseToAnyPublisher()
    }
    
    /**
     Returns a publisher that requests the weather conditions for the provided `response` from the *Open Weather* API, then either sends an updated `WeatherResponse` or fails with an error.
     
     - Parameter response: The weather response to refresh
     - Returns: The publisher
     */
    func refreshWeather(response: WeatherResponse) -> AnyPublisher<WeatherResponse?, MoyaError> {
        weatherPrivate(latitude: response.latitude, longitude: response.longitude)
    }
    
    // MARK: - Private Functions
    private func weatherPrivate(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponse?, MoyaError> {
        requestPublisher(target: .weather(latitude: latitude, longitude: longitude, apiKey: openWeatherAPIKey))
            .map {
                $0?.let {
                    WeatherResponse(json: $0)
                }
            }
            .handleEvents(receiveOutput: {
                os_log("response %@", String(describing: $0))
            })
            .eraseToAnyPublisher()
    }
    
    private func requestPublisher(target: OpenWeatherTarget) -> AnyPublisher<JSON?, MoyaError> {
        provider.requestPublisher(target)
            .map {
                JSON($0.data)
            }
            .handleEvents(receiveOutput: {
                os_log("json %@", String(describing: $0))
            }, receiveCompletion: {
                os_log("completion %@", String(describing: $0))
            })
            .eraseToAnyPublisher()
    }
    
    // MARK: - Initializers
    private init() {
        provider = MoyaProvider(callbackQueue: queue)
    }
}
