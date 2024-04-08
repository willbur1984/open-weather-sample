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
    /**
     Returns the current `UnitTemperature` based on the user's locale.
     */
    static var current: UnitTemperature {
        Locale.autoupdatingCurrent.usesMetricSystem ? .celsius : .fahrenheit
    }
}

extension NSDiffableDataSourceSnapshot: ScopeFunctions {}

/**
 Manages the state required for the `WeatherDetailViewController`.
 */
final class WeatherDetailViewModel: BaseViewModel {
    // MARK: - Public Types
    /**
     Represents a section in a vended `Snapshot`.
     */
    enum Section: Hashable {
        /**
         The default section (there is only 1).
         */
        case `default`
    }
    
    /**
     Represents an item in a vended `Snapshot`.
     */
    enum Item: Hashable {
        /**
         The default item consisting of an options `imageURL` and non-nil `title`.
         */
        case `default`(imageURL: URL?, title: String)
    }
    
    /**
     Convenience typedef for snapshot values.
     */
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: - Public Properties
    /**
     Returns a publisher that sends the view controller title that should be displayed to the user and never fails.
     */
    var title: AnyPublisher<String, Never> {
        $response.map(\.name)
            .eraseToAnyPublisher()
    }
    
    /**
     Returns the current snapshot value.
     */
    @Published
    private(set) var snapshot = Snapshot()
    
    // MARK: - Private Properties
    @Published
    private var response: WeatherResponse
    private let networkManager: NetworkManagerInterface
    
    // MARK: - Public Functions
    /**
     Returns a publisher that refreshes the current weather data, then sends an updated response or fails with an error.
     
     - Returns: The publisher
     */
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
        
        NotificationCenter.default.publisher(for: NSLocale.currentLocaleDidChangeNotification)
            .map { _ in
                ()
            }
            .prepend(())
            .combineLatest($response)
            .map { _, response in
                Snapshot().also {
                    $0.appendSections([.default])
                    $0.appendItems([
                        .default(imageURL: response.weatherIconURL, title: response.weatherDescription.localizedCapitalized),
                        .default(imageURL: nil, title: String.localizedStringWithFormat("Temperature: %@", Measurement<UnitTemperature>(value: response.temperature, unit: .kelvin).converted(to: .current).formatted())),
                        .default(imageURL: nil, title: String.localizedStringWithFormat("Feels like: %@", Measurement<UnitTemperature>(value: response.temperatureFeelsLike, unit: .kelvin).converted(to: .current).formatted())),
                        .default(imageURL: nil, title: String.localizedStringWithFormat("Low: %@", Measurement<UnitTemperature>(value: response.temperatureLow, unit: .kelvin).converted(to: .current).formatted())),
                        .default(imageURL: nil, title: String.localizedStringWithFormat("High: %@", Measurement<UnitTemperature>(value: response.temperatureHigh, unit: .kelvin).converted(to: .current).formatted()))
                    ])
                }
            }
            .assign(to: \WeatherDetailViewModel.snapshot, on: self, ownership: .weak)
            .store(in: &cancellables)
    }
    
    // MARK: - Initializers
    /**
     Creates an instance.
     
     - Parameter response: The previously obtained `WeatherResponse`
     - Parameter networkManager: The object conforming to the `NetworkManagerInterface` to use when making network requests
     - Returns: The instance
     */
    init(response: WeatherResponse, networkManager: NetworkManagerInterface = NetworkManager.shared) {
        self.response = response
        self.networkManager = networkManager
        
        super.init()
    }
}
