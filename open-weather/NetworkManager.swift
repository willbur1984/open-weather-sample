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

final class NetworkManager {
    // MARK: - Public Properties
    static let shared = NetworkManager()
    
    // MARK: - Private Properties
    private let openWeatherAPIKey = "b01f7368b1c91afa52622b262087a736"
    private let queue = DispatchQueue(label: "network-manager")
    private let provider: MoyaProvider<OpenWeatherTarget>
    
    // MARK: - Public Functions
    func weather(query: String) -> AnyPublisher<JSON?, MoyaError> {
        requestPublisher(target: .directGeocode(query: query, apiKey: openWeatherAPIKey))
            .map {
                $0?.array?.first?.let {
                    DirectGeocodeResponse(json: $0)
                }
            }
            .flatMap { [weak self] in
                guard let self, let response = $0 else {
                    return Just<JSON?>(nil)
                        .setFailureType(to: MoyaError.self)
                        .eraseToAnyPublisher()
                }
                return self.requestPublisher(target: .weather(latitude: response.latitude, longitude: response.longitude, apiKey: openWeatherAPIKey))
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private Functions
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
