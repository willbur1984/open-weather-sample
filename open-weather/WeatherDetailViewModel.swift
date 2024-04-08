//
//  WeatherDetailViewModel.swift
//  open-weather
//
//  Created by William Towe on 4/7/24.
//

import Combine
import CombineExt
import Feige
import Foundation
import Moya
import SwiftyJSON
import UIKit

extension UnitTemperature {
    // MARK: - Public Properties
    static var current: UnitTemperature {
        Locale.current.usesMetricSystem ? .celsius : .fahrenheit
    }
}

extension NSDiffableDataSourceSnapshot: ScopeFunctions {}

final class WeatherDetailViewModel: BaseViewModel {
    // MARK: - Public Types
    enum Section: Hashable {
        case `default`
    }
    
    enum Item: Hashable {
        case `default`(imageURL: URL?, title: String)
    }
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: - Public Properties
    var title: AnyPublisher<String, Never> {
        $response.map(\.name)
            .eraseToAnyPublisher()
    }
    
    @Published
    private(set) var snapshot = Snapshot()
    
    // MARK: - Private Properties
    @Published
    private var response: WeatherResponse
    private let networkManager: NetworkManager
    
    // MARK: - Public Functions
    func refresh() -> AnyPublisher<WeatherResponse?, MoyaError> {
        networkManager.refreshWeather(response: response)
            .handleEvents(receiveOutput: { [weak self] in
                guard let self, let response = $0 else {
                    return
                }
                self.response = response
            })
            .eraseToAnyPublisher()
    }
    
    // MARK: - Override Functions
    override func setup() {
        super.setup()
        
        $response.map { response in
            Snapshot().also {
                $0.appendSections([.default])
                $0.appendItems([
                    .default(imageURL: response.weatherIconURL, title: response.weatherDescription.localizedCapitalized),
                    .default(imageURL: nil, title: String.localizedStringWithFormat("Temperature: %@", Measurement<UnitTemperature>(value: response.temperature, unit: .current).formatted())),
                    .default(imageURL: nil, title: String.localizedStringWithFormat("Feels like: %@", Measurement<UnitTemperature>(value: response.temperatureFeelsLike, unit: .current).formatted())),
                    .default(imageURL: nil, title: String.localizedStringWithFormat("Low: %@", Measurement<UnitTemperature>(value: response.temperatureLow, unit: .current).formatted())),
                    .default(imageURL: nil, title: String.localizedStringWithFormat("High: %@", Measurement<UnitTemperature>(value: response.temperatureHigh, unit: .current).formatted()))
                ])
            }
        }
        .assign(to: \WeatherDetailViewModel.snapshot, on: self, ownership: .weak)
        .store(in: &cancellables)
    }
    
    // MARK: - Initializers
    init(response: WeatherResponse, networkManager: NetworkManager = .shared) {
        self.response = response
        self.networkManager = networkManager
        
        super.init()
    }
}
